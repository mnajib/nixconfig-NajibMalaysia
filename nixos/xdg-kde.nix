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

  environment.systemPackages = with pkgs; [
    #zenity
    #xdg-utils
    #xdg-desktop-portal-gtk

    kdialog
    xdg-utils
    xdg-desktop-portal-kde
  ];

  environment.variables = {
    #XDG_CURRENT_DESKTOP = "GNOME"; # Default: "none+xmonad"
    XDG_CURRENT_DESKTOP = "KDE"; # Default: "none+xmonad"
  };

}
