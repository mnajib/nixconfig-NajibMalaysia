#
# Example usage in configuration.nix:
#
#   imports = [
#     ./gpu-config.nix   # add GPU config module
#   ];
#   myGpu.driver = "nvidia"; # or "nouveau"
#

{ config, lib, pkgs, ... }:

{
  ###################################
  # Common graphics & display config #
  ###################################
  services.xserver.enable = true;
  programs.xwayland.enable = false;

  # lightdm
  services.xserver.displayManager.lightdm.enable = true;
  # OR
  # gdm
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.gdm.wayland = false;
  # OR
  # sddm
  services.displayManager.sddm.enable = false;
  services.displayManager.sddm.wayland.enable = false;

  services.xserver.desktopManager.gnome.enable = false;
  services.desktopManager.plasma6.enable = false;
  services.desktopManager.lomiri.enable = false;

  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.openbox.enable = true;

  #programs.sway.enable = true;
  #programs.river.enable = true;
  #programs.hyprland.enable = true;

  # The Plasma vs GNOME overlap problem;
  #
  # Plasma ships ksshaskpass (KDE askpass tool).
  # GNOME (via seahorse) ships seahorse-ssh-askpass.
  # Both try to set programs.ssh.askPassword → NixOS complains because it can’t merge two different values.
  #
  # Without resolving, NixOS can’t build your system because two modules define the same option.
  # With lib.mkForce, you pick one as the system-wide default.
  # That doesn’t stop you from running the other DE — it only decides which ssh-askpass binary gets called if ssh needs a password prompt in GUI.
  #
  # To tell NixOS which one should win.
  # If you use GNOME more often, use seahorse/ssh-askpass (better GNOME integration, works with gnome-keyring).
  programs.ssh.askPassword = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
  # OR, If you use Plasma more often, use ksshaskpass.
  #programs.ssh.askPassword = lib.mkForce "${pkgs.ksshaskpass}/bin/ksshaskpass";
  # OR, If you want a neutral option that works in either environment, you can use x11-ssh-askpass instead of GNOME/KDE’s:
  #programs.ssh.askPassword = lib.mkForce "${pkgs.x11_ssh_askpass}/bin/x11-ssh-askpass";

  #################################
  # Keyboard: Dvorak everywhere   #
  #################################
  #console.keyMap = "dvorak";
  #services.xserver.xkb.layout = "us";
  #services.xserver.xkb.variant = "dvorak";
  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "us";
    XKB_DEFAULT_VARIANT = "dvorak";
  };

  # Ensure XDG portals work for all
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];

}

