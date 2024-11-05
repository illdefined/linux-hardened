{
  description = "Hardened Linux kernel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  nixConfig = {
    extra-experimental-features = [ "pipe-operator" "pipe-operators" ];
    extra-substituters = [ "https://cache.kyouma.net" ];
    extra-trusted-public-keys = [ "cache.kyouma.net:Frjwu4q1rnwE/MnSTmX9yx86GNA/z3p/oElGvucLiZg=" ];
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    inherit (nixpkgs) lib;
    packageWith = pkgs: lib.callPackageWith pkgs ./package.nix;
  in {
    lib.kernel = import ./lib.nix { inherit lib; };
    packages = {
      riscv64-linux = let
        package = packageWith nixpkgs.legacyPackages.riscv64-linux;
      in {
        default = package { };
      };

      aarch64-linux = let
        package = packageWith nixpkgs.legacyPackages.aarch64-linux;
      in {
        default = package { };
      };

      x86_64-linux = let
        package = packageWith nixpkgs.legacyPackages.x86_64-linux;
      in {
        default = package { };
      };
    };

    hydraJobs = self.packages |> lib.foldlAttrs (jobs: system: packages: lib.recursiveUpdate jobs
      (lib.mapAttrs (name: package: { ${system} = package; }) packages)) { };
  };
}
