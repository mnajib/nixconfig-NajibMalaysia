{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Window managers & compositors
    fluxbox picom dmenu xscreensaver brightnessctl

    # X11 utilities
    xorg.xmodmap xorg.xev xclip xdotool xbindkeys
    xorg.libxcvt

    # Panels & tray
    volumeicon pasystray trayer
    haskellPackages.xmobar

    # Display tools
    arandr autorandr
    xlockmore

    # Scanning
    simple-scan
  ];
}

