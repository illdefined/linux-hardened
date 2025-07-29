{
  lib,
  stdenv,
  pkgsBuildBuild,
  pkgsBuildHost,
  pkgsHostHost,
  fetchFromGitHub,
  nix-update-script,
  ...
}@args:

lib.makeOverridable ({
  llvmPackages ? pkgsBuildHost.llvmPackages_latest,
  targetCPU ? stdenv.hostPlatform.gcc.cpu or null,
  targetArch ? stdenv.hostPlatform.gcc.arch or null,
  targetTune ? stdenv.hostPlatform.gcc.tune or null,
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
    concatStringsSep
    escapeShellArg;

  inherit (stdenv) hostPlatform;

  firmwareEnv = pkgsBuildBuild.buildEnv {
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
  version = "6.12.40-hardened1";

  modDirVersion = lib.versions.pad 3 finalAttrs.version;

  src = fetchFromGitHub {
    owner = "anthraxx";
    repo = "linux-hardened";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hi0OkBopBD2pHCmDVE9AaqVaZAY0sV+SyFcODIAMHfs=";
  };

  strictDeps = true;

  nativeBuildInputs = (with pkgsBuildBuild; [
    bc
    hexdump
    jq
    openssl
    perl
    python3
    zstd
  ]) ++ (with pkgsBuildHost; [
    bison
    flex
    kmod
  ]);

  buildInputs = [
    pkgsBuildBuild.openssl
    pkgsBuildHost.elfutils
  ];

  patches = [ ./io_uring-sysctl.patch ];

  enableParallelBuilding = true;

  makeFlags = let
    exe = pkg: prg: lib.getExe' pkg (pkg.targetPrefix or "" + prg);

    cc = llvmPackages.clang-unwrapped;
    version = lib.versions.major cc.version;

    resource-dir = pkgsBuildBuild.runCommand "clang-resources" { } ''
      mkdir -p "$out"
      ln -s ${escapeShellArg "${lib.getLib cc}/lib/clang/${version}/include"} "$out"
      ln -s ${escapeShellArg "${lib.getLib llvmPackages.compiler-rt-no-libc}/lib"} "$out"
    '';

    cc-wrapper = pkgsBuildBuild.runCommandCC "clang" {
      nativeBuildInputs = [ pkgsBuildBuild.makeBinaryWrapper ];
      meta.mainProgram = "clang";
    } ''
      makeBinaryWrapper "${lib.getExe cc}" "$out/bin/clang" \
        --add-flags ${escapeShellArg "-resource-dir=${resource-dir}"}
    '';

    ld-wrapper = let
      arch = hostPlatform.uname.processor;
      rtlib = {
        ${arch} = resource-dir;
      } // lib.optionalAttrs hostPlatform.isx86 {
        i386 = lib.getLib pkgsBuildHost.pkgsi686Linux."llvmPackages_${version}".compiler-rt-no-libc;
      } |> lib.mapAttrs (arch: resource-dir: [
        "-L${resource-dir}/lib/linux"
        "-lclang_rt.builtins-${arch}"
      ]);
    in pkgsBuildBuild.writeShellApplication {
      name = "ld.lld";
      text = ''
        declare -a params prefix suffix

        while (($# >= 1)); do
          case "$1" in
          --hash-style=*)
            shift
            continue;;
          -m)
            params+=("$1")
            target="$2"
            shift;;
          esac

          params+=("$1")
          shift
        done

        prefix+=(--hash-style=gnu --lto-O2 -O2)

        if [[ -v target ]]; then
          arch="''${target#elf_}"
        else
          arch=${escapeShellArg arch}
        fi

        case "$arch" in
        ${rtlib |> lib.mapAttrsToList (arch: args:
          "${escapeShellArg arch}) suffix+=(${lib.escapeShellArgs args});;")
          |> concatStringsSep "\n"}
        esac

        exec ${lib.getExe' llvmPackages.lld "ld.lld"} "''${prefix[@]}" "''${params[@]}" "''${suffix[@]}"
      '';
    };
  in [
    "HOSTCC:=${exe pkgsBuildBuild.stdenv.cc "cc"}"
    "HOSTCXX:=${exe pkgsBuildBuild.stdenv.cc "c++"}"
    "HOSTLD:=${exe pkgsBuildBuild.stdenv.cc "ld"}"
    "HOSTAR:=${exe pkgsBuildBuild.stdenv.cc "ar"}"

    "HOSTPKG_CONFIG:=${lib.getExe pkgsBuildBuild.pkg-config}"

    "CC:=${lib.getExe cc-wrapper}"
    "LD:=${lib.getExe ld-wrapper}"
    "AR:=${lib.getExe' llvmPackages.llvm "llvm-ar"}"
    "NM:=${lib.getExe' llvmPackages.llvm "llvm-nm"}"
    "OBJCOPY:=${lib.getExe' llvmPackages.llvm "llvm-objcopy"}"
    "OBJDUMP:=${lib.getExe' llvmPackages.llvm "llvm-objdump"}"
    "READELF:=${lib.getExe' llvmPackages.llvm "llvm-readelf"}"
    "STRIP:=${lib.getExe' llvmPackages.llvm "llvm-strip"}"

    "PKG_CONFIG:=${lib.getExe pkgsBuildHost.pkg-config}"
  ];

  env = {
    ARCH = hostPlatform.linuxArch;
    KCFLAGS =
      lib.optionals (targetCPU != null) [ "-mcpu=${targetCPU}" ]
      ++ lib.optionals (targetArch != null) [ "-march=${targetArch}" ]
      ++ lib.optionals (targetTune != null) [ "-mtune=${targetTune}" ]
      ++ map (flag: [ "-mllvm" flag ]) [
        "--enable-deferred-spilling"
        "--enable-gvn-hoist"
        "--enable-ipra"
        "--enable-merge-functions"

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
    ] |> toString;
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

  postPatch = let
    rtlib = lib.getLib llvmPackages.compiler-rt-no-libc;
  in ''
    patchShebangs scripts/

    sed -i '/select BLOCK_LEGACY_AUTOLOAD/d' drivers/md/Kconfig

    find . -type f -name '*.lds.S' -print0 \
      | xargs -0 -r sed -E -i '/\<\.hash\>/d'
  '';

  preConfigure = ''
    mkdir build

    export KBUILD_BUILD_TIMESTAMP="$(date -u -d @$SOURCE_DATE_EPOCH)"
    export KBUILD_OUTPUT="$(pwd)/build"

    echo ${stdenv.cc.cc.outPath |> builtins.match ".*/([a-z0-9]{32}).*" |> builtins.head} \
      >scripts/basic/randstruct.seed

    if [[ -v enableParallelBuilding ]]; then
      makeFlags+=( -j "$NIX_BUILD_CORES" )
    fi
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

    updateScript = nix-update-script { };
  };

  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    homepage = "https://github.com/anthraxx/linux-hardened";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mvs ];
    platforms = [ "riscv64-linux" "aarch64-linux" "x86_64-linux" ];

  };
})) args
