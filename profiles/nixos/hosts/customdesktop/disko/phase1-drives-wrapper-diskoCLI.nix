#
# Run it with:
#   sudo nix run github:nix-community/disko -- --help
#   sudo nix run github:nix-community/disko -- --mode destroy --dry-run ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode destroy ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode format --dry-run ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#   sudo nix run github:nix-community/disko -- --mode format ./profiles/nixos/hosts/customdesktop/disko/phase1-drives-wrapper-diskoCLI.nix
#
# WARNING!
#

{
  lib,
  ...
}: {
  disko.devices = import ./phase1-drives-definition.nix { inherit lib; };
}

