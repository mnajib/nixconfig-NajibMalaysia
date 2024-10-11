{
  pkgs,
  config,
  ...
}:
{

  xdg.portal.enable = true; # only needed if you are not doing Gnome?

  xdg.portal.config = {
    common = {
      # uses the first portal implementation found in lexicographical order
      default = "*";
    };
  };

  ##key = if builtins.pathExists ./path then "woot" else "bummer";
  xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal
    #xdg-desktop-portal-gtk
    xdg-desktop-portal-kde
  ];

  environment.systemPackages = with pkgs; with kdePackages; [ # look in kdePackages first, if it's not found there, it then looks in pkgs.
    #zenity
    #xdg-utils
    #xdg-desktop-portal-gtk

    kdialog
    xdg-utils
    xdg-desktop-portal-kde

    #kdePackages.neochat # A client for matrix, the decentralized communication protocol.
    #neochat # disable: marked unsecured because olm
    #kwave # sound editor. disable: marked as broken
    #ktouch # touch typing tutor. Disable: marked as broken
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

  environment.variables = {
    #XDG_CURRENT_DESKTOP = "GNOME"; # Default: "none+xmonad"
    XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
  };

}
