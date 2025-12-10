# ./modules/nixos/default.nix
#{ lib, ... }:

#
# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
#

{
  #
  # NOTE: List your module files here.
  #

  # my-module = import ./my-module.nix;

  #mySeaweedfsModule = import ./seaweedfs;
  #mySeaweedfsModule = import ./seaweedfs/default.nix;

  #grafito = import ./grafito;
  #grafito = import ./grafito/default.nix;
}

#let
#  # Path to this directory
#  thisDir = ./.;
#
#  # List all subdirectories inside ./modules/nixos
#  subDirs = builtins.filter
#    (name: lib.pathIsDirectory (thisDir + "/${name}"))
#    (builtins.attrNames (builtins.readDir thisDir));
#
#  # List of all discovered default.nix modules
#  discoveredModules =
#    builtins.filter (path: builtins.pathExists (path + "/default.nix"))
#      (map (name: thisDir + "/${name}") subDirs);
#
#  # --- Optional customization ---
#  # Example: skip some modules by name
#  #skip = [ "experimental" "broken" ];
#  skip = [
#    "seaweedfs"
#  ];
#
#  # Example: rename mapping (if you want nicer keys)
#  #rename = {
#  #  grafito = "journal-gui";
#  #};
#  rename = {
#  };
#
#  filteredModules =
#    builtins.filter
#      (path:
#        let
#          base = lib.last (lib.splitString "/" (toString path));
#        in !(builtins.elem base skip))
#      discoveredModules;
#
#  # Final attrset: { grafito = ./grafito/default.nix; ... }
#  moduleAttrs = lib.listToAttrs
#    (map
#      (path:
#        let
#          base = lib.last (lib.splitString "/" (toString path));
#          key = lib.getAttrFromPath [ base ] rename or base;
#        in {
#          name = key;
#          value = import (path + "/default.nix");
#        })
#      filteredModules);
#in
#  # Expose all custom nixosModules here
#  moduleAttrs

