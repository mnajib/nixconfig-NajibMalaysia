{ config, pkgs, ... }:
{

  xdg.configFile."waybar/config-top.jsonc" = {
    source = ./waybar/config-top.jsonc;
  };

  xdg.configFile."waybar/config-bottom.jsonc" = {
    source = ./waybar/config-bottom.jsonc;
  };

  xdg.configFile."waybar/scripts/waktusolat.sh" = {
    source = ./waybar/scripts/waktusolat.sh;
    executable = true;
  };

  xdg.configFile."niri/config.kdl" = {
    source = ./config.kdl;
  };

  home.packages = with pkgs; [
    niri
    waybar
    swayidle
    jq
    bash

    #chameleos
    #niriswitcher
    #sunsetr
    #hyprlax
    #noctalia-shell
  ];

  programs.waybar.enable = true;
  programs.fuzzel.enable = true;

}
