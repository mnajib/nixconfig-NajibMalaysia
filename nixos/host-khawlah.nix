# vim: set ts=2 sw=2 expandtab nowrap number:

{ pkgs, config, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-khawlah.nix
    #./bootEFI.nix # harddisk asal dari laptop x230 khawlah
    ./bootBIOS.nix # harddisk dari laptop lain, pindah ke x230, tukar ke hostname khawlah
    #./network-dns.nix
    #./hosts2.nix
    ./users-anak2.nix
    ./thinkpad.nix
    #<nixos-hardware/lenovo/thinkpad/x230>
    #./anbox.nix
    ./nfs-client-automount.nix
    #./audio-pulseaudio.nix
    ./audio-pipewire.nix
    ./hardware-printer.nix
    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix
    #./keyboard-kmonad.nix
    ./zramSwap.nix
    ./configuration.FULL.nix
    #./btrbk-khawlah.nix
    ./typesetting.nix
    ./nix-garbage-collector.nix

    #./gnome.nix
    #./hyprland.nix

    ./logitech-unifying.nix
    ./xdg.nix
    ./opengl.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # x230
  networking.hostId = "33df86ff";
  networking.hostName = "khawlah";

  services.fstrim.enable = true;
  hardware.enableAllFirmware = true;
  services.smartd.enable = true;

  nix.settings.trusted-users = [
    "root"
    "najib"
    "naqib"
  ];

  # XXX:
  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" ];
  #boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];

  # Swap-file on xfs on encrypted-partition
  #swapDevices =
  #    [ {
  #          device = "/swap/swapfile";
  #          neededForBoot = true;
  #      }
  #    ];

  # XXX: Move this configuration to per-host
  #powerManagement.enable = true;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  #services.tlp.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  networking.firewall = {
    enable = false;
    # Open ports in the firewall.
    #allowedTCPPorts = [ ... ];
    #allowedUDPPorts = [ ... ];
    #allowedUDPPorts = [ 3450 ]; # 3450 for minetest server
  };

  services.libinput = {
    enable = true;
  };

  services.displayManager = {
    #lightdm.enable = true;
    defaultSession = "none+xmonad";
  };

  #services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  #services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.deepin.enable = true;
  #services.xserver.desktopManager.budgie.enable = true;
  services.desktopManager = {
    plasma6.enable = true;
  };

  services.xserver = {
    windowManager = {
      fluxbox.enable = true;
    };
  };

  system.stateVersion = "22.05";
}
