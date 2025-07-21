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
      red                               = mkLiteral "rgba ( 220, 50, 47, 100 % )";
      selected-active-foreground        = mkLiteral "var(background)";
      lightfg                           = mkLiteral "rgba ( 88, 104, 117, 100 % )";
      separatorcolor                    = mkLiteral "var(foreground)";
      urgent-foreground                 = mkLiteral "var(red)";
      alternate-urgent-background       = mkLiteral "var(lightbg)";
      lightbg                           = mkLiteral "rgba ( 238, 232, 213, 100 % )";
      background-color                  = mkLiteral "transparent";     #"#005555";
      border-color                      = mkLiteral "var(foreground)";
      normal-background                 = mkLiteral "var(background)";
      selected-urgent-background        = mkLiteral "var(red)";
      alternate-active-background       = mkLiteral "var(lightbg)";
      spacing                           = mkLiteral "2";
      blue                              = mkLiteral "rgba ( 38, 139, 210, 100 % )";
      alternate-normal-foreground       = mkLiteral "var(foreground)";
      urgent-background                 = mkLiteral "var(background)";
      selected-normal-foreground        = mkLiteral "var(lightbg)";
      active-foreground                 = mkLiteral "var(blue)";
      background                        = mkLiteral "rgba ( 253, 246, 227, 100 % )";
      selected-active-background        = mkLiteral "var(blue)";
      active-background                 = mkLiteral "var(background)";
      selected-normal-background        = mkLiteral "var(lightfg)";
      alternate-normal-background       = mkLiteral "var(lightbg)";
      foreground                        = mkLiteral "rgba ( 0, 43, 54, 100 % )";
      selected-urgent-foreground        = mkLiteral "var(background)";
      normal-foreground                 = mkLiteral "var(foreground)";
      alternate-urgent-foreground       = mkLiteral "var(red)";
      alternate-active-foreground       = mkLiteral "var(blue)";
    };

    "element" = {
      padding                           = mkLiteral "1px";
      cursor                            = mkLiteral "pointer";
      spacing                           = mkLiteral "5px";
      border                            = mkLiteral "0";
    };

    "element normal.normal" = {
      background-color                  = mkLiteral "var(normal-background)";
      text-color                        = mkLiteral "var(normal-foreground)";
    };

    "element normal.urgent" = {
      background-color                  = mkLiteral "var(urgent-background)";
      text-color                        = mkLiteral "var(urgent-foreground)";
    };

    "element normal.active" = {
      background-color                  = mkLiteral "var(active-background)";
      text-color                        = mkLiteral "var(active-foreground)";
    };

    "element selected.normal" = {
      background-color                  = mkLiteral "var(selected-normal-background)";
      text-color                        = mkLiteral "var(selected-normal-foreground)";
    };

    "element selected.urgent" = {
      background-color                  = mkLiteral "var(selected-urgent-background)";
      text-color                        = mkLiteral "var(selected-urgent-foreground)";
    };

    "element selected.active" = {
      background-color                  = mkLiteral "var(selected-active-background)";
      text-color                        = mkLiteral "var(selected-active-foreground)";
    };

    "element alternate.normal" = {
      background-color                  = mkLiteral "var(alternate-normal-background)";
      text-color                        = mkLiteral "var(alternate-normal-foreground)";
    };

    "element alternate.urgent" = {
      background-color                  = mkLiteral "var(alternate-urgent-background)";
      text-color                        = mkLiteral "var(alternate-urgent-foreground)";
    };

    "element alternate.active" = {
      background-color                  = mkLiteral "var(alternate-active-background)";
      text-color                        = mkLiteral "var(alternate-active-foreground)";
    };

    "element-text" = {
      background-color                  = mkLiteral "transparent";
      cursor                            = mkLiteral "inherit";
      highlight                         = mkLiteral "inherit";
      text-color                        = mkLiteral "inherit";
    };

    "element-icon" = {
      background-color                  = mkLiteral "transparent";
      size                              = mkLiteral "1.0000em";
      cursor                            = mkLiteral "inherit";
      text-cursor                       = mkLiteral "inherit";
    };

    "window" = {
      padding                           = mkLiteral "5";
      background-color                  = mkLiteral "var(background)";
      border                            = mkLiteral "1";
      width                             = mkLiteral "1000px";
      height                            = mkLiteral "500px";
    };

    "mainbox" = {
      padding                           = mkLiteral "0";
      border                            = mkLiteral "0";
      children                          = mkLiteral "[inputbar,message,listview,mode-switcher]";
    };

    "mode-switcher" = {
      padding                           = mkLiteral "1px";
      border-color                      = mkLiteral "Gray";
      border                            = mkLiteral "1px 1px 1px 1px";
    };

    "message" = {
      padding                           = mkLiteral "1px";
      border-color                      = mkLiteral "var(separatorcolor)";
      border                            = mkLiteral "2px dash 0px 0px";
    };

    "textbox" = {
      text-color                        = mkLiteral "var(foreground)";
    };

    "listview" = {
      padding                           = mkLiteral "2px 0px 0px";
      scrollbar                         = mkLiteral "true";
      border-color                      = mkLiteral "var(separatorcolor)";
      spacing                           = mkLiteral "2px";
      fixed-height                      = mkLiteral "100px";
      border                            = mkLiteral "2px dash 0px 0px";
    };

    "scrollbar" = {
      width                             = mkLiteral "4px";
      padding                           = mkLiteral "0";
      handle-width                      = mkLiteral "8px";
      border                            = mkLiteral "0";
      handle-color                      = mkLiteral "var(normal-foreground)";
    };

    "sidebar" = {
      border-color                      = mkLiteral "var(separatorcolor)";
      border                            = mkLiteral "2px dash 0px 0px";
    };

    "button" = {
      cursor                            = mkLiteral "pointer";
      spacing                           = mkLiteral "0";
      background-color                  = mkLiteral "rgba ( 88, 104, 117, 30 % )";
      text-color                        = mkLiteral "var(normal-foreground)";
      padding                           = mkLiteral "1px";
      border-color                      = mkLiteral "Gray";
      border                            = mkLiteral "1px 1px 1px 1px";
    };

    "button selected" = {
      background-color                  = mkLiteral "var(selected-normal-background)";
      text-color                        = mkLiteral "var(selected-normal-foreground)";
      padding                           = mkLiteral "1px";
      border-color                      = mkLiteral "Gray";
      border                            = mkLiteral "1px 1px 1px 1px";
    };

    "num-filtered-rows" = {
      expand                            = mkLiteral "false";
      text-color                        = mkLiteral "Gray";
    };

    "num-rows" = {
      expand                            = mkLiteral "false";
      text-color                        = mkLiteral "Gray";
    };

    "textbox-num-sep" = {
      expand                            = mkLiteral "false";
      str                               = mkLiteral "\"/\"";
      text-color                        = mkLiteral "Gray";
    };

    "inputbar" = {
      padding                           = mkLiteral "1px";
      spacing                           = mkLiteral "8px";
      text-color                        = mkLiteral "var(normal-foreground)";
      children                          = mkLiteral "[ \"prompt\",\"textbox-prompt-colon\",\"entry\",\"num-filtered-rows\",\"textbox-num-sep\",\"num-rows\",\"case-indicator\" ]";
    };

    "case-indicator" = {
      spacing                           = mkLiteral "0";
      text-color                        = mkLiteral "var(normal-foreground)";
    };

    "entry" = {
      text-color                        = mkLiteral "var(normal-foreground)";
      cursor                            = mkLiteral "text";
      spacing                           = mkLiteral "0";
      placeholder-color                 = mkLiteral "Gray";
      placeholder                       = mkLiteral "\"Type to filter\"";
    };

    "prompt" = {
      spacing                           = mkLiteral "0";
      text-color                        = mkLiteral "var(normal-foreground)";
    };

    "textbox-prompt-colon" = {
      margin                            = mkLiteral "0px 0.3000em 0.0000em 0.0000em";
      expand                            = mkLiteral "false";
      str                               = mkLiteral "\":\"";
      text-color                        = mkLiteral "inherit";
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
