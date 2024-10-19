{
  pkgs,
  config,
  ...
}:
{

  xdg.portal = {
    enable = false;
    xdgOpenUsePortal = true; # This will make xdg-open use the portal to open programs.

    #lxqt = {
    #  enable = true;
    #  #styles = [];
    #};

    configPackages = with pkgs; [
      #gnome-session
      xdg-desktop-portal-gtk
    ];

    config = {
      common = {
        # uses the first portal implementation found in lexicographical order
        #default = "*";
        #
        default = [
          #"kde"
          "gtk"
        ];
      };
    }; # End xdg.portal.config

    ##key = if builtins.pathExists ./path then "woot" else "bummer";
    extraPortals = with pkgs; [
      #xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      #xdg-desktop-portal
    ];
  }; # End xdg.portal

  environment.systemPackages = with pkgs; with kdePackages; [ # look in kdePackages first, if it's not found there, it then looks in pkgs.
    #zenity
    #xdg-utils
    xdg-desktop-portal-gtk
    #xdg-desktop-portal
    kdialog
    #xdg-desktop-portal-kde
    #xdg-desktop-portal-xapp # for cinnamon, MATE, Xfce
    #xdg-desktop-portal-shana # filechooser portal backend for any desktop environment
    #lxqt.xdg-desktop-portal-lxqt # backend implementation for xdg-desktop-portal that is using Qt/KF5/libfm-qt

    #kdePackages.neochat # A client for matrix, the decentralized communication protocol.
    #neochat # disable: marked unsecured because olm
    #kwave # sound editor. disable: marked as broken
    #ktouch # touch typing tutor. Disable: marked as broken
    ksnip # cross-platform screenshot tool with many annotation features
    plasmatube # kirigami youtube video player
    ktorrent # powerful bit torrent client
    kaddressbook # to manage contacts
    kate # modern text editor
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
    kolf # miniature golf game with 2d top-down view
    kigo # go game
    bovo # a gomoku like game for two players

    kalm # learn different breathing techniques
  ];

  #environment.variables = {
    #XDG_CURRENT_DESKTOP = "GNOME"; # Default: "none+xmonad"
    #XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
  #};

  #environment.sessionVariables = {
  #  #XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
  #  XDG_SESSION_DESKTOP = "KDE";
  #};

}
