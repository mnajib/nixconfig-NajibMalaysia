{
  description = "Rust Project";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];
    pkgsFor = nixpkgs.legacyPackages;
  in rec {
    packages = forAllSystems (system: {
      default = pkgsFor.${system}.callPackage ./default.nix {};
    });

    devShells = forAllSystems (system: {
      default = pkgsFor.${system}.callPackage ./shell.nix {};
    });
  };
}
