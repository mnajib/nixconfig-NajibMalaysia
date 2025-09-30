# vim:set ts=2 sw=2 nowrap number

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
in
{

  nix = {
    #package = pkgs.nixFlakes;

    settings = {
      #max-jobs = 2;
      trusted-users = [
        "root" "najib"
        #"naqib"
        #"naim"
        #"nurnasuha"
        #"abdullah"
      ];
    };

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

  };

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

    inputs.home-manager.nixosModules.home-manager

    #./configuration.FULL.nix
    (fromCommon "configuration.FULL.nix")

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    # Internal/private network DNS server
    #./dnsmasq.nix
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
  #      "/dev/disk/by-id/wwn-0x5000039fe7c9db77" # HDD from HP ProDesk Naqib
  #    ];
  #
  #  }; # End boot.loader.grub
  #}; # End boot.loader
  #
  boot.loader = {
    timeout = 10;
    grub = {
      enable = true;
      efiSupport = false;
      enableCryptodisk = true;
      copyKernels = true;
      useOSProber = false; #true;
      devices = [
	"/dev/disk/by-id/ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"
	"/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"
      ];
      memtest86.enable = true;
      timeoutStyle = "menu";
    };
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

  #boot.kernelModules = [ "snd-ctxfi" "snd-ca0106" "snd-hda-intel" ];
  #boot.kernelModules = [ "snd-ctxfi" "snd-hda-intel" ];

  services.logind.extraConfig = "RuntimeDirectorySize=4G"; # before this it is 100% full with 1.6G tmpfs /run/user/1001

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
  ];

  #virtualisation.virtualbox.host.enable = true;

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
    };
  };

  #system.stateVersion = "22.05";
  #system.stateVersion = "22.11";
  #system.stateVersion = "23.05";
  #system.stateVersion = "23.11";
  system.stateVersion = stateVersion;
}
