{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    darcs
    elvish
    soteria
    wireshark
    exiftool
    gxmessage
    #parcellite
    clipboard-jh
    clipcat
    dzen2
    ghostscript
    geteltorito
    woeusb
    adwaita-qt
    adwaita-icon-theme
    screenfetch
    taskwarrior3
    timewarrior
    taskwarrior-tui
    vit
    tasknc
    oneko
    xcape
    find-cursor
  ];
}

