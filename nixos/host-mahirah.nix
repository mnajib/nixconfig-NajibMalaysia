{ pkgs, config, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-mahirah.nix
    ./hosts2.nix
    #./hosts.nix
    ./configuration.FULL.nix
    #./bootEFI.nix
    #./bootBIOS.nix
    ./thinkpad.nix
    #./touchpad-scrollEdge-TapFalse.nix
    ./console-keyboard-dvorak.nix
    #./keyboard-with-msa.nix
    ./keyboard-without-msa.nix
    #./network-dns.nix
    ./users-julia.nix
    ./users-anak2.nix
    ./nfs-server.nix
    ./nfs-client-automount.nix
    ./audio-pulseaudio.nix
    #./audio-pipewire.nix
    ./hardware-printer.nix
    ./zramSwap.nix

    ./btrbk-mahirah.nix

    #./gogs.nix
    ./gitea.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # Thinkpad T400 highres RM150
  networking.hostId = "e07c9d49"; # "12331345"
  networking.hostName = "mahirah";
  networking.useDHCP = false;

  #boot.loader.systemd-boot.enable = true;
  nix.settings.trusted-users = [ "root" "najib" ];

  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    enableCryptodisk = true;
    copyKernels = true;
    #useOSProber = true;
    #backgroundColor = "#7EBAE4"; # lightblue

    #------------------------------------------
    # BIOS
    #------------------------------------------
    devices = [
      "/dev/disk/by-id/wwn-0x5000c5002ea341bc"
      "/dev/disk/by-id/wwn-0x5000c5002ec8a164"
    ];
    #efiSupport = true;

    #------------------------------------------
    # EFI
    #------------------------------------------
    #device = "nodev";
    #efiSupport = true;
    #mirroredBoots = [
    #    {
    #        devices = [ "/dev/disk/by-id/wwn-0x5000c5002ec8a164" ]; # /dev/sdb1
    #        path = "/boot2";
    #    }
    #];
  };

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" ]; #zfs
  #boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" ];
  #boot.kernelParams = [ "zfs.zfs_arc_max=12884901888" ];
  #boot.zfs.enableUnstable = true;
  #boot.loader.grub.copyKernels = true;
  #services.zfs.autoScrub.enable = true;
  # ... zfs trim support for SSDs ...

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  powerManagement.enable = true;
  services.tlp.enable = true;
  services.auto-cpufreq.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  # Not remember why I need this. btrbk?
  services.openssh.permitRootLogin = "prohibit-password"; # one of "yes", "without-password", "prohibit-password", "forced-commands-only", "no"

  networking.firewall.enable = false;
  #networking.firewall.allowedTCPPorts = [
  #  2049 # nfs server
  #];

  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.disableWhileTyping = false;
  services.xserver.libinput.touchpad.scrollMethod = "edge";
  services.xserver.libinput.touchpad.tapping = false;
}
