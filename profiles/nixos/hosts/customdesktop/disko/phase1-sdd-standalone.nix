#
# Run it with:
#   sudo nix run github:nix-community/disko -- --mode disko ./phase1-sdd-standalone.nix
#
# WARNING!
#   This will ...
#

{ lib }: {
  disko.devices = import ./phase1-sdd-definition.nix { inherit lib; };
}

