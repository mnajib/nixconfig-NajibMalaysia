{
  pkgs,
  config,
  lib,
  #home,
  #vars,
  #hosts,
  inputs, outputs, # for home-manager
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  hostName = "keira";
  stateVersion = "23.05";
in
{
  nix = {
    #package = pkgs.nixFlakes;
    settings = {
      cores = 3;
      max-jobs = 3;
      trusted-users = [ "root" "najib" "julia" ];
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager

    #./hardware-laptopLenovoThinkpadT410eWasteCyberjaya.nix
    #./hardware-storage-keira-SSD001.nix
    #./hardware-storage-keira-SSD002.nix

    #./configuration.MIN.nix
    (fromCommon "configuration.FULL.nix")

    #./bootEFI.nix
    #./bootBIOS.nix

    (fromCommon "thinkpad.nix")
    #./touchpad-scrollTwofinger-TapTrue.nix

    #./hosts.nix
    #./hosts2.nix
    #./network-dns.nix

    (fromCommon "users-najib.nix")
    (fromCommon "users-julia.nix")
    (fromCommon "users-anak2.nix")

    #./nfs-client.nix
    (fromCommon "nfs-client-automount.nix")

    (fromCommon "console-keyboard-us.nix")

    #./keyboard-with-msa.nix
    (fromCommon "keyboard-with-msa-keira.nix")
    #./keyboard-without-msa.nix
    #./keyboard-us_and_dv.nix

    #./audio-pulseaudio.nix
    (fromCommon "audio-pipewire.nix")

    #./synergy-client.nix # <-- replace with barrier

    (fromCommon "hardware-printer.nix")

    #(fromCommon "hardware-tablet-wacom.nix")
    #(fromCommon "hardware-tablet-digimend.nix")
    #(fromCommon "hardware-tablet-opentabletdriver.nix")

    (fromCommon "zramSwap.nix")

    #(fromCommon "xmonad.nix")
    (fromCommon "window-managers.nix")

    (fromCommon "btrbk-keira.nix")
    (fromCommon "nix-garbage-collector.nix")

    (fromCommon "monitoring-tools.nix")

    (fromCommon "flatpak.nix")
    (fromCommon "xdg.nix")
    (fromCommon "opengl.nix")

    (fromCommon "btrfs.nix")
  ];

  #
  # NOTE:
  #   journalctl -e --unit home-manager-najib.service --follow
  #   journalctl -e --unit home-manager-root.service --follow
  #
  home-manager = let
    userImport = user: import (./. + "/${hmDir}/${user}/${hostName}");
  in {
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      najib = userImport "najib";
      root = userImport "root";
      #julia = userImport "julia";
    };
  };

  # For Thinkpad T410
  #imports = [
  #    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/t410"
  #];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  #boot.kernelPackages = pkgs.linuxKernel.packages.latest;
  #boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_1;
  #boot.kernelPackages = pkgs.zfs.latestCompatibleLinuxPackages;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12; # linux_6_11
  #boot.kernelPackages = pkgs.linuxPackages_6_6;
  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernelParams = [
    #"nomodeset"
  ];

  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "btrfs" "ext4" "xfs" "vfat" "zfs" "ntfs" ];

  boot.initrd = {
    availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod" "mpt3sas" "sdhci_pci" ];
    kernelModules =        [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ];
    supportedFilesystems = [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ];
  };

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    timeoutStyle = "menu";
    efiSupport = false;
    enableCryptodisk = true;
    copyKernels = true;
    useOSProber = true; # XXX:
    memtest86.enable = true;
    #backgroundColor = "#7EBAE4"; # lightblue

    #------------------------------------------
    # BIOS
    #------------------------------------------
    #devices = [
    #  #"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
    #  #"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
    #  "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"                     # /dev/sda
    #  "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1017188"                     # /dev/sdb
    #];
    #efiSupport = true;
    mirroredBoots = [

      {
        devices = [ "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806" ];
        path = "/boot";
      }

      {
        devices = [ "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1017188" ];
        path = "/boot2";
      }

    ];
    #------------------------------------------

    #------------------------------------------
    # EFI
    #------------------------------------------
    #device = "nodev";
    #efiSupport = true;
    #mirroredBoots = [
    #  {
    #    devices = [ "/dev/disk/by-id/wwn-0x5000c5002ec8a164" ]; # /dev/sdb1
    #    path = "/boot2";
    #  }
    #];
    #------------------------------------------

  };

  services.smartd.enable = true;
  services.fstrim.enable = true;


  #----------------------------------------------------------------------------
  # btrfs
  #----------------------------------------------------------------------------
  # To list all timer:
  #   systemctl list-timers
  services.btrfs.autoScrub = {
    enable = true;
    #fileSystems = [ "/" ]; # Default: all
    #interval = "monthly";
    #interval = "weekly";
    #interval = "daily";
    #interval = "*-*-* 03:00:00"; # Daily, start at 03:00:00 ?
    interval = "02:00";
    #interval = "*-*-*/2 03:00:00"; # ... every two days, at 03:00:00 ?
  };
  #----------------------------------------------------------------------------


  #----------------------------------------------------------
  # Thinkpad T410 Shah Alam RM100 (price include T60)
  networking.hostId = "b74500be";
  networking.hostName = "keira"; # also called "tifoten"

  #networking.useDHCP = lib.mkForce true; # XXX:
  networking.useDHCP = false;
  #networking.interface.eno1.useDHCP = true;

  networking.nftables.enable = true;
  networking.firewall.enable = false;
  networking.firewall.allowPing = true;
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

  #----------------------------------------------------------
  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";
  #powerManagement.cpufreq.min = 800000;
  powerManagement.cpufreq.max = 2000000; # Guna 1500,000 KHz pada zahrah.
  services.power-profiles-daemon.enable = false;
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

  services.thinkfan = {
    enable = true;
    levels = [
      [ 0 0 55 ]
      [ "level auto" 48 60 ]
      [ "level auto" 50 61 ]
      [ 6 52 63 ]
      [ 7 56 65 ]
      [ "level full-speed" 60 85 ]
      [ "level full-speed" 80 32767 ]
    ];
  };

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  #----------------------------------------------------------
  security.sudo.extraRules = [
    {
      users = [ "najib" "julia" ];
      groups = [ "users" ];
      commands = [
        {
          command = "/home/julia/bin/decrease-trackpoint-sensitivity-x220.sh";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  #----------------------------------------------------------
  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 IBM TrackPoint";
    speed = 97;
    sensitivity = 130;
    emulateWheel = true;
  };

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.scrollMethod = "twofinger";
    touchpad.tapping = true; #false;
  };

  services.displayManager.defaultSession = "none+xmonad";

  services.xserver = {
    enable = true;
    displayManager = {
      #sddm.enable = true;
      lightdm.enable = true;
      gdm.enable = false;
      sessionCommands = ''
        xset -dpms
        xset s blank
        xset s 120
      '';
      #defaultSession = "none+xmonad";
    };
    desktopManager = {
      #plasma5.enable = true;
      #xfce.enable = true;
      #lxqt.enable = true;
      gnome.enable = true;
    };
    windowManager = {
      jwm.enable = true;
      icewm.enable = true;
      fluxbox.enable = true;
      awesome.enable = true;
    };
  };

  #----------------------------------------------------------
  environment.systemPackages = with pkgs; [
    stack
    cabal-install
    haskellPackages.xmobar
    haskellPackages.X11
    haskellPackages.X11-xft

    parted
    gparted

    #obs-studio

    inputs.home-manager.packages.${pkgs.system}.default
  ];

  system.stateVersion = "${stateVersion}";
}
