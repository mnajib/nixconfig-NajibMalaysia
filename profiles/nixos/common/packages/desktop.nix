{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Window managers & compositors
    fluxbox picom dmenu xscreensaver brightnessctl

    # X11 utilities
    xorg.xmodmap xorg.xev xclip xdotool xbindkeys
    xorg.libxcvt
    xorg.xhost

    # Panels & tray
    volumeicon pasystray trayer
    haskellPackages.xmobar

    # Display tools
    arandr autorandr
    xlockmore
    v4l-utils # provide edid-decode

    # Scanning
    simple-scan
  ];
}

