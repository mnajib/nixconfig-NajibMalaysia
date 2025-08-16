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
  stateVersion = "24.11";
in
{
  nix = {
    #package = pkgs.nixFlakes;

    settings = {
      #max-jobs = 2;

      trusted-users = [
        "root" "najib"
        "nurnasuha"
        "naqib"
        #"abdullah"
      ];

    }; # End nix.settings = { ... };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  }; # End nix = { ... };

  nixpkgs.config = {
    allowUnfree = true;
  };

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    # TODO:
    #./hostname-specific-config/customdesktop.nix
    #./hardware-specific-config/ # box
    #./hardware-specific-config/ # harddisk

    ./hardware-configuration.nix

    #(./. + "${commonDir}/configuration.FULL.nix")
    (fromCommon "configuration.FULL.nix")
    #./configuration.SERVER.nix

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    # Internal/private network DNS server
    #./dnsmasq.nix
    #./unbound.nix

    (./. + "/${commonDir}/users-abdullah-wheel.nix")
    #./users-anak2.nix
    #./users-naqib.nix
    #./users-naqib-wheel.nix
    #./users-nurnasuha-wheel.nix
    (./. + "/${commonDir}/users-naqib.nix")
    (./. + "/${commonDir}/users-naim.nix")
    (./. + "/${commonDir}/users-nurnasuha.nix")
    (./. + "/${commonDir}/users-julia.nix")
    #(fromCommon "users-najib.nix")

    inputs.home-manager.nixosModules.home-manager

    #./anbox.nix
    #./virtualbox.nix

    #./typesetting.nix

    #./syncthing.nix

    # /var/lib/nextcloud/config/config.php
    #./nextcloud.nix  # OpenSSL 1.1 is marked as unsecured

    # System health monitoring
    #./netdata.nix

    # Email fetch and serve
    #./email.nix

    #./zfs.nix
    (./. + "/${commonDir}/zfs-nyxora.nix")

    #./nfs-server-customdesktop.nix
    (./. + "/${commonDir}/nfs-client-automount.nix")
    #./nfs-client-automount-games.nix
    #./nfs-client.nix

    #./samba-server-customdesktop.nix
    #./samba-server-nyxora.nix
    #./samba-client.nix

    (./. + "/${commonDir}/console-keyboard-dvorak.nix")
    (./. + "/${commonDir}/keyboard-with-msa.nix")

    #./audio-pulseaudio.nix
    (./. + "/${commonDir}/audio-pipewire.nix")

    #./synergy-client.nix # barrier

    (./. + "/${commonDir}/hardware-printer.nix")
    #./hardware-tablet-wacom.nix

    (./. + "/${commonDir}/zramSwap.nix")

    #./btrbk-pull.nix
    #./btrbk-tv.nix # XXX: Temporarily disabled as the HDD is failing.

    #./gogs.nix
    #./gitea.nix
    #./forgejo-sqlite.nix
    #(./. + "/${commonDir}/forgejo-sqlite.nix")
    #(fromCommon "forgejo-sqlite.nix")
    (fromCommon "forgejo-sqlite-nyxora.nix")

    #./hosts2.nix

    #./kodi.nix

    #./sway.nix

    (./. + "/${commonDir}/nix-garbage-collector.nix")

    #./timetracker.nix                  # desktop app for time management

    (./. + "/${commonDir}/3D.nix")
    #./steam.nix

    (./. + "/${commonDir}/flatpak.nix")
    #./appimage.nix

    (./. + "/${commonDir}/walkie-talkie.nix")

    #./jupyter.nix # jupyter-hub? jupyter-notebook?
    #./invidious.nix # for watch youtube. Need postgresql database

    #./xdg.nix
    #./opengl.nix

    #./tabby.nix # self-hosted AI coding assistant
    #./ai.nix

    #./tenda-usb-wifi-dongle.nix

    (fromCommon "window-managers.nix")
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      #najib = import ../home-manager/user-najib;
      #root = import ../home-manager/user-root;
      najib = import (./. + "/${hmDir}/najib/nyxora");
      root = import (./. + "/${hmDir}/root/nyxora");
    };
  };

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "a070cd92"; #"e8213168";
  networking.hostName = "nyxora";

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
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 10;

    grub = {
      #enable = true;
      #version = 2;
      efiSupport = true;
      enableCryptodisk = true;
      copyKernels = true;
      useOSProber = false; #true;
      timeoutStyle = "menu";
      memtest86.enable = true;

      mirroredBoots = [
        #{
          #devices = [ "/dev/disk/by-id/wwn-0x5000cca7c5e11b3c" ];
          #path = "/boot2";
        #}
        {
          devices = [
            "/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
            #"/dev/disk/by-id/wwn-0x50014ee65ba9826e-part2"
          ];
          path = "/boot";
        }
        {
          devices = [
            #"/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
            "/dev/disk/by-id/wwn-0x50014ee65ba9826e-part2"
          ];
          path = "/boot2";
        }
        {
          devices = [
            #"/dev/disk/by-id/wwn-0x5000c500a837f420-part2"
            "/dev/disk/by-id/wwn-0x5000c5003fe08743-part2"  # "/dev/disk/by-id/ata-ST3500413AS_Z2ALGCNL-part2"
          ];
          path = "/boot3";
        }
      ];

      devices = [
        "/dev/disk/by-id/wwn-0x5000c500a837f420"
        "/dev/disk/by-id/wwn-0x50014ee65ba9826e"
        "/dev/disk/by-id/wwn-0x5000c5003fe08743"
      ];

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

    postDeviceCommands = lib.mkAfter ''
      zfs rollback -r MyStation/local/root@blank
    '';
  };

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

  #boot.extraModulePackages = [
    #config.boot.kernelPackages.rtl8821cu
  boot.extraModulePackages = with config.boot.kernelPackages; [
    #rtl8821cu # now in file tenda-usb-wifi-dongle.nix
  ];

  boot.kernelModules = [
    "kvm-intel"
    #"snd-ctxfi" "snd-hda-intel"
    #"snd-ca0106"
    #"8821cu" # usb wifi dongle. now in separate file tenda-usb-wifi-dongle.nix
  ];

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

  services.smartd.enable = true;

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

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    # Card Nvidia GeForce GT 720 (in acer aspire taufiq).
    #package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    #
    # Card Nvidia Quadro K620 (in HP Z420 nyxora). --> Display Driver 570.133.07
    #package = config.boot.kernelPackages.nvidiaPackages.stable; # v 565.77
    #package = config.boot.kernelPackages.nvidiaPackages.latest; # v 565.77
    package = config.boot.kernelPackages.nvidiaPackages.production; # v 550.135
  };

  services.logind.extraConfig = "RuntimeDirectorySize=4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001

  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+xmonad";

  #------------------------------------
  services.xserver = {
    enable = true;
    dpi = 96;

    # Test: Cuba disable, sebab SweetHome3D tak dapat jalan
    #videoDrivers = [ "nvidiaLegacy390" ]; #"radeon" "cirrus" "vesa"  "vmware"  "modesetting" ];
    videoDrivers = [ "nvidia" ];
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
    desktopManager.gnome.enable = true;
    #desktopManager.enlightenment.enable = true;

  }; # End services.xserver
  #------------------------------------

  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # OR enable gnome desktopManager

  # Disable all power/screen saver; leave it to tv hardware
  #powerManagement.enable = true;
  #powerManagement.powertop.enable = true;
  #services.upower.enable = true;
  #services.tlp.enable = true;
  #services.power-profiles-daemon.enable = false;
  #services.auto-cpufreq = {
  #  enable = true;
  #};

  systemd.watchdog.rebootTime = "10m";

  #nix.maxJobs = 4;

  environment.systemPackages = with pkgs; [
  #environment.systemPackages = [
    #pkgs.blender
    #pkgs.virtualboxWithExtpack

    # use in wayland
    gnome-randr
    foot

    #android-studio-full
    android-studio

    inputs.home-manager.packages.${pkgs.system}.default # To install (globbally, instead of per user) home-manager packages

    usb-modeswitch
    usb-modeswitch-data
  ];

  nixpkgs.config.android_sdk.accept_license = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  #virtualisation.virtualbox.host.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true; # not supporetd with flakes

  #system.stateVersion = "24.11";
  system.stateVersion = "${stateVersion}";
}
