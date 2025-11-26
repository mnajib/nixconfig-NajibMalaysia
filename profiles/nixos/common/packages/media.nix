{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Players
    vlc mpv smplayer

    # Recording
    vokoscreen simplescreenrecorder audio-recorder

    # Graphics
    gimp inkscape

    # E-books & docs
    calibre sioyek evince

    # Screenshot tools
    scrot maim gnome-screenshot

    # Annotation & notes
    gromit-mpx xournalpp rnote pdftk pdfarranger
    cheese snapshot
  ];
}

