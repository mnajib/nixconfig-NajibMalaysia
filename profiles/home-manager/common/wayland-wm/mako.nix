{ config, lib, ... }:
let inherit (config.colorscheme) colors kind;
in {
  #programs.mako = {
  services.mako = {
    enable = true;

    iconPath = if kind == "dark" then
      "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark"
    else
      "${config.gtk.iconTheme.package}/share/icons/Papirus-Light";

    #font = "${config.fontProfiles.regular.family} 12";

    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 2;
    defaultTimeout = 12000;
    backgroundColor = lib.mkDefault "#${colors.base00}dd";
    borderColor = lib.mkDefault "#${colors.base03}dd";
    textColor = lib.mkDefault "#${colors.base05}dd";
  };
}
