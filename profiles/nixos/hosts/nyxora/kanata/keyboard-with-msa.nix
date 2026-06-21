# profiles/nixos/hosts/nyxora/kanata/keyboard-with-msa.nix

{
  lib,
  ...
}:
let
  srcDir = "../../../../common";
in
{
  #services.xserver.layout = "us,us,msa,msa";
  #services.xserver.xkbVariant = "dvorak,,najib,macnajib";

  services.xserver.xkb = {
    #layout = "us";
    #variant = "dvorak";

    #layout = lib.mkForce "us,us,msa";
    #variant = lib.mkForce "dvorak,,najib";
    #options = "grp:shift_caps_toggle";
    layout = lib.mkForce "us";
    variant = lib.mkForce "dvorak";
    options = lib.mkForce "";

    extraLayouts = {
      msa = {
        description = "Arabic-Jawi Najib";
        languages = [ "msa" ];
        keycodesFile = ./. + "${srcDir}/xkb/keycodes/msa";
        typesFile = ./. + "${srcDir}/xkb/types/msa";
        compatFile = ./. + "${srcDir}/xkb/compat/msa";
        symbolsFile = ./. + "${srcDir}/xkb/symbols/msa";
        #geometryFile = ./xkb/geometry/msa; # irrelevant
      };
    };

  }; # End services.xserver.xkb
}
