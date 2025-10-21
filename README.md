## Synopsis

This is a set of Nix derivations for hardened monolithic Linux kernels based on
<https://github.com/anthraxx/linux-hardened>.

The [base configuration](config.nix) enables various hardening options and compiles the kernel with full LTO using the
Clang compiler.

Only the 64‐bit variants of RISC-V, ARM and x86 are currently supported.

Module support is forcibly disabled.


## Usage

Add the repository to your Flake inputs and make it available to NixOS modules. Depending on your Flake structure you
may want to pass it through as an explicit argument to a module or through the `specialArgs` argument of the
`nixosSystem` function.

```nix
inputs = {
  linux-hardened.url = "git+https://woof.rip/mikael/linux-hardened.git";
  # …
}

outputs = { self, nixpkgs, linux-hardened, ... }: let
  inherit (nixpkgs) lib;
in {
  nixosConfigurations = {
    somehost = lib.nixosSystem {
      specialArgs = {
        inherit linux-hardened;
      };

      # …
    };
  };
}
```

Set the `boot.kernelPackages` option to a suitable kernel base and override the [package options](#package-options) as
needed.

Beyond a minimal bare‐bones `default` package, a `paravirt` package for KVM guests is provided, in addition to a
limited number of [hardware platforms](#hardware-platforms).

```nix
boot.kernelPackages = pkgs.linuxPackagesFor
  (linux-hardened.packages.x86_64-linux.thinkpad-x1-extreme-gen5.override {
    extraFirmware = [
      # extra firmware files to embed in the kernel image
    ];

    extraProfiles = {
      lowlatency = true;
      dm-crypt = true;
      # …
    };

    extraConfig = with hardened-linux.lib.kernel; {
      BTRFS_FS = true;
      BTRFS_FS_POSIX_ACL = true;
      # …
    };
  });
```


### Package options

The following package options are provided to customise the kernel:

`firmwarePackages`
:	List of packages from which to collect firmware files for embedding through `extraFirmware`. Defaults to
`[ linux-firmware sof-firmware wireless-regdb ]`.

`extraFirmware`
:	List of extra firmware to embed in the kernel image, given as relative paths.

`extraProfiles`
:	Attribute set of [configuration profiles](#configuration-profiles).

`extraConfig`
:	Attribute set of [kernel configuration options](#kernel-configuration-options).

In addition the `targetCPU`, `targetArch`, and `targetTune` options may be set to optimise compilation through the
`-mcpu`, `-march` ond `-mtune` C compiler flags. These are currently only supported for x86. Other architectures
support selection of the target CPU architecture through kernel configuration options.

The LLVM package set can be overriden using the `llvmPackages` option, which defaults to
`rustPackages.rustc.llvmPackages` to enable Rust in the kernel.

`platformConfig`, `platformFirmware` and `platformProfiles` are used internally by the platform configurations and
_should not_ be overriden.


### Kernel configuration options

Kernel configuration options as passed through `extraConfig` are provided as nested attribute set.

The attribute set names correspond to kernel configuration options without the `CONFIG_` prefix.

Uppercase names of nested attribute sets are joined with underscores while lowercase names are discarded, allowing for
logical grouping:

```nix
{
  boot = {
    XZ_DEC = {
      X86 = true; # → CONFIG_XZ_DEC_X86=y
      ARM = false; # → # CONFIG_XZ_DEC_ARM is not set
    };
  };
}
```

The kernel derivation checks if the configuration options are actually set in the generated configuration. The
`lib.kernel.option` function may be used to skip this check for individual options:

```nix
with linux-hardened.lib.kernel; {
  # Attempts to enable CONFIG_EFI_ZBOOT, but does not abort if it is not set the final configuration.
  EFI_ZBOOT = option true;
}
```

Numbers may be passed as integers or as decimal and hexadecimal number strings:

```nix
{
  MAGIC_SYSRQ_DEFAULT_ENABLE = "0x1f4"; # → CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1f4
  DRM_FBDEV_OVERALLOC = 300; # → CONFIG_DRM_OVERALLOC=300
}
```

Other values are converted to strings with
[`toString`](https://docs.lix.systems/manual/lix/stable/language/builtins.html#builtins-toString) and escaped:

```nix
{
  CMDLINE_BOOL = true;
  CMDLINE = [
    "quiet"
    "usbcore.autosuspend=0"
  ]; # → CONFIG_CMDLINE="quiet usbcore.autosuspend=0"
}
```

## Repository structure

[`package.nix`](package.nix)
:	Kernel package derivation

[`config.nix`](config.nix)
:	Base kernel configuration

[`platform/`](platform/)
:	Hardware platform configurations

[`profile/`](profile/)
:	Configuration profiles


## Hardware platforms

[`paravirt`](platform/paravirt.nix)
:	Generic KVM guest with VirtIO

[`supermicro-h11ssw`](platform/supermicro-h11ssw.nix)
:	SuperMicro H11SSW

[`thinkpad-x1-extreme-gen5.nix`](platform/thinkpad-x1-extreme-gen5.nix)
:	Lenovo ThinkPad X1 Extreme (Gen 5)


## Configuration profiles

[`audio`](profile/audio.nix)
:	Basic ALSA sound

[`debug`](profile/debug.nix)
:	Debug information

[`dm-crypt`](profile/dm-crypt.nix)
:	Storage encryption & authentication via cryptsetup

[`emu32`](profile/emu32.nix)
:	x86-32 emulation

[`interactive`](profile/interactive.nix)
:	Latency reduction for interactive (desktop) systems, 300 Hz timer frequency

[`lowlatency`](profile/lowlatency.nix)
:	Latency reduction for low‐latency (desktop) systems, 1 kHz timer frequency

[`paravirt`](profile/paravirt.nix)
:	Paravirtualised KVM guest support with VirtIO

[`physical`](profile/physical.nix)
:	Base settings for physical machines

[`portable`](profile/portable.nix)
:	Base settings for portable battery‐powered systems

[`powertop`](profile/powertop.nix)
:	[`powertop`](https://github.com/fenrus75/powertop) support

[`virthost`](profile/virthost.nix)
:	Virtualisation host with KVM

[`wireless`](profile/wireless.nix)
:	Base settings for WLAN and Bluetooth
