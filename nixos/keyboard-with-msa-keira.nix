{
  services.xserver.xkb.layout = "us"; #"us,us,msa,msa";
  services.xserver.xkb.variant = ""; #"dvorak,,najib,macnajib";

  services.xserver.xkb.options = "grp:shift_caps_toggle";

  services.xserver.xkb.extraLayouts = {
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
}
