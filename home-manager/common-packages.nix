{ pkgs, config, ... }:
{
  imports = [
    ./evince.nix
  ];

  home.packages = with pkgs; [
    atop
    btop
    htop
    gnome.gnome-disk-utility
    fortune
    #mgba
    zeal                           # Offline API documentation browser for software developers
    #broot                          # something like tree command
    xorg.xdpyinfo
    xorg.xwininfo
    mc
    ncdu                           # Disc space usage analyzer
    diskonaut                      # Disk space usage analyzer
    bc
    rlwrap                         # A readline wrapper
    unzip
    wget
    gnupg
    translate-shell                # CLI translator using Google Translate, Bing Translator, ...
    whois
    #youtube-dl # insecure package
    coreutils
    dzen2                          # A general purpose messaging, notification and menuing program for X11
    vis
    handlr
    ranger
    #termonad
    tmux
    mosh
    pavucontrol
    #libreoffice-still #libreoffice
    #libreoffice-fresh #libreoffice-qt
    #libreoffice-bin
    #xournal
    xournalpp
    inkscape                       #unstable.inkscape
    imagemagick
    pandoc
    #texlive.combined.scheme-tetex
    #ardour                         #unstable.ardour
    simplescreenrecorder
    #obs-studio
    #tuir                           #rtv # Browse Reddit from terminal
    qtox
    zoom-us
    pass                           # CLI password manager
    vlc
    shutter                        # Screenshots
    #zathura                        # Document viewer
    dropbox                        #unstable.dropbox
    wpa_supplicant_gui
    qucs-s #qucs                           # Integrated circuit simulator. qucs has been removed because it depended on qt4. Try using qucs-s
    #ngspice                        # The Next Generation Spice (Electronic Circuit Simulator)
    #fritzing
    #dt-shell-color-scripts         #

    #sameboy                       # gameboy emulator

    # TUI Web Browser
    links2                         # cli webbrowser
    lynx                           # cli webbrowser

    # GUI Web Browser
    #firefox
    qutebrowser
    #brave                          #unstable.brave # web browser

    # TUI E-mail Client
    neomutt
    #mutt
    #meli
    #lumail
    aerc
    himalaya
    deltachat-cursed

    # GUI E-mail Client
    sylpheed
    thunderbird
    #mailspring                    # is marked as insecure
    gnome.geary
    balsa
    #deltachat-desktop             # used electron version that marked as unsecured?

    fzy                            # CLI fuzzy finder

    # GUI Games
    #zeroad

    ed # text editor

    yad
    zenity
    dialog
    gxmessage

    timeline # Display and navigate information on a timeline
  ];
}
