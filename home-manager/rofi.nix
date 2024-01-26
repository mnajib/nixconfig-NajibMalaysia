{
  config,
  pkgs,
  inputs,
  outputs,
  lib,
  ...
}:
let
  inherit (config.lib.formats.rasi) mkLiteral;

  #my-rofi-extraconfig = builtins.readFile ./src/.config/rofi/config.rasi;
  #my-rofi-theme = builtins.readFile ./src/.config/rofi/themes/theme-najib.rasi;

  my-rofi-theme = {
    "*" = {
      background-color = mkLiteral "#00ff00";
    };
  };

  #my-rofi-extraconfig = {
  #  modes: [drun,run,window,windowcd,calc,ssh,filebrowser,file-browser-extended,keys,emoji,combi];
  #  font: "hack 10";
  #  show-icons: true;
  #  icon-theme: "Papirus";
  #  combi-modes: "drun,run";
  #
  #  timeout {
  #      action: "kb-cancel";
  #      delay:  0;
  #  }
  #
  #  filebrowser {
  #      directories-first: true;
  #      sorting-method:    "name";
  #  }
  #};
in {
#{
  #home.packages = with pkgs; [
  #  rofi
  #];

  programs.rofi = {
    enable = true;

    theme = my-rofi-theme;
    #extraConfig = my-rofi-extraconfig;

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

    #package = pkgs.rofi.override {
    #  plugins = with pkgs; [
    #    rofi-file-browser
    #    rofi-pass
    #    rofi-calc
    #    rofi-emoji
    #    rofi-rbw
    #    rofi-rbw-x11
    #    rofi-systemd
    #    rofi-screenshot
    #    rofi-power-menu
    #    rofi-pulse-select
    #  ];
    #};

    #extraConfig = builtins.readFile ./src/.config/rofi/config.rasi;
#   extraConfig = ''
#     configuration {
#       /*
#       plugin {
#           path: "/nix/store/hni4nazihlpym28w2w8nb7k4jhsz1xqh-rofi-1.7.5/lib/rofi";
#       }
#       */
#     }

    extraConfig = {
      modes = "drun,run,window,windowcd,calc,ssh,filebrowser,file-browser-extended,keys,emoji,combi";
      combi-modes = "drun,run";
      font = "hack 10";
      show-icons = true;
      icon-theme = "Papirus";
      #timeout = {
      #  action = "kb-cancel";
      #  delay = 0;
      #};
      #filebrowser = {
      #  directories-first = true;
      #  sorting-method = "name";
      #};
    };

    # /*@import "~/.config/rofi/config-najib.rasi"*/
    # /*@theme "~/.config/rofi/themes/theme-najib.rasi"*/

    #theme = {
    #  let
    #    inherit (config.lib.formats.rasi) mkLiteral;
    #  in {
    #    "#" = {
    #      background-color = mkLiteral "#00ff00";
    #    };
    #  }
    #};

  }; # end program.rofi

  #home.file."./.config/rofi" = {
  #  source = ./src/.config/rofi;
  #  recursive = true;
  #};
  #home.file."./.rofi" = {
  #  source = ./src/.config/rofi;
  #  recursive = true;
  #};
}
