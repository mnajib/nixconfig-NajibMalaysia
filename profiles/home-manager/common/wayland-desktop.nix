{ config, pkgs, ... }:

{
  # 🧠 Enable Hyprland compositor
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    extraConfig = ''
      # Hyprland core config
      monitor=HDMI-A-1,1920x1080@60,0x0,1
      exec-once = waybar
      exec-once = swaync
      input {
        kb_layout = us
      }
      general {
        gaps_in = 5
        border_size = 2
      }
    '';
  };

  # 🧠 Wayland environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Fixes Electron apps
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    HYPRCURSOR_THEME = "Bibata-Modern-Ice";
    HYPRCURSOR_SIZE = "24";
  };

  # 🧠 Enable desktop portals for screen sharing
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # 🧠 Core Wayland utilities
  home.packages = with pkgs; [
    kitty                # Terminal
    waybar               # Status bar
    swaync               # Notifications
    hyprpaper            # Wallpaper daemon
    grim slurp swappy    # Screenshots
    cliphist wl-clipboard # Clipboard manager
    swaylock-effects     # Lock screen
    swayidle             # Idle management
    wofi                 # App launcher
    pavucontrol helvum   # Audio control
    blueman              # Bluetooth GUI
    lxappearance #qt5ct   # GTK/Qt theming
    firefox              # Browser
    nnn                  # File manager
  ];

  # 🧠 Autostart clipboard manager
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Wayland clipboard history daemon";
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.cliphist}/bin/cliphist daemon";
      Restart = "always";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

