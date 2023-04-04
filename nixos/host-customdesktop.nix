# vim:set ts=4 sw=4 nowrap number

{ pkgs, config, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    #./hardware-configuration-tv.nix
    # rename to
    ./hardware-configuration-customdesktop.nix

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix

    # Disable this; as we can just set custom DNS in NetworkManager
    #./network-dns.nix

    ./users-anak2.nix

    #./anbox.nix
    ./virtualbox.nix

    ./typesetting.nix

    #./syncthing.nix
    ./nextcloud.nix

    # Email fetch and serve
    #./email.nix

    ./nfs-client-automount.nix
    #./nfs-client.nix

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

    ./hosts2.nix
    ./configuration.FULL.nix

    #./kodi.nix

    #./sway.nix

    # XXX:
    ./nix-garbage-collector.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # custom desktop
  networking.hostId = "7b2076ba";
  networking.hostName = "customdesktop"; # "tv"; # tv.desktop.local

  nix.settings.trusted-users = [ "root" "najib" ];

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

  #boot.loader.systemd-boot.enable = true;

  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = false;
    enableCryptodisk = true;
    copyKernels = true;

    #mirroredBoots = [
      #{
        #devices = [ "/dev/disk/by-id/wwn-0x5000cca7c5e11b3c" ];
        #path = "/boot2";
      #}
    #];
    useOSProber = true;

    #device = "/dev/sda"; #"nodev";
    devices = [
      #"/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011005-part1"
      #"/dev/disk/by-id/wwn-0x5000c5001f67c049-part1"
      #"/dev/sda1"
      #"3dacbf58-01"

      #"/dev/sda"
      "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011005"
    ];
  };

  #boot.kernelPackages = pkgs.linuxPackages_latest; # XXX: test disable this while trying to solve monitor on build-in VGA, DVI, HDMI not detectded in Xorg, but detected in Wayland.
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  boot.kernelParams = [
    #"video=DisplayPort-2:D"
    "video=HDMI-2:D"
    "video=DVI-0:D"

    "video=HDMI-1:D"
    "video=DVI-1:D"
    "video=DVI-1-1:D"
    "video=VGA-0:1280x1024@60me"
    "video=VGA-1:1280x1024@60me"
  ];
  #boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" ]; # "zfs" bcachefs
  #boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" "dm-crypt" "dm-snapshot" "dm-raid" ]; # "zfs" bcachefs
  #boot.loader.grub.copyKernels = true;

  services.fstrim.enable = true;
  hardware.enableAllFirmware = true;

  # Needed for btrbk
  services.openssh.permitRootLogin = "prohibit-password";

  networking.firewall.enable = false;
  # open port 24800 for barrier server?/client?

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  #boot.kernelModules = [ "snd-ctxfi" "snd-ca0106" "snd-hda-intel" ];
  #boot.kernelModules = [ "snd-ctxfi" "snd-hda-intel" ];

  services.xserver.enable = true;

  # Test: Cuba disable, sebab SweetHome3D tak dapat jalan
  #services.xserver.videoDrivers = [ "nvidiaLegacy390" ]; #"radeon" "cirrus" "vesa"  "vmware"  "modesetting" ];
  #
  #services.xserver.videoDrivers = [ "radeon" ];

  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # OR enable gnome desktopManager

  #services.xserver.resolutions = [
  #  {
  #    x = 1280;
  #    y = 1024;
  #  }
  #  {
  #    x = 1024;
  #    y = 786;
  #  }
  #];

  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";

  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;

  services.xserver.libinput.enable = true;

  # Disable all power/screen saver; leave it to tv hardware
  powerManagement.enable = false;
  services.upower.enable = false;
  powerManagement.powertop.enable = false;
  services.tlp.enable = false;
  services.auto-cpufreq = {
    enable = true;
  };

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  #nix.maxJobs = 4;

  #environment.systemPackages = with pkgs; [
  environment.systemPackages = [
    pkgs.blender
    pkgs.virtualboxWithExtpack

    # use in wayland
    pkgs.gnome-randr
    pkgs.foot
  ];

  #system.stateVersion = "22.11";
}
