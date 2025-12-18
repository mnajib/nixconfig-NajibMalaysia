# vim:set ts=2 sw=2 nowrap number
# profiles/nixos/hosts/customdesktop/configuration.nix

{
  pkgs, config, lib,
  home,
  vars, host, # ?
  inputs, outputs, # Need for home-manager
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  stateVersion = "23.11"; #"24.11";
  hostName = "customdesktop";

  #driveRiyadh1 = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC";
  #driveRiyadh2 = "ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04";
  #driveRiyadh3 = "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T";
  #
  #driveGarden1 = "ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0WN54C";
  #driveGarden2 = "ata-WDC_WD10SPCX-75KHST0_WXA1AA61VDLL";
  #driveGarden3 = "ata-WDC_WD10SPZX-00Z10T0_WD-WXK2A80LH7PC";
  #driveGarden4 = "ata-TOSHIBA_DT01ACA1000_626YTCBQCT";
  #driveGarden5 = "ata-WDC_WD1002FB9YZ-09H1JL1_WD-WC81Y7821691";
  #
  #drivePath = name: "/dev/disk/by-id/${name}";
  #
  #drives = import ./drives.nix;

  # With this, we can refer without prefix 'drives.'
  # for example 'driveRiyadh1' instead of 'drives.driveRiyadh1'.
  #inherit (drives)
  #  driveRiyadh1
  #  driveRiyadh2
  #  driveRiyadh3
  #  driveGarden1
  #  driveGarden2
  #  driveGarden3
  #  driveGarden4
  #  driveGarden5
  #  riyadhDrives gardenDrives
  #  drivePath;

  # import and destructure at once
  #inherit (import ./drives.nix);
  inherit (import ./drives.nix)
    driveRiyadh1 driveRiyadh2 driveRiyadh3
    driveGarden1 driveGarden2 driveGarden3 driveGarden4 driveGarden5
    riyadhDrives gardenDrives
    drivePath;

  #bootDisks = [
  #  "/dev/disk/by-id/ata-Drive1"
  #  "/dev/disk/by-id/ata-Drive2"
  #  "/dev/disk/by-id/ata-Drive3"
  #];

  #swapUUIDs = [
  #  "UUID-swap1"
  #  "UUID-swap2"
  #  "UUID-swap3"
  #];

in
{

  nix = {
    #package = pkgs.nixFlakes;
    #distributedBuilds = true;

    settings = {
      #max-jobs = 2;
      #max-jobs = 0;
      fallback = true;
      trusted-users = [
        "root" "najib"
        #"naqib"
        #"naim"
        #"nurnasuha"
        #"abdullah"
      ];
    };

      #builders-use-substitutes = true
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    #buildMachines = [
    #  {
    #    hostName = "nyxora";  # e.g., builder
    #    system = "x86_64-linux";  # Match your arch; use ["x86_64-linux" "aarch64-linux"] for multi-arch
    #    protocol = "ssh-ng";  # Modern SSH protocol (fallback to "ssh" if needed)
    #    sshUser = "najib";
    #    #maxJobs = 4;  # Parallel jobs on remote (match its CPU cores)
    #    #maxJobs = 6;  # Parallel jobs on remote (match its CPU cores)
    #    #speedFactor = 2;  # Prioritize this builder (higher = faster perceived)
    #    maxJobs = 14; #8;  # Parallel jobs on remote (match its CPU cores)
    #    speedFactor = 1;#1.0; # 2;  # Prioritize this builder (higher = faster perceived)
    #    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];  # Adjust based on remote capabilities (see table below)
    #    mandatoryFeatures = [];  # Enforce none unless required
    #    #notes.memoryPerJob = "≈3 GB";
    #    #notes.totalRAM = "64 GB";
    #  }
    #  {
    #    hostName = "sumayah";  # e.g., builder
    #    system = "x86_64-linux";  # Match your arch; use ["x86_64-linux" "aarch64-linux"] for multi-arch
    #    protocol = "ssh-ng";  # Modern SSH protocol (fallback to "ssh" if needed)
    #    sshUser = "najib";
    #    #maxJobs = 8;  # Parallel jobs on remote (match its CPU cores)
    #    maxJobs = 6; #10;  # Parallel jobs on remote (match its CPU cores)
    #    speedFactor = 2;#1.5; #2;  # Prioritize this builder (higher = faster perceived)
    #    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];  # Adjust based on remote capabilities (see table below)
    #    mandatoryFeatures = [];  # Enforce none unless required
    #    #notes.memoryPerJob = "≈2 GB";
    #    #notes.totalRAM = "16 GB";
    #  }
    #];

  }; # Eng nix = { ... };

  #nixpkgs.config = {
  #  allowUnfree = true;
  #};

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # But, is not supported with flakes.
  #system.copySystemConfiguration = true;

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    # TODO:
    #./hostname-specific-config/customdesktop.nix
    #./hardware-specific-config/ # box
    #./hardware-specific-config/ # harddisk

    ./hardware-configuration.nix
    #
    #./hardware-configuration-with-Riyadh2.nix
    #./disko/phase1-drives-wrapper.nix

    inputs.home-manager.nixosModules.home-manager

    #./configuration.FULL.nix
    (fromCommon "configuration.FULL.nix")
    #(fromCommon "remote-builders.nix")

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    # Internal/private network DNS server
    #(fromCommon "dnsmasq.nix")
    #(./. + "/${commonDir}/unbound.nix")
    #(fromCommon "unbound.nix")

    #./users-abdullah-wheel.nix
    #./users-anak2.nix
    #./users-naqib-wheel.nix
    #./users-nurnasuha-wheel.nix

    #(./. + "/${commonDir}/users-najib.nix")
    #(./. + "/${commonDir}/users-naqib.nix")
    #(./. + "/${commonDir}/users-naim.nix")
    #(./. + "/${commonDir}/users-nurnasuha.nix")
    #(./. + "/${commonDir}/users-julia.nix")

    (fromCommon "users-a-wheel.nix")
    (fromCommon "users-najib.nix")
    (fromCommon "users-naqib.nix")
    (fromCommon "users-naim.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-julia.nix")

    #./anbox.nix
    #./virtualbox.nix

    #(./. + "/${commonDir}/typesetting.nix")

    #./syncthing.nix

    # /var/lib/nextcloud/config/config.php
    #./nextcloud.nix  # OpenSSL 1.1 is marked as unsecured

    # System health monitoring
    #./netdata.nix

    # Email fetch and serve
    #./email.nix

    #(./. + "/${commonDir}/zfs.nix")
    (fromCommon "zfs.nix")
    (fromCommon "btrfs.nix")

    #(./. + "/${commonDir}/nfs-server-customdesktop.nix")
    #(./. + "/${commonDir}/nfs-client-automount.nix")
    (fromCommon "nfs-server-customdesktop.nix")
    (fromCommon "nfs-client-automount.nix")

    #./nfs-client-automount-games.nix
    #./nfs-client.nix

    #./samba-server-customdesktop.nix
    #./samba-client.nix

    #./console-keyboard-dvorak.nix
    #./keyboard-with-msa.nix
    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")

    #./audio-pulseaudio.nix
    #./audio-pipewire.nix
    (fromCommon "audio-pipewire.nix")

    #./synergy-client.nix # barrier

    #./hardware-printer.nix
    #./hardware-tablet-wacom.nix

    #./zramSwap.nix
    (fromCommon "zramSwap.nix")

    #./btrbk-pull.nix
    #./btrbk-tv.nix # XXX: Temporarily disabled as the HDD is failing.

    #./gogs.nix
    #./gitea.nix

    #./forgejo-sqlite.nix
    #(fromCommon "forgejo-sqlite.nix")
    (fromCommon "forgejo-sqlite-customdesktop.nix")

    #./hosts2.nix
    #./kodi.nix

    #./sway.nix

    #./nix-garbage-collector.nix
    (fromCommon "nix-garbage-collector.nix")

    #./timetracker.nix                  # desktop app for time management

    #./3D.nix
    #./steam.nix

    #./flatpak.nix
    #./appimage.nix

    #./walkie-talkie.nix

    #./jupyter.nix # jupyter-hub? jupyter-notebook?
    #./invidious.nix # for watch youtube. Need postgresql database

    (fromCommon "xdg.nix")
    (fromCommon "opengl.nix")
    (fromCommon "xmonad.nix")
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # custom desktop
  networking.hostId = "7b2076ba";
  networking.hostName = "customdesktop"; # "tv"; # tv.desktop.local

  networking.useDHCP = false;
  #networking.interfaces.enp7s0.useDHCP = true;
  #networking.interfaces.wlp3s0.useDHCP = true
  #networking.interfaces.enp7s0.ipv4.addresses = [ {
  #    address = "192.168.123.151";
  #    prefixLength = 24;
  #} ];
  #networking.defaultGateway = "192.168.123.1";
  # Refer network-dns.nix for DNS
  #networking.enableIPv6 = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  systemd.services.NetworkManager-wait-online.enable = false;

  #--------------------------------------------------------
  #boot.loader = {
  #  systemd-boot.enable = true;
  #  efi.canTouchEfiVariables = true;
  #  timeout = 10; #100;
  #
  #  grub = {
  #    #enable = true;
  #    #version = 2;
  #    efiSupport = true;
  #    enableCryptodisk = true;
  #    copyKernels = true;
  #    useOSProber = true;
  #    timeoutStyle = "menu";
  #    memtest86.enable = true;
  #
  #    #mirroredBoots = [
  #      #{
  #        #devices = [ "/dev/disk/by-id/wwn-0x5000cca7c5e11b3c" ];
  #        #path = "/boot2";
  #      #}
  #    #];
  #
  #    devices = [
  #      #"/dev/disk/by-id/wwn-0x5000c500a837f420" # 500GB HDD from sakinah
  #      #"/dev/disk/by-id/wwn-0x5000039fe7c9db77" # HDD from HP ProDesk Naqib
  #       (drivePath driveRiyadh3)
  #    ];
  #
  #  }; # End boot.loader.grub
  #}; # End boot.loader
  #
  boot.loader = {
    timeout = 10;
    #systemd-boot.enable = true;
    efi = {
      #canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true; #false;
      efiInstallAsRemovable = true;
      enableCryptodisk = true;
      copyKernels = true;
      useOSProber = false; #true;
      zfsSupport = true;
      timeoutStyle = "menu";
      memtest86.enable = true;

      # The devices on which the boot loader, GRUB, will be installed.
      devices = [
        #"/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"
        #"/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"

        # Both this drives intended to be two-drives-mirror Riyadh, but become two-drives-strip Riyadh by mistake
        #"/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"
        #"/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"
        #
        # The new drive, for temporary Riyadh2, for migrate the original two-drives-strip Riyadh to two-drives-mirror Riyadh.
        #"/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"
        #
        #(drivePath driveRiyadh1)
        #(drivePath driveRiyadh2)
        (drivePath driveRiyadh3)
      ];

      #mirroredBoots = [
      #  {
      #    path = "/boot1";
      #    devices = [ drivePath bootRiyadh1 ];
      #  }
      #  {
      #    path = "/boot2";
      #    devices = [ drivePath bootRiyadh2 ];
      #  }
      #  {
      #    path = "/boot3";
      #    devices = [ drivePath bootRiyadh3 ];
      #  }
      #];
      #
      # NOTE: Do not need this as wy mirror it using btrfs

    };
  };

  #fileSystems."/boot1" = {
  #  device = "/dev/disk/by-uuid/b4d2a502-05ea-4b3b-adf5-25e08dc3062a";
  #  fsType = "btrfs";
  #};

  #
  # NOTE:
  #  By default, NixOS will install latest LTS linux kernel
  #
  #boot.kernelPackages = pkgs.linuxPackages_latest; # test disable this while trying to solve monitor on build-in VGA, DVI, HDMI not detectded in Xorg, but detected in Wayland.
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_6_6;
  #boot.kernelParams = [
    ##"i915.modeset=0" "nouveau.modeset=1" # to disable i915 and enable nouveau
    #"video=DisplayPort-2:D"
    #"video=DP-1:D"
    #"video=DP-2:D"
    #"video=DP-3:D"
    #"video=HDMI-1:D"
    #"video=HDMI-2:D"
    #"video=HDMI-3:D"
    #"video=DVI-0:D"
    #"video=DVI-1:D"
    #"video=DVI-1-1:D"
    #"video=VGA-0:1280x1024@60me"
    #"video=VGA-1:1280x1024@60me"
  #];
  #boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" ]; # "zfs" bcachefs
  #boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; # "zfs" bcachefs
  #boot.loader.grub.copyKernels = true;
  #
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [];
  boot.supportedFilesystems = [ "btrfs"  "ext4" "xfs" "vfat" "zfs" "nfs" ];

  boot.initrd = {
    availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod" "mpt3sas" "sdhci_pci" ];
    kernelModules =          [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ];
    supportedFilesystems =   [ "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs" ];

    # Erasing the root dataset on each boot by roll back to the blank snapshot (after devices are made available)
    #postDeviceCommands = lib.mkAfter ''
    #  zfs rollback -r Riyadh2/nixos@blank
    #'';
  };

  boot.kernelParams = [
    # Changing the ZFS Adaptive Replacement Cache (ARC) size: To change the maximum and size of the ARC to (for example) 2 GB and 1 GB, add this to your NixOS configuration:
    "zfs.zfs_arc_max=2147483648" "zfs.zfs_arc_min=1073741824"                   # Need this to limit RAM usage for zfs cache.

    "nohibernate"
  ];

  #services.btrfs.autoScrub = {
  #  enable = true;
  #  fileSystems = [
  #    "/"
  #  ];
  #  interval = "weekly";
  #};

  services.fstrim.enable = true;
  hardware.enableAllFirmware = true;

  services.smartd.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      #PermitRootLogin = "prohibit-password";             # Needed for btrbk
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.mtr.enable = true;

  #networking.firewall.enable = false;
  # open port 24800 for barrier server?/client?
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      #1110  # NFS cluster
      #4045  # NFS lock manager

      22 # SSH
    ];
    allowedUDPPorts = [
      #1110  # NFS client
      #4045  # NFS lock manager
    ];
  };

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  #boot.kernelModules = [ "snd-ctxfi" "snd-ca0106" "snd-hda-intel" ];
  #boot.kernelModules = [ "snd-ctxfi" "snd-hda-intel" ];

  #services.logind.extraConfig = "RuntimeDirectorySize=4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001
  services.logind.settings.Login = {
    RuntimeDirectorySize = "4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001
  };

  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+xmonad";

  #------------------------------------
  services.xserver = {
    enable = true;

    # Test: Cuba disable, sebab SweetHome3D tak dapat jalan
    #videoDrivers = [ "nvidiaLegacy390" ]; #"radeon" "cirrus" "vesa"  "vmware"  "modesetting" ];
    #
    #videoDrivers = [ "radeon" ];

    #resolutions = [
    #  {
    #    x = 1280;
    #    y = 1024;
    #  }
    #  {
    #    x = 1024;
    #    y = 786;
    #  }
    #];

    #displayManager.sddm.enable = true;
    #displayManager.gdm.enable = true;
    displayManager.lightdm.enable = true;

    #desktopManager.plasma5.enable = true;
    #desktopManager.xfce.enable = true;
    #desktopManager.mate.enable = true;
    desktopManager.gnome.enable = true;
    #desktopManager.enlightenment.enable = true;

    windowManager = {
      awesome.enable = true;
      fluxbox.enable = true;
      jwm.enable = true;
      herbstluftwm.enable = true;
      notion.enable = true;
    };

  }; # End services.xserver
  #------------------------------------

  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # OR enable gnome desktopManager


  # Disable all power/screen saver; leave it to tv hardware
  powerManagement.enable = false;
  services.upower.enable = false;
  powerManagement.powertop.enable = false;
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = false;
  services.auto-cpufreq = {
    enable = true;
  };

  systemd.watchdog.rebootTime = "10m";

  #nix.maxJobs = 4;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    dig
    git
    tmux
    firefox
    gnome-terminal
    gnome-console
    alacritty
    enlightenment.terminology
    wget
    nnn ranger

    #blender
    #virtualboxWithExtpack

    # use in wayland
    gnome-randr
    foot

    inputs.home-manager.packages.${pkgs.system}.default # To install (globally, instead of per user) home-manager packages
  ];

  programs.zfs-snapshot-manager.enable = true;

  #virtualisation.virtualbox.host.enable = true;

  #
  # NOTE:
  #   journalctl -e --unit home-manager-najib.service --follow
  #   journalctl -e --unit home-manager-root.service --follow
  #
  home-manager = let
    userImport = user: import (./. + "/${hmDir}/${user}/${hostName}");
  in {
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs outputs;
    };
    users = {
      najib = userImport "najib";
      #root = userImport "root";
    };
  };

  #system.stateVersion = "22.05";
  #system.stateVersion = "22.11";
  #system.stateVersion = "23.05";
  #system.stateVersion = "23.11";
  system.stateVersion = "${stateVersion}";
}
