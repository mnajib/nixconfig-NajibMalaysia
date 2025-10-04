{ config, lib, ... }:
let inherit (config.colorscheme) colors;
in {
  programs.zathura = {
    enable = true;
    options = {
      selection-clipboard = "clipboard";
      #font = "${config.fontProfiles.regular.family} 12";
      recolor = true;
      default-bg = lib.mkDefault "#${colors.base00}";
      default-fg = lib.mkDefault "#${colors.base01}";
      statusbar-bg = lib.mkDefault "#${colors.base02}";
      statusbar-fg = lib.mkDefault "#${colors.base04}";
      inputbar-bg = lib.mkDefault "#${colors.base00}";
      inputbar-fg = lib.mkDefault "#${colors.base07}";
      notification-bg = lib.mkDefault "#${colors.base00}";
      notification-fg = lib.mkDefault "#${colors.base07}";
      notification-error-bg = lib.mkDefault "#${colors.base00}";
      notification-error-fg = lib.mkDefault "#${colors.base08}";
      notification-warning-bg = lib.mkDefault "#${colors.base00}";
      notification-warning-fg = lib.mkDefault "#${colors.base08}";
      highlight-color = lib.mkDefault "#${colors.base0A}";
      highlight-active-color = lib.mkDefault "#${colors.base0D}";
      completion-bg = lib.mkDefault "#${colors.base01}";
      completion-fg = lib.mkDefault "#${colors.base05}";
      completions-highlight-bg = lib.mkDefault "#${colors.base0D}";
      completions-highlight-fg = lib.mkDefault "#${colors.base07}";
      recolor-lightcolor = lib.mkDefault "#${colors.base00}";
      recolor-darkcolor = lib.mkDefault "#${colors.base06}";
    };
  };
}
