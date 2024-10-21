{ config, pkgs, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    settings = {
      trusted-users = [ "root" "najib" "naqib" "julia" ];
      max-jobs = 2;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-asmak.nix
    #./bootEFI.nix
    #./bootBIOS.nix
    ./thinkpad.nix
    #./touchpad-scrollTwofinger-TapTrue.nix
    #./touchpad-scrollEdge-TapTrue.nix

    #./zfs.nix
    ./zfs-for-asmak.nix

    #./users-anak2.nix
    ./users-najib.nix
    #./users-julia.nix
    ./users-julia-wheel.nix
    ./users-naqib-wheel.nix
    ./users-nurnasuha.nix
    ./users-naim.nix

    ./nfs-client-automount.nix
    ./nfs-client-automount-games.nix
    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix
    ./audio-pipewire.nix
    #./synergy-client.nix
    ./hardware-printer.nix
    ./zramSwap.nix
    #./hosts2.nix
    ./configuration.FULL.nix
    ./nix-garbage-collector.nix
    ./flatpak.nix
    ./steam.nix
    ./xdg.nix
    ./opengl_with_vaapiIntel.nix
    ./xmonad.nix
  ];

  environment.systemPackages = with pkgs; [
    gparted
    simplex-chat-desktop
    lightlocker
  ];

  # For the value of 'networking.hostID', use the following command:
  #   cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "ec4da958";
  networking.hostName = "asmak";

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  #services.xserver.libinput.tapping = pkgs.lib.mkForce true; # Will delete this line, do not need this anymore; instead I have put if-then-else for this in configuration.FULL.nix

  networking.firewall = {
    enable = false;
    #allowedTCPPorts = [ ... ];
    #allowedUDPPorts = [ 3450 ]; # 3450 for minetest server
  };

  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    enableCryptodisk = true;
    copyKernels = true;
    useOSProber = true;
    devices = [
      "/dev/disk/by-id/wwn-0x5000000000000000"
    ];
    memtest86.enable = true;
    timeoutStyle = "menu";
  };

  boot.kernelParams = [
    #"nomodeset"                                                                # Need this to run OBS.

    # Changing the ZFS Adaptive Replacement Cache (ARC) size: To change the maximum and size of the ARC to (for example) 2 GB and 1 GB, add this to your NixOS configuration:
    "zfs.zfs_arc_max=2147483648" "zfs.zfs_arc_min=1073741824"                   # Need this to limit RAM usage for zfs cache.
  ];
  #boot.kernelPackages = pkgs.linuxPackages_latest;                             # Need this to make graphical display work on asmak.
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_5_4;
  #boot.kernelPackages = pkgs.linuxPackages_4_19;

  # Tuning other ZFS parameters: To tune other attributes of ARC, L2ARC or of ZFS itself via runtime modprobe config, add this to your NixOS configuration (keys and values are examples only!):
  #boot.extraModprobeConfig = ''
  #  options zfs l2arc_noprefetch=0 l2arc_write_boost=33554432 l2arc_write_max=16777216 zfs_arc_max=2147483648
  #'';
  # You can confirm whether any specified configuration/tuning got applied via commands like arc_summary and arcstat -a -s " "

  boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" "zfs" ]; # "zfs" "bcachefs"
  boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" "zfs" ]; # "zfs" "bcachefs"

  ## Pinning a kernel version
  #boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_4.override {
  #  argsOverride = rec {
  #    src = pkgs.fetchurl {
  #
  #      # Refer to
  #      #   https://www.kernel.org/
  #      #   https://nixos.wiki/wiki/Linux_kernel#Pinning_a_kernel_version
  #
  #      #url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.125.tar.xz";
  #      url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${version}.tar.xz";
  #
  #      #sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
  #      sha256 = "0g73xfkmj4sahrk7gx72hm2i4m98gqghswqyf8yqh77b9857bvhp";
  #    };
  #
  #    version = "5.4.125";
  #    modDirVersion = "5.4.125";
  #   };
  #});

  services.fstrim.enable = true;
  hardware.enableAllFirmware = true;
  services.smartd.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  services.libinput = {
    enable = true;

    touchpad = {
      scrollMethod = "twofinger"; # button, edge, twofinger, or none
      #clickMethod = "none"; # none, buttonareas, or clickfinger
      disableWhileTyping = true;
      #scrollButton = 1;
      tapping = true;
    };

    #mouse = {};
  };

  services.xserver = {
    enable = true;

    displayManager.sessionCommands = ''
      xset -dpms
      xset s blank
      xset s 120
      #${pkgs.lightlocker}/bin/light-locker --idle-hint &
    '';

    displayManager = {
      defaultSession = "none+xmonad";
      lightdm.enable = true;
      sddm.enable = false;
      gdm.enable = false;
    };

    desktopManager = {
      #plasma5.enable = true;
      #gnome.enable = true;
      #xfce.enable = true;
      #mate.enable = true;
      #lxqt.enable = true;
    };

    windowManager = {
      xmonad.enable = true;
      jwm.enable = true;
      fluxbox.enable = true;
      awesome.enable = true;
      berry.enable = true;
    };
  };

  system.stateVersion = "22.11";
}
