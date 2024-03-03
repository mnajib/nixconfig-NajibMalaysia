{
  config,
  pkgs,
  #inputs,
  #outputs,
  #lib,
  ...
}:
{
  #nix.settings = {
  #  substituters = ["https://hyprland.cachix.org"];
  #  trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  #};

  home.packages = with pkgs; [
    rofi-wayland
    #rofi
    #bemenu
    #fuzzel
    #tofi

    dunst
    mako

    wl-clipboard
  ];

  wayland.windowManager.hyprland = {
  #programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;

    # Qptional: Enable hyprland-session.target on hyprland startup
    systemd.enable = true;

    #settings = {
    #  #decoration = {};
    #  "$mod" = "SUPER";
    #  "$mainMod" = "SUPER";
    #  #bindm = [];
    #};

    # List of plugins:
    #   https://github.com/hyprland-community/awesome-hyprland#plugins
    #
    #plugins = [
    #  inputs.plugin_name.packages.${pkgs.system}.default
    #];

    #extraConfig = ''
    #  decoration {
    #    #shadow_offset = 0.5
    #    col.shadow = rgba(00000099)
    #  }

    #  bindm = $mod, mouse:272, movewindow
    #  bindm = $mod, mouse:273, resizewindow
    #  bindm = $mod ALT,mouse:272, resizewindow

    #  bind = $mainMod, S, exec, rofi -show drun -show-icons

    #  input {
    #    #kb_layout = us,us,msa
    #    #kb_variant = dvorak,,najib
    #    kb_layout = us
    #    kb_variant = dvorak
    #    kb_options = grp:shift_caps_toggle
    #    #kb_options = caps:ctrl_modifier
    #  }

    #  # hyprctl devices
    #  #device:my-epic-keyboard-v1 {
    #  #  kb_layout = us,us,msa
    #  #  kb_variant = dvorak,,najib
    #  #  kb_options = grp:shift_caps_toggle
    #  #}

    #  # To list all available monitors:
    #  #   hyprctl monitors all
    #  #monitor = LVDS-1,disable
    #  #monitor = LVDS-1, 1366x768, 1024x0, 1
    #  monitor = LVDS-1, 1366x768, 1024x0, 0.666667
    #  monitor = VGA-1, 1280x1024, 0x0, 1
    #  #
    #  # Rule for quickly plugging in random monitors:
    #  #monitor=,preferred,auto,1
    #  #monitor=,highrr,auto,1            # best possible refreshrate
    #  #monitor=,highres,auto,1           # best possible resolution
    #'';

  }; # End of: wayland.windowManager.hyprland

  #home.file."~/.config/hypr/hyprland.conf".text = ''
    #$mod = SUPER
  #''

}
