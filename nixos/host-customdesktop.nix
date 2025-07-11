# vim:set ts=2 sw=2 nowrap number

{
  pkgs, config,
  lib, home,
  vars, host,
  ...
}:
{
  nix = {
    #package = pkgs.nixFlakes;
    #settings.max-jobs = 2;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    # TODO:
    #./hostname-specific-config/customdesktop.nix
    #./hardware-specific-config/ # box
    #./hardware-specific-config/ # harddisk

    ./hardware-configuration-customdesktop.nix

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    # Internal/private network DNS server
    #./dnsmasq.nix
    ./unbound.nix

    #./users-abdullah-wheel.nix
    #./users-anak2.nix
    #./users-naqib.nix
    #./users-naqib-wheel.nix
    ./users-naqib.nix
    ./users-naim.nix
    #./users-nurnasuha-wheel.nix
    ./users-nurnasuha.nix
    ./users-julia.nix

    #./anbox.nix
    #./virtualbox.nix

    ./typesetting.nix

    #./syncthing.nix

    # /var/lib/nextcloud/config/config.php
    #./nextcloud.nix  # OpenSSL 1.1 is marked as unsecured

    # System health monitoring
    #./netdata.nix

    # Email fetch and serve
    #./email.nix

    ./zfs.nix

    ./nfs-server-customdesktop.nix
    ./nfs-client-automount.nix
    #./nfs-client-automount-games.nix
    #./nfs-client.nix

    #./samba-server-customdesktop.nix
    #./samba-client.nix

    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    #./synergy-client.nix # barrier

    ./hardware-printer.nix
    ./hardware-tablet-wacom.nix

    ./zramSwap.nix

    #./btrbk-pull.nix
    #./btrbk-tv.nix # XXX: Temporarily disabled as the HDD is failing.

    #./gogs.nix
    ./gitea.nix
    #./forgejo-sqlite.nix

    #./hosts2.nix
    ./configuration.FULL.nix

    #./kodi.nix

    #./sway.nix

    ./nix-garbage-collector.nix

    #./timetracker.nix                  # desktop app for time management

    ./3D.nix
    #./steam.nix

    ./flatpak.nix
    ./appimage.nix

    ./walkie-talkie.nix

    #./jupyter.nix # jupyter-hub? jupyter-notebook?
    #./invidious.nix # for watch youtube. Need postgresql database

    ./xdg.nix
    ./opengl.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # custom desktop
  networking.hostId = "7b2076ba";
  networking.hostName = "customdesktop"; # "tv"; # tv.desktop.local

  nix.settings.trusted-users = [
    "root" "najib"
    "nurnasuha"
    "naqib"
    #"abdullah"
  ];

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
  # XXX: aaa
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 100;

    grub = {
      #enable = true;
      #version = 2;
      efiSupport = true;
      enableCryptodisk = true;
      copyKernels = true;
      useOSProber = true;
      timeoutStyle = "menu";
      memtest86.enable = true;

      #mirroredBoots = [
        #{
          #devices = [ "/dev/disk/by-id/wwn-0x5000cca7c5e11b3c" ];
          #path = "/boot2";
        #}
      #];

      devices = [
        #"/dev/disk/by-id/wwn-0x5000c500a837f420" # 500GB HDD from sakinah
        "/dev/disk/by-id/wwn-0x5000039fe7c9db77" # HDD from HP ProDesk Naqib
      ];

    }; # End boot.loader.grub
  }; # End boot.loader

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
    #desktopManager.gnome.enable = true;
    #desktopManager.enlightenment.enable = true;

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

  #environment.systemPackages = with pkgs; [
  environment.systemPackages = [
    #pkgs.blender
    #pkgs.virtualboxWithExtpack

    # use in wayland
    pkgs.gnome-randr
    pkgs.foot
  ];

  #virtualisation.virtualbox.host.enable = true;

  #system.stateVersion = "22.05";
  #system.stateVersion = "22.11";
  #system.stateVersion = "23.05";
  system.stateVersion = "23.11";
}
