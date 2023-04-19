#·vim:·set·noexpandtab·tabstop=4·softtabstop=4·shiftwidth=4·autoindent·list·listchars=tab\:»\·,trail\:█,nbsp\:•: ,space\:· nowrap number:

{ pkgs, config, ... }:
{
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
  };

 imports = [
    #<nixos-hardware/lenovo/thinkpad/t410> # XXX: temporarily disabled because lazy to add nix channel
    ./hardware-configuration-raudah.nix
    #./hardware-configuration.nix
    #./hardware-laptopLenovoThinkpadT410eWasteCyberjaya.nix
    #./hardware-storageSSD001.nix
    ./thinkpad.nix

    #./hosts.nix
    ./hosts2.nix

    #./network-dns.nix

    #./users-anak2.nix
    #./users-najib.nix
    ./users-julia.nix
    ./users-naqib.nix
    ./users-nurnasuha.nix
    #./users-naim-wheel.nix
    ./users-naim.nix

    #./nfs-client.nix
    ./nfs-client-automount.nix

    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix
    #./keyboard-without-msa.nix

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    ./hardware-printer.nix
    #./hardware-tablet-wacom.nix
    #./hardware-tablet-digimend.nix
    #./hardware-tablet-opentabletdriver.nix

    ./zramSwap.nix

    #./configuration.MIN.nix
    ./configuration.FULL.nix

    #./btrbk.nix
    ./typesetting.nix
    ./nix-garbage-collector.nix
  ];

  nix.settings.trusted-users = [
    "root" "najib"
    #"julia"
    #"naim"
    "naqib"
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "ca54952d";
  networking.hostName = "raudah"; # T400

  hardware.enableAllFirmware = true;

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" "vfat" "ntfs" ];

  #boot.loader.systemd-boot.enable = true; # gummi-boot for EFI
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
    #devices = [
    ##"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
    ##"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
    ##"/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"
    #
    #"/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159" # /dev/sda (120GB SSD)
    ##"/dev/disk/by-id/ata-LITEONIT_LCS-256M6S_2.5_7mm_256GB_TW0XFJWX550854255987" # /dev/sdb (256GB SSD)
    #];
    #device = "/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159";
    #device = "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011006";
    device = "/dev/disk/by-id/ata-TOSHIBA_THNSNF128GCSS_43ES105NT8KY";
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

  services.fstrim.enable = true;

  #networking.useDHCP = false;
  #networking.interfaces.enp0s25.useDHCP = true;
  #networking.interfaces.wlp3s0.useDHCP = true;

  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    # Gluster
    24007         # gluster daemon
    24008         # management
    #49152        # brick1
    49153         # brick2
    #38465-38467  # Gluster NFS

    111           # portmapper

    1110          # NFS cluster
    4045          # NFS lock manager

    24800         # barrier server
  ];
  networking.firewall.allowedUDPPorts = [
    # Gluster
    111           # portmapper

    3450          # for minetest server

    1110          # NFS client
    4045          # NFS lock manager
  ];

  powerManagement.enable = true;
  #services.auto-cpufreq.enable = true;

  services.power-profiles-daemon.enable = false; # Need to disable this because it conflic with  services.tlp ?

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
      #DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
    };
  };

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 IBM TrackPoint";
    speed = 97;
    sensitivity = 130;
    emulateWheel = true;
  };

  # Custom script to decrease trackpoint sensitivity
  #...

  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.scrollMethod = "twofinger";
  services.xserver.libinput.touchpad.tapping = true; #false;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  #services.xserver.desktopManager.plasma5.enable = true;

  #nix.maxJobs = 1;
  #nix.settings.max-jobs = 1;
  #nix.settings.cores = 0;
  #
  # Note: Already define in configuration.FULL.nix file
  #
  #nix.daemonCPUSchedPolicy = "idle";
  #nix.daemonIOSchedClass = "idle"; # default "best-effort",
  #nix.daemonIOSchedPriority = 5; # 0(high,default) to 7(low).

  system.stateVersion = "22.05";
}
