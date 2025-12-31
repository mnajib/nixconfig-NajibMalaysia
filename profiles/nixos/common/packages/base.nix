{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Core CLI utilities
    wget curl killall file lsof tree
    pstree broot psmisc

    # Shell/session tools
    tmux screen zellij dtach byobu

    # Search & text processing
    ripgrep jq

    # System info
    pciutils usbutils gnupg

    # Passwords
    mkpasswd pass qtpass

    # Calculators
    bc eva clac gnome-calculator

    # Managing Secrets
    sops age
  ];
}

