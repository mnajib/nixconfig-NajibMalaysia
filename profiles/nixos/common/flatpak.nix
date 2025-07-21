# NOTE:
# Once flatpak is installed, we need to add the flathub repo:
#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

{
  pkgs,
  config,
  #lib,
  ...
}:
{
  #xdg.portal.enable = true; # only needed if you are not doing Gnome?

  #xdg.portal.config.common.default = "*";

  ##key = if builtins.pathExists ./path then "woot" else "bummer";
  #xdg.portal.extraPortals = [
  #  pkgs.xdg-desktop-portal-gtk
  #  ##xdg-desktop-portal-kde
  #  #pkgs.xdg-desktop-portal-gnome
  #];
  #environment.systemPackages = [
  #  pkgs.xdg-desktop-portal-gtk
  #  #pkgs.xdg-desktop-portal-gnome
  #  #pkgs.flatpak
  #  #pkgs.gnome.gnome-software
  #];

  services.flatpak.enable = true;
}
