{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.atop
    pkgs.btop
    pkgs.htop
    pkgs.gnome.gnome-disk-utility
    pkgs.fortune
    #pkgs.mgba
    pkgs.zeal                           # Offline API documentation browser for software developers
    #pkgs.broot                          # something like tree command
    pkgs.xorg.xdpyinfo
    pkgs.xorg.xwininfo
    pkgs.mc
    pkgs.ncdu                           # Disc space usage analyzer
    pkgs.diskonaut                      # Disk space usage analyzer
    pkgs.bc
    pkgs.rlwrap                         # A readline wrapper
    pkgs.unzip
    pkgs.wget
    pkgs.gnupg
    pkgs.translate-shell                # CLI translator using Google Translate, Bing Translator, ...
    pkgs.whois
    #pkgs.youtube-dl # insecure package
    pkgs.coreutils
    pkgs.dzen2                          # A general purpose messaging, notification and menuing program for X11
    pkgs.vis
    pkgs.handlr
    pkgs.ranger
    #pkgs.termonad
    pkgs.tmux
    pkgs.mosh
    pkgs.pavucontrol
    #pkgs.libreoffice-still #pkgs.libreoffice
    #pkgs.libreoffice-fresh #pkgs.libreoffice-qt
    #pkgs.libreoffice-bin
    #pkgs.xournal
    pkgs.xournalpp
    pkgs.inkscape                       #pkgs.unstable.inkscape
    pkgs.imagemagick
    pkgs.pandoc
    #pkgs.texlive.combined.scheme-tetex
    #pkgs.ardour                         #pkgs.unstable.ardour
    pkgs.simplescreenrecorder
    #pkgs.obs-studio
    #pkgs.tuir                           #pkgs.rtv # Browse Reddit from terminal
    pkgs.qtox
    pkgs.zoom-us
    pkgs.pass                           # CLI password manager
    pkgs.vlc
    pkgs.shutter                        # Screenshots
    #pkgs.zathura                        # Document viewer
    pkgs.dropbox                        #pkgs.unstable.dropbox
    pkgs.wpa_supplicant_gui
    pkgs.qucs-s #pkgs.qucs                           # Integrated circuit simulator. qucs has been removed because it depended on qt4. Try using qucs-s
    #pkgs.ngspice                        # The Next Generation Spice (Electronic Circuit Simulator)
    #pkgs.fritzing
    #pkgs.dt-shell-color-scripts         #

    #pkgs.sameboy                       # gameboy emulator

    # TUI Web Browser
    pkgs.links2                         # cli webbrowser
    pkgs.lynx                           # cli webbrowser

    # GUI Web Browser
    #pkgs.firefox
    pkgs.qutebrowser
    #pkgs.brave                          #pkgs.unstable.brave # web browser

    # TUI E-mail Client
    pkgs.neomutt
    pkgs.mutt
    #pkgs.meli
    #pkgs.lumail
    pkgs.aerc
    pkgs.himalaya
    pkgs.deltachat-cursed

    # GUI E-mail Client
    pkgs.sylpheed
    pkgs.thunderbird
    #pkgs.mailspring                    # is marked as insecure
    pkgs.gnome.geary
    pkgs.balsa
    #pkgs.deltachat-desktop             # used electron version that marked as unsecured?

    pkgs.fzy                            # CLI fuzzy finder

    # GUI Games
    #pkgs.zeroad

    pkgs.ed # text editor

    pkgs.timeline # Display and navigate information on a timeline
  ];
}
