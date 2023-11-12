# vim: set ts=2 sw=2 expandtab nowrap number:

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
    ./hardware-configuration-zahrah.nix
    #./hardware-configuration.nix
    #./hardware-laptopLenovoThinkpadT410eWasteCyberjaya.nix
    #./hardware-storageSSD001.nix
    ./thinkpad.nix

    ./hosts2.nix
    #./network-dns.nix

    #./users-anak2.nix
    #./users-najib.nix
    ./users-julia.nix
    ./users-naqib.nix
    ./users-nurnasuha.nix
    ./users-naim-wheel.nix

    #./nfs-client.nix
    ./nfs-client-automount.nix

    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix
    #./keyboard-without-msa.nix

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    ./hardware-printer.nix
    ./hardware-tablet-wacom.nix

    ./zramSwap.nix

    #./configuration.MIN.nix
    ./configuration.FULL.nix

    #./btrbk.nix

    ./typesetting.nix

    ./nix-garbage-collector.nix

    ./flatpak.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #

  nix.settings.trusted-users = [ "root" "najib" "naim" ];

  networking.hostId = "4dcfcacd";
  networking.hostName = "zahrah"; # also called "tifoten"

  hardware.enableAllFirmware = true;

  # Moved to hardware-configuration-zahrah.nix
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" "vfat" "ntfs" ];

  #environment.systemPackages = with pkgs; [
  #  nvtop
  #];

  #services.xserver.videoDrivers = [ "nouveau" ];
  #services.xserver.videoDrivers = [ "nvidia" ];
  #services.xserver.videoDrivers = [ "nvidia" "nvidiaLegacy340" "nouveau" "fbdev" ];
  #services.xserver.videoDrivers = [ "nvidiaLegacy340" "fbdev" ];
  #services.xserver.videoDrivers = [ "fbdev" ];
  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;
  #hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
  #hardware.nvidia.prime.sync.enable = true;
  hardware.nvidia.modesetting.enable = true;
  #hardware.nvidiaOptimus.disable = true; # Completely disable the NVIDIA graphics card and use the integrated graphics processor instead.
  hardware.nvidia.open = true;

  #boot.loader.systemd-boot.enable = true; # gummi-boot for EFI
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    #version = 2;
    enableCryptodisk = true;
    copyKernels = true;
    #useOSProber = true;
    #backgroundColor = "#7EBAE4"; # lightblue

    #------------------------------------------
    # BIOS
    #------------------------------------------
    #devices = [
    #	#"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
    #	#"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
    #	#"/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"
    #
    #	"/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159" # /dev/sda (120GB SSD)
    #	#"/dev/disk/by-id/ata-LITEONIT_LCS-256M6S_2.5_7mm_256GB_TW0XFJWX550854255987" # /dev/sdb (256GB SSD)
    #];
    #device = "/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159";
    device = "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011006";
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
    24007 # gluster daemon
    24008 # management
    #49152 # brick1
    49153 # brick2
    #38465-38467 # Gluster NFS
    111 # portmapper
    1110 # NFS cluster
    4045    # NFS lock manager
  ];

  networking.firewall.allowedUDPPorts = [
    # Gluster
    111 # portmapper
    3450 # for minetest server
    1110 # NFS client
    4045 # NFS lock manager
  ];

  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  #powerManagement.cpufreq.min =  800000;
  powerManagement.cpufreq.max = 1500000;

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
      DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
    };
  };

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  services.thinkfan.enable = true;
  services.thinkfan.levels = [
    [
      0
      0
      55
    ]
    [
      "level auto"
      48
      60
    ]
    [
      "level auto"
      50
      61
    ]
    [
      6
      52
      63
    ]
    [
      7
      56
      65
    ]
    [
      "level full-speed"
      60
      85
    ]
    [
      "level full-speed"
      80
      32767
    ]
  ];

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

  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.xserver.displayManager.defaultSession = "none+xmonad";
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.pantheon.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  #services.xserver.desktopManager.lumina.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.lxqt.enable = true;

  services.xserver.windowManager = {
    berry.enable = true;
    notion.enable = true;
    pekwm.enable = true;
    #qtile.enable = true;
    ratpoison.enable = true;
    tinywm.enable = true;
    smallwm.enable = true;
    yeahwm.enable = true;
    mlvwm.enable = true;
    leftwm.enable = true;
    icewm.enable = true;
    i3.enable = true;
    fvwm3.enable = true;
    bspwm.enable = true;
    openbox.enable = true;
    #mwm.enable = true;
    #lwm.enable = true;
    jwm.enable = true;
    fluxbox.enable = true;
    windowmaker.enable = true;
    twm.enable = true;
    awesome.enable = true;
    spectrwm.enable = true;
    wmderland.enable = true;
    herbstluftwm.enable = true;

    #hypr.enable = true;

    clfswm.enable = true;
    #stumpwm.enable = true;
    sawfish.enable = true;
    exwm.enable = true;

    "2bwm".enable = true;
  };

  #programs.sway.enable = true;
  #programs.xwayland.enable = true;

  #nix.maxJobs = 4;

  system.stateVersion = "22.05";
}
