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
      red                               = lib.mkDefault (mkLiteral "rgba ( 220, 50, 47, 100 % )");
      selected-active-foreground        = lib.mkDefault (mkLiteral "var(background)");
      lightfg                           = lib.mkDefault (mkLiteral "rgba ( 88, 104, 117, 100 % )");
      separatorcolor                    = lib.mkDefault (mkLiteral "var(foreground)");
      urgent-foreground                 = lib.mkDefault (mkLiteral "var(red)");
      alternate-urgent-background       = lib.mkDefault (mkLiteral "var(lightbg)");
      lightbg                           = lib.mkDefault (mkLiteral "rgba ( 238, 232, 213, 100 % )");
      background-color                  = lib.mkDefault (mkLiteral "transparent");     #"#005555";
      border-color                      = lib.mkDefault (mkLiteral "var(foreground)");
      normal-background                 = lib.mkDefault (mkLiteral "var(background)");
      selected-urgent-background        = lib.mkDefault (mkLiteral "var(red)");
      alternate-active-background       = lib.mkDefault (mkLiteral "var(lightbg)");
      spacing                           = lib.mkDefault (mkLiteral "2");
      blue                              = lib.mkDefault (mkLiteral "rgba ( 38, 139, 210, 100 % )");
      alternate-normal-foreground       = lib.mkDefault (mkLiteral "var(foreground)");
      urgent-background                 = lib.mkDefault (mkLiteral "var(background)");
      selected-normal-foreground        = lib.mkDefault (mkLiteral "var(lightbg)");
      active-foreground                 = lib.mkDefault (mkLiteral "var(blue)");
      background                        = lib.mkDefault (mkLiteral "rgba ( 253, 246, 227, 100 % )");
      selected-active-background        = lib.mkDefault (mkLiteral "var(blue)");
      active-background                 = lib.mkDefault (mkLiteral "var(background)");
      selected-normal-background        = lib.mkDefault (mkLiteral "var(lightfg)");
      alternate-normal-background       = lib.mkDefault (mkLiteral "var(lightbg)");
      foreground                        = lib.mkDefault (mkLiteral "rgba ( 0, 43, 54, 100 % )");
      selected-urgent-foreground        = lib.mkDefault (mkLiteral "var(background)");
      normal-foreground                 = lib.mkDefault (mkLiteral "var(foreground)");
      alternate-urgent-foreground       = lib.mkDefault (mkLiteral "var(red)");
      alternate-active-foreground       = lib.mkDefault (mkLiteral "var(blue)");
    };

    "element" = {
      padding                           = lib.mkDefault (mkLiteral "1px");
      cursor                            = lib.mkDefault (mkLiteral "pointer");
      spacing                           = lib.mkDefault (mkLiteral "5px");
      border                            = lib.mkDefault (mkLiteral "0");
    };

    "element normal.normal" = {
      background-color                  = lib.mkDefault (mkLiteral "var(normal-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
    };

    "element normal.urgent" = {
      background-color                  = lib.mkDefault (mkLiteral "var(urgent-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(urgent-foreground)");
    };

    "element normal.active" = {
      background-color                  = lib.mkDefault (mkLiteral "var(active-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(active-foreground)");
    };

    "element selected.normal" = {
      background-color                  = lib.mkDefault (mkLiteral "var(selected-normal-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(selected-normal-foreground)");
    };

    "element selected.urgent" = {
      background-color                  = lib.mkDefault (mkLiteral "var(selected-urgent-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(selected-urgent-foreground)");
    };

    "element selected.active" = {
      background-color                  = lib.mkDefault (mkLiteral "var(selected-active-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(selected-active-foreground)");
    };

    "element alternate.normal" = {
      background-color                  = lib.mkDefault (mkLiteral "var(alternate-normal-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(alternate-normal-foreground)");
    };

    "element alternate.urgent" = {
      background-color                  = lib.mkDefault (mkLiteral "var(alternate-urgent-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(alternate-urgent-foreground)");
    };

    "element alternate.active" = {
      background-color                  = lib.mkDefault (mkLiteral "var(alternate-active-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(alternate-active-foreground)");
    };

    "element-text" = {
      background-color                  = lib.mkDefault (mkLiteral "transparent");
      cursor                            = lib.mkDefault (mkLiteral "inherit");
      highlight                         = lib.mkDefault (mkLiteral "inherit");
      text-color                        = lib.mkDefault (mkLiteral "inherit");
    };

    "element-icon" = {
      background-color                  = lib.mkDefault (mkLiteral "transparent");
      size                              = lib.mkDefault (mkLiteral "1.0000em");
      cursor                            = lib.mkDefault (mkLiteral "inherit");
      text-cursor                       = lib.mkDefault (mkLiteral "inherit");
    };

    "window" = {
      padding                           = lib.mkDefault (mkLiteral "5");
      background-color                  = lib.mkDefault (mkLiteral "var(background)");
      border                            = lib.mkDefault (mkLiteral "1");
      width                             = lib.mkDefault (mkLiteral "1000px");
      height                            = lib.mkDefault (mkLiteral "500px");
    };

    "mainbox" = {
      padding                           = lib.mkDefault (mkLiteral "0");
      border                            = lib.mkDefault (mkLiteral "0");
      children                          = lib.mkDefault (mkLiteral "[inputbar,message,listview,mode-switcher]");
    };

    "mode-switcher" = {
      padding                           = lib.mkDefault (mkLiteral "1px");
      border-color                      = lib.mkDefault (mkLiteral "Gray");
      border                            = lib.mkDefault (mkLiteral "1px 1px 1px 1px");
    };

    "message" = {
      padding                           = lib.mkDefault (mkLiteral "1px");
      border-color                      = lib.mkDefault (mkLiteral "var(separatorcolor)");
      border                            = lib.mkDefault (mkLiteral "2px dash 0px 0px");
    };

    "textbox" = {
      text-color                        = lib.mkDefault (mkLiteral "var(foreground)");
    };

    "listview" = {
      padding                           = lib.mkDefault (mkLiteral "2px 0px 0px");
      scrollbar                         = lib.mkDefault (mkLiteral "true");
      border-color                      = lib.mkDefault (mkLiteral "var(separatorcolor)");
      spacing                           = lib.mkDefault (mkLiteral "2px");
      fixed-height                      = lib.mkDefault (mkLiteral "100px");
      border                            = lib.mkDefault (mkLiteral "2px dash 0px 0px");
    };

    "scrollbar" = {
      width                             = lib.mkDefault (mkLiteral "4px");
      padding                           = lib.mkDefault (mkLiteral "0");
      handle-width                      = lib.mkDefault (mkLiteral "8px");
      border                            = lib.mkDefault (mkLiteral "0");
      handle-color                      = lib.mkDefault (mkLiteral "var(normal-foreground)");
    };

    "sidebar" = {
      border-color                      = lib.mkDefault (mkLiteral "var(separatorcolor)");
      border                            = lib.mkDefault (mkLiteral "2px dash 0px 0px");
    };

    "button" = {
      cursor                            = lib.mkDefault (mkLiteral "pointer");
      spacing                           = lib.mkDefault (mkLiteral "0");
      background-color                  = lib.mkDefault (mkLiteral "rgba ( 88, 104, 117, 30 % )");
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
      padding                           = lib.mkDefault (mkLiteral "1px");
      border-color                      = lib.mkDefault (mkLiteral "Gray");
      border                            = lib.mkDefault (mkLiteral "1px 1px 1px 1px");
    };

    "button selected" = {
      background-color                  = lib.mkDefault (mkLiteral "var(selected-normal-background)");
      text-color                        = lib.mkDefault (mkLiteral "var(selected-normal-foreground)");
      padding                           = lib.mkDefault (mkLiteral "1px");
      border-color                      = lib.mkDefault (mkLiteral "Gray");
      border                            = lib.mkDefault (mkLiteral "1px 1px 1px 1px");
    };

    "num-filtered-rows" = {
      expand                            = lib.mkDefault (mkLiteral "false");
      text-color                        = lib.mkDefault (mkLiteral "Gray");
    };

    "num-rows" = {
      expand                            = lib.mkDefault (mkLiteral "false");
      text-color                        = lib.mkDefault (mkLiteral "Gray");
    };

    "textbox-num-sep" = {
      expand                            = lib.mkDefault (mkLiteral "false");
      str                               = lib.mkDefault (mkLiteral "\"/\"");
      text-color                        = lib.mkDefault (mkLiteral "Gray");
    };

    "inputbar" = {
      padding                           = lib.mkDefault (mkLiteral "1px");
      spacing                           = lib.mkDefault (mkLiteral "8px");
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
      children                          = lib.mkDefault (mkLiteral "[ \"prompt\",\"textbox-prompt-colon\",\"entry\",\"num-filtered-rows\",\"textbox-num-sep\",\"num-rows\",\"case-indicator\" ]");
    };

    "case-indicator" = {
      spacing                           = lib.mkDefault (mkLiteral "0");
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
    };

    "entry" = {
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
      cursor                            = lib.mkDefault (mkLiteral "text");
      spacing                           = lib.mkDefault (mkLiteral "0");
      placeholder-color                 = lib.mkDefault (mkLiteral "Gray");
      placeholder                       = lib.mkDefault (mkLiteral "\"Type to filter\"");
    };

    "prompt" = {
      spacing                           = lib.mkDefault (mkLiteral "0");
      text-color                        = lib.mkDefault (mkLiteral "var(normal-foreground)");
    };

    "textbox-prompt-colon" = {
      margin                            = lib.mkDefault (mkLiteral "0px 0.3000em 0.0000em 0.0000em");
      expand                            = lib.mkDefault (mkLiteral "false");
      str                               = lib.mkDefault (mkLiteral "\":\"");
      text-color                        = lib.mkDefault (mkLiteral "inherit");
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
