# ./profiles/nixos/common/qemu.nix
{ config, pkgs, lib, ... }:

let
  username = "najib"; # 👈 Replace with your actual username
in {
  imports = [];

  config = {
    # 🧠 Enable libvirtd with QEMU backend
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;  # Use pkgs.qemu_full if you need more device support
        runAsRoot = false;        # Safer default; set true if needed for nested setups
      };
      allowedBridges = [
        #"virbr0"
        "br0"
      ];
    };

    # 👤 Add user to libvirtd group for socket access
    users.users.${username}.extraGroups = [ "libvirtd" ];

    # 🖥️ GUI tools and networking helpers
    environment.systemPackages = with pkgs; [
      virt-manager   # GTK frontend for libvirt
      spice-gtk      # SPICE display support
      dnsmasq        # User-mode networking
      bridge-utils   # Bridged networking

      polkit
      soteria        # Polkit authentication agent written in GTK designed to be used with any desktop environment
      #polkit_gnome   # lightweight gui polkit agent
      #mate.mate-polkit
      #lomiri.lomiri-polkit-agent
      #pantheon.pantheon-agent-polkit
      #deepin.dde-polkit-agent

      #kdePackages.polkit-kde-agent-1
      #libsForQt5.polkit-kde-agent
      #libsForQt5.polkit-qt
    ];

    # 🔌 Ensure dbus is enabled for virt-manager
    services.dbus.enable = true;

    # Enable base Polkit service
    security.polkit.enable = true;
    # not to use any GUI agent at all, you can instead allow members of libvirtd to manage VMs without prompts
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("libvirtd")) {
          return polkit.Result.YES;
        }
      });
    '';
    security.soteria.enable = true;

    # 🔓 Optional: open libvirt TCP port if needed
    networking.firewall.allowedTCPPorts = [ 16509 ];
  };
}

