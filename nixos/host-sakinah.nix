{ config, pkgs, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-sakinah.nix
    #./bootEFI.nix
    ./bootBIOS.nix
    ./thinkpad.nix
    #<nixos-hardware/lenovo/thinkpad/x220>
    ./touchpad-scrollTwofinger-TapTrue.nix
    #./users-anak2.nix
    ./users-nurnasuha-wheel.nix
    #./hosts.nix
    ./hosts2.nix
    #./nfs-client.nix
    ./nfs-client-automount.nix
    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix
    #./audio-pipewire.nix
    ./audio-pulseaudio.nix
    #./synergy-client.nix
    ./hardware-printer.nix
    ./hardware-tablet-wacom.nix
    ./zramSwap.nix
    ./configuration.FULL.nix
    #./btrbk.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # Thinkpad T400 kepong
  networking.hostId = "6a063836";
  networking.hostName = "sakinah";

  nix.settings.trusted-users = [ "root" "najib" "nurnasuha" ];

  hardware.enableAllFirmware = true;

  # XXX:
  networking.useDHCP = false;
  #networking.interface.enp0s25.useDHCP = true;
  #networking.interface.wlp3s0.useDHCP = true;
  #networking.interface.wwp0s29u1u4i6.useDHCP = true;
  #networking.interface.wlp0s29u1u2.useDHCP = true;

  # XXX: Move this configuration to per-host
  #powerManagement.enable = true;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  #services.tlp.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  networking.firewall.enable = false;

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];
  boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];

  #zramSwap = {
  #  enable = true;
  #  algorithm = "zstd";
  #};

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 IBM TrackPoint";
    speed = 97;
    sensitivity = 130;
    emulateWheel = true;
  };

  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager.xfce.enable = true;
    displayManager.defaultSession = "none+xmonad";
  };

  nix.settings.max-jobs = 2;

  #environment.systemPackages = [
  #  pkgs.blender
  #];

  system.stateVersion = "22.05";
}
