# vim:set ts=2 sw=2 nowrap number

{
  pkgs, config,
  lib, home,
  vars, host,
  inputs, outputs,  # For home-manager
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  hostName = "nyxora";
  hostId = "a070cd92";
  stateVersion = "24.11";

  inherit (import ./drives.nix)
    drivePath
    driveMyStation1 driveMyStation2
    swapMyStation1 swapMyStation2
    bootMyStation1 bootMyStation2
    ;
in
{
  nix = {
    #package = pkgs.nixFlakes;

    settings = {
      #max-jobs = 2;

      trusted-users = [
        "root" "najib"
        #"nurnasuha"
        "naqib"
        #"abdullah"
      ];

    }; # End nix.settings = { ... };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }; # End nix = { ... };

  #nixpkgs.config = {
  #  allowUnfree = true;
  #};

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    # TODO:
    #./hostname-specific-config/customdesktop.nix
    #./hardware-specific-config/ # box
    #./hardware-specific-config/ # harddisk

    ./hardware-configuration.nix
    #./proxmox.nix
    ./smartd.nix # some drive with old controller board

    #./nvidia-quadro-k620.nix # Commented because replace this card with Radeon card
    ./radeon-rx-9060-xt.nix

    ./jami.nix

    #(./. + "${commonDir}/configuration.DESKTOP_FULL.nix")
    (fromCommon "configuration.DESKTOP_FULL.nix")
    #./configuration.SERVER.nix

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    #(./. + "/${commonDir}/users-abdullah-wheel.nix")
    #./users-anak2.nix
    #./users-naqib.nix
    #./users-naqib-wheel.nix
    #./users-nurnasuha-wheel.nix
    (fromCommon "users-najib.nix")
    (fromCommon "users-naqib.nix")
    (fromCommon "users-naim.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-julia.nix")
    #(fromCommon "users-abdullah-wheel.nix")

    #inputs.home-manager.nixosModules.home-manager

    #./anbox.nix
    #./virtualbox.nix

    #./typesetting.nix

    # /var/lib/nextcloud/config/config.php
    #./nextcloud.nix  # OpenSSL 1.1 is marked as unsecured

    # System health monitoring
    #./netdata.nix

    # Email fetch and serve
    #./email.nix

    #./zfs.nix
    #(./. + "/${commonDir}/zfs-nyxora.nix")
    ./zfs.nix

    #./nfs-server-customdesktop.nix
    ./services/nfs-server.nix

    (fromCommon "nfs-client-automount.nix")
    #./nfs-client-automount-games.nix
    #./nfs-client.nix

    #./samba-server-customdesktop.nix
    #./samba-server-nyxora.nix
    #./samba-client.nix

    (fromCommon "console-keyboard-dvorak.nix")
    #(fromCommon "keyboard-with-msa.nix")
    #
    ./kanata/keyboard-with-msa.nix
    ./kanata/kanata.nix

    (fromCommon "keyboard-QMK-VIA.nix")

    #./audio-pulseaudio.nix
    (fromCommon "audio-pipewire.nix")

    #./synergy-client.nix # barrier
    (fromCommon "deskflow.nix")

    (fromCommon "hardware-printer.nix")
    #(fromCommon "hardware-tablet-wacom.nix")

    (fromCommon "zramSwap.nix")

    #./btrbk-pull.nix
    #./btrbk-tv.nix # XXX: Temporarily disabled as the HDD is failing.

    ./services/bind.nix
    ./services/nginx.nix
    ./services/forgejo.nix
    ./services/postgresql.nix
    #./services/pgadmin.nix
    ./services/postgrest.nix
    #./services/refine.nix              # ???
    ./services/immich.nix
    ./services/tailscale.nix
    ./services/waktusolat-aggregator.nix

    #./hosts2.nix

    #./kodi.nix

    #./sway.nix

    (fromCommon "nix-garbage-collector.nix")

    #./timetracker.nix                  # desktop app for time management

    (fromCommon "3D.nix")
    #./steam.nix

    (./. + "/${commonDir}/flatpak.nix")
    #./appimage.nix

    (./. + "/${commonDir}/walkie-talkie.nix")

    #./jupyter.nix # jupyter-hub? jupyter-notebook?
    #./invidious.nix # for watch youtube. Need postgresql database

    #./xdg.nix
    #./opengl.nix

    #./tabby.nix # self-hosted AI coding assistant
    #(fromCommon "ai.nix")
    #./services/ai.nix
    #./services/ai-nvidia.nix
    ./services/ai-radeon.nix

    #./tenda-usb-wifi-dongle.nix

    (fromCommon "window-managers.nix")
    (fromCommon "qemu.nix")
    (fromCommon "bluetooth.nix")

    #./syncthing.nix
    ./services/syncthing.nix

    (fromCommon "packages/gis.nix")
  ];

  home-manager = let
    userImport = user: import (./. + "/${hmDir}/${user}/${hostName}");
  in {
    #extraSpecialArgs = { inherit inputs outputs; };
    #backupFileExtension = "backup";
    users = {
      # Import your home-manager configuration
      #najib = import ../../../home-manager/users/najib/nyxora/default.nix;
      #najib = import (./. + "/${hmDir}/najib/nyxora");
      najib = userImport "najib";
    };
  };

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "${hostId}"; #a070cd92"; #"e8213168";
  networking.hostName = "${hostName}"; #nyxora";

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

  networking.bridges.br0.interfaces = [ "enp8s0f0" ]; # for qemu vm
  networking.interfaces.br0.useDHCP = true;
  networking.interfaces.enp8s0f0.useDHCP = false;
  networking.bridges.br1.interfaces = [ ]; # for qemu vm

  #--------------------------------------------------------
  boot.loader = {
    systemd-boot.enable = false; # true;
    efi.canTouchEfiVariables = true;
    timeout = 10;

    grub = {
      enable = true;
      #version = 2;
      efiSupport = true;
      zfsSupport = true;

      # IMPORTANT: Set this to "nodev" for UEFI mirrored installs. This
      # prevents GRUB from trying to install to an MBR.
      #
      # When efiSupport = true is active, NixOS uses the mirroredBoots list to
      # determine where the EFI files go. Setting device = "nodev" tells the
      # NixOS GRUB wrapper: "Don't try to install a traditional boot sector to
      # a specific hard drive's MBR; just handle the EFI files and variables."
      device = "nodev";

      enableCryptodisk = true;
      copyKernels = true;
      useOSProber = true;
      timeoutStyle = "menu";
      memtest86.enable = true;

      mirroredBoots = [
        #{
          #devices = [ "/dev/disk/by-id/wwn-0x5000cca7c5e11b3c" ];
          #path = "/boot2";
        #}
        {
          devices = [
            #"/dev/disk/by-id/wwn-0x50014ee65ba9826e-part2"
            #"/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
            (drivePath bootMyStation1)
            #(drivePath driveMyStation1)
          ];
          path = "/boot";
        }
        {
          devices = [
            #"/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
            #"/dev/disk/by-id/wwn-0x50014ee65ba9826e-part2"
            (drivePath bootMyStation2)
            #(drivePath driveMyStation2)
          ];
          path = "/boot2";
        }
        #{
        #  devices = [
        #    #"/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
        #    #"/dev/disk/by-id/wwn-0x5000c5003fe08743-part2"  # "/dev/disk/by-id/ata-ST3500413AS_Z2ALGCNL-part2"
        #    (drivePath driveMyStation3)
        #  ];
        #  path = "/boot3";
        #}
      ];

      # This tells NixOS where to install GRUB — specifically, which disks' MBR or EFI partitions should receive the bootloader.
      #
      # - install GRUB to MBR of each disk
      # OR
      # - install GRUB's EFI files to the EFI System Partition (ESP) on each disk.
      #
      # This installs GRUB to both drives — so either can boot independently.
      #devices = [
      #  #"/dev/disk/by-id/wwn-0x5000c500a837f420"
      #  #"/dev/disk/by-id/wwn-0x50014ee65ba9826e"
      #  #"/dev/disk/by-id/wwn-0x5000c5003fe08743"
      #  (drivePath driveMyStation1)
      #  (drivePath driveMyStation2)
      #  #(drivePath driveMyStation3)
      #];

    }; # End boot.loader.grub
  }; # End boot.loader

  boot.initrd = {
    availableKernelModules = [
      "sym53c8xx"
      "ehci_pci" "ahci" "xhci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod" "mpt3sas"
      "uhci_hcd" "firewire_ohci" "sr_mod" "sdhci_pci"
      "ums_realtek"
      "mpt3sas"
      "ata_generic" #"iscsi"
    ];
    kernelModules = [
      "btrfs" "ext4" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" "zfs"
      #"ntfs"
      "kvm-intel"
    ];
    supportedFilesystems = [
      "ext4" "btrfs" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid"
      "zfs"
      #"bcachefs"
      #"ntfs"
    ];

    #postDeviceCommands = lib.mkAfter ''
    #
    #postMountCommands =  ''
    #  zfs rollback -r MyStation/local/root@blank
    #'';
  };

  #
  # NOTE:
  #  By default, NixOS will install latest LTS linux kernel
  #
  #boot.kernelPackages = pkgs.linuxPackages_latest; # test disable this while trying to solve monitor on build-in VGA, DVI, HDMI not detectded in Xorg, but detected in Wayland.
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_6_6;
  #boot.kernelPackages = pkgs.linuxPackages_6_12; # Pinned to 6.12 because 6.13+ causes networking issues on this hardware. Test disable on 2026-07-25.

  boot.kernelParams = [
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

    # NVidia card wint LG monitor: still not working
    #"video=DVI-1-0:e"
    #"video=DVI-1-1:e"

    # Disables Aggressive Link Power Management
    "ahci.mobile_lpm_policy=1"
    # Increases the timeout for SCSI commands to 60 seconds
    "scsi_mod.scan=async"

    # Disables deep dynamic power management for PCI devices (prevents GPU sleep crashes)
    # Side effect: screen not blank on idle ???
    #"amdgpu.runpm=0"

    #
    # sudo ethtool --set-eee eno1 eee off
    #
    # disabling Active State Power Management (ASPM)
    # in order try to resolve a Flapping Network Link, a condition where a
    # network interface repeatedly transitions between "Up" (connected) and
    # "Down" (disconnected) states.
    #
    # Sets PCIe power management to performance mode
    "pcie_aspm=off"
  ];

  ###boot.extraModulePackages = [
  ##  #config.boot.kernelPackages.rtl8821cu
  #boot.extraModulePackages = with config.boot.kernelPackages; [
  #  #rtl8821cu # now in file tenda-usb-wifi-dongle.nix
  #];

  boot.kernelModules = [
    "kvm-intel"
    #"snd-ctxfi" "snd-hda-intel"
    #"snd-ca0106"
    #"8821cu" # usb wifi dongle. now in separate file tenda-usb-wifi-dongle.nix
  ];

  # Only if you are an advanced user and are seeing scheduling issues:
  # The default Linux kernel is usually optimal for desktop use.
  #boot.kernel.sysctl = {
  #  "kernel.sched_latency_ns" = 4000000;
  #};

  boot.supportedFilesystems = [
    "ext4" "btrfs" "xfs" "vfat"
    "zfs"
    #"bcachefs"
    "ntfs"
    "dm-crypt" "dm-snapshot" "dm-raid"
  ];

  #--------------------------------------------------------

  #services.btrfs.autoScrub = {
  #  enable = true;
  #  fileSystems = [
  #    "/"
  #  ];
  #  interval = "weekly";
  #};

  services.fstrim.enable = true;
  hardware.enableAllFirmware = true;
  services.fwupd = {
    enable = true;
    daemonSettings = {
      DisabledPlugins = [
        "tpm"
        "uefi-capsule"
      ];
    };
  };

  services.smartd.enable = true;

  # XXX: ???
  services.openssh.settings.PermitRootLogin = "yes";                            #
  #services.openssh.settings.PermitRootLogin = "prohibit-password";             # Needed for btrbk

  #networking.firewall.enable = false;
  # open port 24800 for barrier server?/client?
  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      1110  # NFS cluster
      4045  # NFS lock manager

      22 # SSH
    ];
    allowedUDPPorts = [
      1110  # NFS client
      4045  # NFS lock manager
    ];
  };

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  #services.logind.extraConfig = "RuntimeDirectorySize=4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001
  services.logind.settings.Login = {
    RuntimeDirectorySize = "4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001
  };

  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+xmonad";

  #------------------------------------
  services.xserver = {
    enable = true;
    #dpi = 96;

    # Test: Cuba disable, sebab SweetHome3D tak dapat jalan
    #videoDrivers = [ "nvidiaLegacy390" ]; #"radeon" "cirrus" "vesa"  "vmware"  "modesetting" ];
    #videoDrivers = [ "nvidia" ];
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
    #displayManager.gdm = {
    #  enable = true;
    #  wayland = false;
    #};
    displayManager.lightdm.enable = true;

    #desktopManager.plasma5.enable = true;
    #desktopManager.xfce.enable = true;
    #desktopManager.mate.enable = true;
    #desktopManager.gnome.enable = true;
    desktopManager.lxqt.enable = true;
    #desktopManager.enlightenment.enable = true;

  }; # End services.xserver
  #------------------------------------

  services.desktopManager = {
    plasma6.enable = true;
    #budgie.enable = true;
    #gnome.enable = true;
    #pantheon.enable = true;
    #cosmic.enable = true;
    #lomiri.enable = true;
  };


  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # OR enable gnome desktopManager

  # Disable all power/screen saver; leave it to tv hardware
  powerManagement = {
    enable = true;
    #powertop.enable = true;
    cpuFreqGovernor = "performance";
  };

  services.thermald.enable = true;

  #services.upower.enable = true;
  #services.tlp.enable = true;
  #services.power-profiles-daemon.enable = false;
  #services.auto-cpufreq = {
  #  enable = true;
  #};

  systemd.watchdog.rebootTime = "10m";
  #systemd.settings.Manager.RebootWatchdogSec = "10min";

  #nix.maxJobs = 4;

  environment.systemPackages = with pkgs; [
  #environment.systemPackages = [
    #blender
    #virtualboxWithExtpack

    # use in wayland
    gnome-randr
    foot

    #android-studio-full
    android-studio

    #inputs.home-manager.packages.${pkgs.system}.default # To install (globbally, instead of per user) home-manager packages

    #inputs.my-emacs.packages.${pkgs.system}.default
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    emacs-all-the-icons-fonts

    usb-modeswitch
    usb-modeswitch-data

    #nvtopPackages.full
    #cudatoolkit
    pciutils

    kdePackages.ktouch
    #superfile
  ];

  #nixpkgs.config.android_sdk.accept_license = true;

  #services.udev.packages = [
  #  pkgs.android-udev-rules # 'android-udev-rules' has been removed due to being superseded by built-in systemd uaccess rules."; # Added 2025-10-21.
  #];

  #virtualisation.virtualbox.host.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true; # not supporetd with flakes

  #system.stateVersion = "24.11";
  system.stateVersion = "${stateVersion}";
}
