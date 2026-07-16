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
  # Custom GPU driver configuration #
  ###################################
  options.myGpu.driver = lib.mkOption {
    type = lib.types.enum [ "nvidia" "nouveau" ];
    default = "nouveau"; # choose "nvidia" or "nouveau"
    description = "Which GPU driver to use: nvidia (legacy 470xx) or nouveau";
  };

  config = lib.mkMerge [
    ###################################
    # Common graphics & display config #
    ###################################
    {
      services.xserver.enable = true;

      services.xserver.displayManager.lightdm.enable = true;
      #services.xserver.displayManager.gdm.enable = true;
      #services.xserver.displayManager.gdm.wayland =
      #  if config.myGpu.driver == "nouveau" then true else false;

      #services.xserver.desktopManager.gnome.enable = true;
      #services.xserver.desktopManager.plasma6.enable = true;

      #services.xserver.windowManager.i3.enable = true;
      services.xserver.windowManager.openbox.enable = true;

      programs.sway.enable = (config.myGpu.driver == "nouveau");
      programs.river.enable = (config.myGpu.driver == "nouveau");
      #programs.hyprland.enable = (config.myGpu.driver == "nouveau");

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
      console.keyMap = "dvorak";
      services.xserver.xkb.layout = "us";
      services.xserver.xkb.variant = "dvorak";
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

    #################################
    # NVIDIA legacy 470xx driver     #
    #################################
    (lib.mkIf (config.myGpu.driver == "nvidia") {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
        modesetting.enable = true;
        powerManagement.enable = false;
        open = false;
      };
    })

    #################################
    # Nouveau driver (open-source)   #
    #################################
    (lib.mkIf (config.myGpu.driver == "nouveau") {
      services.xserver.videoDrivers = [ "nouveau" ];
    })

  ]; # End 'config = lib.mkMerge [ ... ];'
}

