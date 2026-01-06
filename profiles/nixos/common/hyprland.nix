{
  config,
  pkgs,
  ...
}:
{
  nix.settings = {
   substituters = ["https://hyprland.cachix.org"];
   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  environment.systemPackages = with pkgs; [
    #----------------------------------
    waybar
    #
    #(
    #  waybar.overrideAttrs ( oldAttrs: {
    #    mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #  })
    #)

    eww
    #----------------------------------
    dunst
    libnotify
    #----------------------------------
    hyprpaper
    swaybg
    wpaperd
    mpvpaper
    swww
    #----------------------------------
    kitty
    alacritty
    wezterm
    #----------------------------------
    rofi
    wofi                                # gtk rofi
    bemenu
    fuzzel
    tofi
    #----------------------------------
  ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.hyprland = {
    enable = true;
    #nvidiaPatches = true;
    xwayland.enable = true;
    withUWSM = true; # Launch Hyprland with the UWSM (Universal Wayland Session Manager) session manager.
  };

  environment.sessionVariables = rec {
    WLR_NO_HARDWARE_CURSORS = "1";      # If your cursor becomes invisible
    NIXOS_OZONE_WL = "1";               # Optional, hint electron apps to use wayland instead of xorg
    TERMINAL = "alacritty";
    EDITOR = "nvim";
    XDG_BIN_HOME = "$HOME/.local/bin";
    #XDG_BIN_HOME = "$HOME/bin";
    PATH = [
      "${XDG_BIN_HOME}"
    ];
  };

  hardware = {
    opengl.enable = true;
    #nvidia.modesetting.enable = true;   # Most wayland compositors need this
  };

  security.pam.services.hyprlock = {};

}
