{
  lib,
  stdenv,
  pkgsBuildBuild,
  pkgsBuildTarget,
  pkgsHostHost,
  fetchFromGitHub,
  ...
}@args:

lib.makeOverridable ({
  llvmPackages ? pkgsBuildTarget.llvmPackages_latest,
  instSetArch ? pkgsBuildTarget.stdenv.hostPlatform.gccarch or null,
  platformConfig ? { },
  extraConfig ? { },
  firmwarePackages ? (with pkgsHostHost; [
    linux-firmware
    sof-firmware
    wireless-regdb
  ]),
  platformFirmware ? [ ],
  extraFirmware ? [ ],
  platformProfiles ? { },
  extraProfiles ? { },
  ...
}:

let
  kernel = import ./lib.nix { inherit lib; };

  inherit (lib.attrsets)
    filterAttrs
    mapAttrsToList
    mergeAttrsList;

  inherit (lib.strings)
    concatStringsSep;

  inherit (pkgsBuildTarget.stdenv) hostPlatform;

  firmwareEnv = pkgsBuildTarget.buildEnv {
    name = "linux-firmware";
    pathsToLink = [ "/lib/firmware" ];
    paths = firmwarePackages;
  } + "/lib/firmware";

  config = let
    profileConfigs = let
      profiles = platformProfiles // extraProfiles;
    in builtins.readDir ./profile
    |> lib.filterAttrs (name: type: type == "regular")
    |> builtins.attrNames
    |> map (lib.removeSuffix ".nix")
    |> builtins.filter (profile: profiles.${profile} or false)
    |> map (profile: ./profile/${profile}.nix);
    
    forceConfig = {
      MODULES = false;
      EXTRA_FIRMWARE = platformFirmware ++ extraFirmware |> lib.unique;
      EXTRA_FIRMWARE_DIR = kernel.option firmwareEnv;
    };

    args = {
      inherit (kernel) option;
      inherit lib hostPlatform;
    };
  in [ ./config.nix platformConfig ] ++ profileConfigs ++ [ extraConfig forceConfig ]
  |> map (cfg: if builtins.isPath cfg then import cfg else cfg)
  |> map (cfg: if builtins.isFunction cfg then cfg args else cfg)
  |> kernel.mergeConfig;
in stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "linux-hardened";
  version = "6.12.8-hardened1";

  modDirVersion = lib.versions.pad 3 finalAttrs.version;

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = "linux-hardened";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6yMZ/HiMNHUwvc7rrCO/+/o806zN0AJZjVEUXeJCy8M=";
  };

  depsBuildBuild = with pkgsBuildBuild; [
    bc
    bison
    flex
    hexdump
    jq
    openssl
    perl
    python3
    zstd
  ];

  nativeBuildInputs = with pkgsBuildTarget; [
    elfutils
    kmod
  ];

  makeFlags = let
    exe = pkg: prg: lib.getExe' pkg (pkg.targetPrefix or "" + prg);
  in [
    "HOSTCC:=${exe pkgsBuildBuild.stdenv.cc "cc"}"
    "HOSTCXX:=${exe pkgsBuildBuild.stdenv.cc "c++"}"
    "HOSTLD:=${exe pkgsBuildBuild.stdenv.cc "ld"}"
    "HOSTAR:=${exe pkgsBuildBuild.stdenv.cc "ar"}"

    "HOSTPKG_CONFIG:=${lib.getExe pkgsBuildBuild.pkg-config}"

    "CC:=${exe llvmPackages.clang-unwrapped "clang"}"
    "LD:=${exe llvmPackages.bintools-unwrapped "ld.lld"}"
    "AR:=${exe llvmPackages.llvm "llvm-ar"}"
    "NM:=${exe llvmPackages.llvm "llvm-nm"}"
    "OBJCOPY:=${exe llvmPackages.llvm "llvm-objcopy"}"
    "OBJDUMP:=${exe llvmPackages.llvm "llvm-objdump"}"
    "READELF:=${exe llvmPackages.llvm "llvm-readelf"}"
    "STRIP:=${exe llvmPackages.llvm "llvm-strip"}"

    "PKG_CONFIG:=${lib.getExe pkgsBuildTarget.pkg-config}"
  ];

  env = {
    ARCH = hostPlatform.linuxArch;
    KCFLAGS = map (flag: [ "-mllvm" flag ]) [
      "--enable-ipra"

      "--hot-cold-split"
      "--hot-cold-static-analysis"

      "--polly"
      "--polly-tiling"
      "--polly-2nd-level-tiling"
      "--polly-register-tiling"
      "--polly-invariant-load-hoisting"
      "--polly-run-dce"
      "--polly-run-inliner"
      "--polly-matmul-opt"
      "--polly-tc-opt"
    ] ++ lib.optionals (instSetArch != null) [ "-march=${lib.escapeShellArg instSetArch}" ]
    |> toString;
  } // lib.optionalAttrs (hostPlatform ? linux-kernel.target) {
    KBUILD_IMAGE = hostPlatform.linux-kernel.target;
  };

  inherit platformFirmware extraFirmware;

  configfile = config |> kernel.mkConfig;

  requiredPresent = config
  |> filterAttrs (n: v: !kernel.isOptional v && kernel.getValue v != false)
  |> mapAttrsToList kernel.mkKeyValue;

  optionalPresent = config
  |> filterAttrs (n: v: kernel.isOptional v && kernel.getValue v != false)
  |> mapAttrsToList kernel.mkKeyValue;

  requiredAbsent = config
  |> filterAttrs (n: v: !kernel.isOptional v && kernel.getValue v == false)
  |> mapAttrsToList (n: v: kernel.mkKey n);

  optionalAbsent = config
  |> filterAttrs (n: v: kernel.isOptional v && kernel.getValue v == false)
  |> mapAttrsToList (n: v: kernel.mkKey n);

  preUnpack = ''
    # verify firmware file existence
    for fw in "''${platformFirmware[@]}" "''${extraFirmware[@]}"; do
      if ! [ -e "${firmwareEnv}/$fw" ]; then
        printf "Unable to locate firmware file %s in %s.\n" \
          "$fw" '${firmwareEnv}' >&2
        exit 1
      fi
    done
  '';

  postPatch = ''
    patchShebangs scripts/

    sed -i '/select BLOCK_LEGACY_AUTOLOAD/d' drivers/md/Kconfig
    sed -i 's:\$(filter %\.o,\$\^):& ${lib.getLib llvmPackages.compiler-rt-no-libc}/lib/linux/libclang_rt.builtins-*.a:' \
      arch/x86/entry/vdso/Makefile
  '';

  preConfigure = ''
    mkdir build

    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
    export KBUILD_OUTPUT="$(pwd)/build"

    makeFlags+=( "-j $NIX_BUILD_CORES" )
  '';

  configurePhase = ''
    runHook preConfigure

    cat >build/.config <<<"$configfile"
    make "''${makeFlags[@]}" olddefconfig

    runHook postConfigure
  '';

  postConfigure = ''
    # verify configuration
    for keyValue in "''${requiredPresent[@]}"; do
      if ! grep -F -x -q "$keyValue" build/.config; then
        printf 'Required: %s\nActual:   %s\n\n' "$keyValue" \
          "$(grep -E "''${keyValue%%=*}[ =]" build/.config || echo "(absent)")" >&2
        exit 1
      fi
    done

    for key in "''${requiredAbsent[@]}"; do
      if grep -E -q "^$key=" build/.config; then
        printf 'Required: %s unset or absent.\n   Actual:   %s\n\n' "$key" \
          "$(grep -E -q "^key=" build/.config)" >&2
        exit 1
      fi
    done

    for keyValue in "''${optionalPresent[@]}"; do
      if ! grep -F -x -q "$keyValue" build/.config; then
        printf 'Suggested: %s\nActual:    %s\n\n' "$keyValue" \
          "$(grep -E "''${keyValue%%=*}[ =]" build/.config || echo "(absent)")" >&2
      fi
    done

    for key in "''${optionalAbsent[@]}"; do
      if grep -E -q "^$key=" build/.config; then
        printf 'Suggested: %s unset or absent.\nActual:    %s\n\n' "$key" \
          "$(grep -E "^$key=" build/.config)" >&2
      fi
    done
  '';

  preInstall = let
    installkernel = pkgsBuildBuild.writeShellScriptBin "installkernel" ''
      cp "$2" "$4"
      cp "$3" "$4"
    '';
  in ''
    export HOME=${installkernel}
  '';

  installFlags = [
    "INSTALL_PATH=$(out)"
    "INSTALL_MOD_PATH=$(out)"
  ];

  installTargets = [
    "install"
    "modules_install"
  ];

  postInstall = ''
    depmod -b "$out" ${finalAttrs.modDirVersion}
    touch "$out/lib/modules/${finalAttrs.modDirVersion}/modules.order"
  '';

  passthru = {
    config = with kernel; {
      isYes = option: getValue config.${option} or false == true;
      isNo = option: getValue config.${option} or false == false;
      isModule = option: false;

      isEnabled = option: getValue config.${option} or false == true;
      isDisabled = option: getValue config.${option} or false == false;
    };

    isHardened = true;
    isLibre = false;
    isZen = false;

    features = {
      efiBootStub = true;
    };

    kernelOlder = lib.versionOlder finalAttrs.version;
    kernelAtLeast = lib.versionAtLeast finalAttrs.version;
  };

  meta = {
    homepage = "https://github.com/anthraxx/linux-hardened";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = [ "riscv64-linux" "aarch64-linux" "x86_64-linux" ];
  };
})) args
