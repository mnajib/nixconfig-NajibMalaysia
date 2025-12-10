{
  lib,
  ...
}:
{
  #services.xserver.layout = "us,us,msa,msa";
  #services.xserver.xkbVariant = "dvorak,,najib,macnajib";

  services.xserver.xkb = {
    #layout = "us";
    #variant = "dvorak";

    layout = lib.mkForce "us,us,msa";
    variant = lib.mkForce "dvorak,,najib";
    options = "grp:shift_caps_toggle";
    extraLayouts = {
      msa = {
        description = "Arabic-Jawi Najib";
        languages = [ "msa" ];
        keycodesFile = ./xkb/keycodes/msa;
        typesFile = ./xkb/types/msa;
        compatFile = ./xkb/compat/msa;
        symbolsFile = ./xkb/symbols/msa;
        #geometryFile = ./xkb/geometry/msa; # irrelevant
      };
    };

  }; # End services.xserver.xkb
}
