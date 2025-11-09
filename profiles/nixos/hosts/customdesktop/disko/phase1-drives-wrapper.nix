#
#  Add in your host profile:
#    imports = [
#      ./disko/phase1-sdd-wrapper.nix
#    ];
#

{ lib, ... }: {
  disko.devices = import ./phase1-drives-definition.nix { inherit lib; };
}

