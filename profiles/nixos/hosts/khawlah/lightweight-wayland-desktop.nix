#
#
# ~/.config/labwc/autostart
#   # Launch taskbar (Start Menu + Window List + Tray)
#   sfwbar &
#
#   # Launch desktop notification daemon
#   mako &
#
#   # Network Manager applet for easy Wi-Fi selection
#   nm-applet --indicator &
#

{ config, pkgs, ... }:

{
  # 1. Wayland Compositor (Labwc - Lightweight Stacking Compositor)
  programs.labwc = {
    enable = true;
  };

  # 2. Display Manager (Graphical Login Screen)
  #services.displayManager.greetd = {
  #  enable = true;
  #  settings = {
  #    default_session = {
  #      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd labwc";
  #      user = "greeter";
  #    };
  #  };
  #};

  # 3. GUI System Utilities & Average User Essentials
  environment.systemPackages = with pkgs; [
    # Panel & Taskbar (Windows/Xfce style bottom bar)
    sfwbar           # Wayland taskbar with start menu & system tray
    waybar
    mako             # Desktop Notifications
    #swaync

    # GUI File Manager & Utilities
    pcmanfm-qt       # Fast GUI File Manager with desktop icon support
    lxqt.lxqt-archiver # Archive manager (ZIP, TAR, etc.)
    #lxapprearance
    #qt5ct
    pavucontrol      # Graphical Volume Control
    crosspipe
    #helvum
    wdisplays        # Graphical Monitor/Resolution Configurator (like Display Settings)
    blueman

    wofi
    fuzzel           # App Search / Menu backend

    swaylock         # Screen locker
    #swaylock-effects
    swayidle

    # Lightweight Web Browser
    firefox

    kitty
    foot

    cliphist
    wl-clipboard

    grim
    slurp
    swappy

  ];

  # 4. Wayland Graphics Environment Drivers
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ intel-vaapi-driver ];
  };

  # Environment flags for Intel Ironlake legacy GPU
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_RENDERER = "gles2";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Polkit daemon (Triggers password prompts for GUI admin tools)
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
    };
  };
}
