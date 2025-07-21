#
# NOTE:
#  systemctl --user status xdg-desktop-portal xdg-desktop-portal-shana
#  systemctl --user start xdg-desktop-portal xdg-desktop-portal-shana
#  systemctl --user enable xdg-desktop-portal xdg-desktop-portal-shana
#  while true; do systemctl --user status xdg-desktop-portal xdg-desktop-portal-shana; sleep 3; done
#  while true; do systemctl --user status xdg-desktop-portal xdg-desktop-portal-shana xdg-desktop-portal-kde xdg-desktop-portal-gtk; sleep 3; done
#  journalctl --user -xe -u xdg-desktop-portal -u xdg-desktop-portal-shana
#
{
  pkgs,
  config,
  ...
}:
{
#  xdg.portal = {
#    enable = true;
#    xdgOpenUsePortal = true; # This will make xdg-open use the portal to open programs.
#
#    #lxqt = {
#    #  enable = true;
#    #  #styles = [];
#    #};
#
#    configPackages = with pkgs; [
#      gnome-session
#      #xdg-desktop-portal-gtk
#      #xdg-desktop-portal-shana
#    ];
#
#    config = {
#      common = {
#        # uses the first portal implementation found in lexicographical order
#        #default = "*";
#        #
#        default = [
#          #"kde"
#          #"gtk"
#          #"shana"
#          "gnome"
#        ];
#      };
#    }; # End xdg.portal.config
#
#    ##key = if builtins.pathExists ./path then "woot" else "bummer";
#    extraPortals = with pkgs; [
#      #xdg-desktop-portal-kde
#      xdg-desktop-portal-gtk
#      #xdg-desktop-portal-xapp
#      #lxqt.xdg-desktop-portal-lxqt
#      #xdg-desktop-portal-shana
#    ];
#  }; # End xdg.portal

  environment.systemPackages = with pkgs; with kdePackages; [ # look in kdePackages first, if it's not found there, it then looks in pkgs.
    xdg-utils # Set of command line tools that assist applications with a variety of desktop integration tasks
    xdg-desktop-portal
    #xdg-desktop-portal-shana # filechooser portal backend for any desktop environment
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-kde
    #xdg-desktop-portal-xapp # for cinnamon, MATE, Xfce
    #lxqt.xdg-desktop-portal-lxqt # backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt

    dunst # notification daemon for handling notifications
    #zenity
    #perl538Packages.FileMimeInfo # Determine file type from the file name
    kdialog
    zathura # pdf viewer?

    #kdePackages.neochat # A client for matrix, the decentralized communication protocol.
    #neochat # disable: marked unsecured because olm
    #kwave # sound editor. disable: marked as broken
    #ktouch # touch typing tutor. Disable: marked as broken
    ksnip # cross-platform screenshot tool with many annotation features
    plasmatube # kirigami youtube video player
    ktorrent # powerful bit torrent client
    kaddressbook # to manage contacts
    #kate # modern text editor
    tokodon # a mastodon client
    kalzium # periodic table of elements
    #itinerary # itinerary and boarding pass management application. Disabled because used insecure olm
    #kig # marked as broken
    #rocs # marked as brokes
    kdf
    ark
    kget # download manager
    kalk # powerful cross-platform calculator

    # games
    #kolf # miniature golf game with 2d top-down view
    #kigo # go game
    #bovo # a gomoku like game for two players

    kalm # learn different breathing techniques

    #---
    orca
    geary
    gnome-backgrounds
    gnome-tour
    gnome-user-docs
    baobab
    epiphany
    gnome-text-editor
    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-console
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-weather
    gnome-connections
    simple-scan
    snapshot
    totem
    yelp
    gnome-software

    #---------
    gnomeExtensions.blur-my-shell
    gnomeExtensions.pop-shell
  ];

#  environment.variables = {
#    XDG_CURRENT_DESKTOP = "GNOME"; # Default: "none+xmonad"
#    #XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
#    #XDG_CURRENT_DESKTOP = "shana"; # Default: "none+xmonad"
#    #XDG_CURRENT_DESKTOP = "gtk"; # Default: "none+xmonad"
#  };

  #environment.sessionVariables = {
  #  #XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
  #  XDG_SESSION_DESKTOP = "KDE";
  #};

#  systemd.user.services = {
#    #"xdg-desktop-portal-shana" = {
#    #  enable =true;
#    #  wantedBy = [ "default.target" ];
#    #};
#
#    "xdg-desktop-portal".enable = true;
#    "xdg-desktop-portal-gtk".enable = true;
#    #"xdg-desktop-portal-kde".enable = false;
#  };

  #home-manager.users.najib = {
  #  services.dunst.enable =true;
  #};

}
