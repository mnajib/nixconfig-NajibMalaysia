{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Players
    vlc mpv smplayer

    # Recording
    vokoscreen-ng #vokoscreen
    simplescreenrecorder
    #audio-recorder # audio-recorder has been removed as it is unmaintained upstream and broken.
    gnome-sound-recorder
    reco

    # Graphics
    gimp inkscape
    krita

    # E-books & docs
    calibre sioyek evince

    # Screenshot tools
    scrot maim gnome-screenshot

    # Annotation & notes
    gromit-mpx xournalpp rnote pdftk pdfarranger
    cheese snapshot
  ];
}

