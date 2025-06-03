{
  description = "Hardened Linux kernel";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
  };

  nixConfig = {
    extra-experimental-features = [ "pipe-operator" ];
    extra-substituters = [ "https://cache.kyouma.net" ];
    extra-trusted-public-keys = [ "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg=" ];
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    packageWith = pkgs: args: pkgs.callPackage ./package.nix
      (if builtins.isPath args then import args else args);
  in {
    lib.kernel = import ./lib.nix { inherit lib; };
    packages = {
      riscv64-linux = let
        package = packageWith nixpkgs.legacyPackages.riscv64-linux;
      in {
        default = package { };
        paravirt = package ./platform/paravirt.nix;
      };

      aarch64-linux = let
        package = packageWith nixpkgs.legacyPackages.aarch64-linux;
      in {
        default = package { };
        paravirt = package ./platform/paravirt.nix;
      };

      x86_64-linux = let
        package = packageWith nixpkgs.legacyPackages.x86_64-linux;
      in {
        default = package { };
        paravirt = package ./platform/paravirt.nix;
        supermicro-h11ssw = package ./platform/supermicro-h11ssw.nix;
        thinkpad-x1-extreme-gen5 = package ./platform/thinkpad-x1-extreme-gen5.nix;
      };
    };

    devShells = lib.genAttrs [ "riscv64-linux" "aarch64-linux" "x86_64-linux" ] (system: {
      default = let
        pkgs = nixpkgs.legacyPackages.${system};
        kernel = self.packages.${system}.default;
      in pkgs.mkShell {
        packages = (with pkgs.pkgsBuildBuild; [ ncurses ])
          ++ (with kernel; depsBuildBuild ++ nativeBuildInputs);

        env = kernel.env // {
          MAKEFLAGS = toString kernel.makeFlags;
        };
      };
    });

    hydraJobs = self.packages |> lib.foldlAttrs (jobs: system: packages: lib.recursiveUpdate jobs
      (lib.mapAttrs (name: package: { ${system} = package; }) packages)) { };
  };
}
