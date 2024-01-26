{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}:
{
  #home.packages = with pkgs; [
  #  rofi
  #];

  programs.rofi = {
    enable = true;

    package = pkgs.rofi.override {
      plugins = with pkgs; [
        rofi-file-browser
        rofi-pass
        rofi-calc
        rofi-emoji
        rofi-rbw
        rofi-rbw-x11
        rofi-systemd
        rofi-screenshot
        rofi-power-menu
        rofi-pulse-select
      ];
    };

  };

  home.file."./config/rofi" = {
    source = ./src/.config/rofi;
    recursive = true;
  };
  #home.file."./config/rofi" = {
  #  source = ./src/.config/rofi;
  #  recursive = true;
  #};
  #home.file."./config/rofi" = {
  #  source = ./src/.config/rofi;
  #  recursive = true;
  #};
}
