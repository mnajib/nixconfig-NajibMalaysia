{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    #--------------------------------------------------------------------------
    # GUI Player (or with ability to launch player; browser and player and mybe downloader)
    #--------------------------------------------------------------------------
    #smtube # insecure because using unmaintained qtwebkit
    minitube # watch youtube with tv-like experience
    freetube # the private youtube client
    headset
    invidious
    gtk-pipe-viewer
    ytmdesktop # desktop player for youtube music
    tartube # the easy way to watch and download videos from youtube, twitch, odysee, etc.

    #--------------------------------------------------------------------------
    # CLI / TUI Player (or with ability to launch player)
    #--------------------------------------------------------------------------
    youtube-tui
    #pipe-viewer # conflic with gtk-pipe-viewer
    ytfzf # fuzzy search find and watch youtube videos from terminal

    #--------------------------------------------------------------------------
    # GUI Downloader (without ability to launch player)
    #--------------------------------------------------------------------------
    ytarchive
    clipgrab
    #media-downloader
    youtube-music

    #--------------------------------------------------------------------------
    # TUI Downloader (without ability to launch player)
    #--------------------------------------------------------------------------
    #tartube-yt-dlp # conflic with tartube
    youtube-dl
    #youtude-dl-light
    ytmdl

    #--------------------------------------------------------------------------
    # Else
    #--------------------------------------------------------------------------
    #ytcast
    #video2midi
    mpv # media player needed by youtube-tui
    smplayer # media player needed by smtube

    #ueberzug # alternative for w3mimgdisplay; optional for ytfzf
    ueberzugpp # drop in replacement for ueberzug
    imv # a command line image viewer
  ];
}
