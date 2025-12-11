{
  config, pkgs,
  lib,
  inputs, outputs,
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  hostName = "asmak";
  hostID = "ec4da958";
  stateVersion = "22.11";
in
{
  nix = {
    #package = pkgs.nixFlakes;
    settings = {
      trusted-users = [ "root" "najib" "naqib" "julia" ];
      #max-jobs = lib.mkForce 2;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  #nixpkgs.config = {
  #  allowUnfree = true;
  #};

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ./hardware-configuration.nix

    #./bootEFI.nix
    #./bootBIOS.nix
    (fromCommon "thinkpad.nix")
    #./touchpad-scrollTwofinger-TapTrue.nix
    #./touchpad-scrollEdge-TapTrue.nix

    #./zfs.nix
    (fromCommon "zfs-for-asmak.nix")

    #./users-anak2.nix
    (fromCommon "users-najib.nix")
    (fromCommon "users-julia.nix")
    #(fromCommon "users-julia-wheel.nix")
    (fromCommon "users-naqib-wheel.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-naim.nix")

    (fromCommon "nfs-client-automount.nix")
    #(fromCommon "nfs-client-automount-games.nix")

    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")

    (fromCommon "audio-pipewire.nix")
    #./synergy-client.nix
    (fromCommon "hardware-printer.nix")
    (fromCommon "zramSwap.nix")
    #./hosts2.nix
    (fromCommon "configuration.FULL.nix")
    (fromCommon "nix-garbage-collector.nix")
    (fromCommon "flatpak.nix")
    (fromCommon "steam.nix")
    (fromCommon "xdg.nix")
    (fromCommon "opengl_with_vaapiIntel.nix")
    (fromCommon "stylix.nix")
    #./xmonad.nix
    (fromCommon "window-managers.nix")
    (fromCommon "desktops-wayland.nix")
    (fromCommon "bluetooth.nix")
    #(fromCommon "remote-builders.nix")
  ];

  home-manager = let
    userImport = user: import ( ./. + "/${hmDir}/${user}/${hostName}"  );
  in {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      najib = userImport "najib";
    };
  };

  users.users.root = {
    initialPassword = "root123";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiCR5IGdvop8gCL/wdEIoZsKzLJU1jiPPhjA1UbDVrt najib@sumayah"
    ];
  };

  environment.systemPackages = with pkgs; [
    gparted
    simplex-chat-desktop
    lightlocker

    clinfo
    gpu-viewer
    vulkan-tools

    gnome-randr
    foot
    libnotify

  ];

  # For the value of 'networking.hostID', use the following command:
  #   cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  #networking.hostId = "ec4da958";
  #networking.hostName = "asmak";
  networking.hostId = "${hostID}";
  networking.hostName = "${hostName}";

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  #services.xserver.libinput.tapping = pkgs.lib.mkForce true; # Will delete this line, do not need this anymore; instead I have put if-then-else for this in configuration.FULL.nix

  networking.nftables.enable = true;
  networking.firewall = {
    enable = false;
    #allowedTCPPorts = [ ... ];
    #allowedUDPPorts = [ 3450 ]; # 3450 for minetest server
  };

  # Create the file and allocate (storage) size for the file
  #   sudo fallocate -l 4096M /swapfile
  # OR
  #   sudo dd if=/dev/zero of=/swapfile bs=1M count=4096
  # then
  # Set correct permissions
  #   sudo chmod 600 /swapfile
  # Format it as swap
  #   sudo mkswap /swapfile
  # Enable the swap
  #   sudo swapon /swapfile
  #
  # If under zfs:
  #   sudo zfs create -V 4G -b 4K -o compression=off rpool/swap
  #   sudo mkswap /dev/zvol/rpool/swap
  #   sudo swapon /dev/zvol/rpool/swap
  #
  swapDevices = [
    {
      #device = "/swapfile";
      device = "/dev/zvol/tank/swap"; # for zfs
      size = 4096;
    }
  ];

  # not suitable for zfs?
  #services.swapspace = {
  #  enable = true;
  #  settings = {
  #    min_swapsize = "4096m";
  #    max_swapsize = "8192m";
  #  };
  #};

  boot.loader.timeout = 10;
  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    enableCryptodisk = true;
    copyKernels = true;
    useOSProber = true;
    devices = [
      #"/dev/disk/by-id/wwn-0x5000000000000000"
      "/dev/disk/by-id/ata-ADATA_SU630_2K472L1AJ5FE"
      "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMWWK0810910"
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
  #boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
  #boot.kernelPackages = pkgs.linuxPackages_5_4;
  #boot.kernelPackages = pkgs.linuxPackages_4_19;
  #boot.kernelPackages = pkgs.linuxPackages_6_6; # long time used by asmak until 2025-12
  boot.kernelPackages = pkgs.linuxPackages_6_12; # long time used by asmak until 2025-12

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

  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

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

  services.displayManager.defaultSession = "none+xmonad";
  #services.displayManager.sddm.enable = false;

  services.xserver = {
    enable = true;

    displayManager.sessionCommands = ''
      xset -dpms
      xset s blank
      xset s 120
      #${pkgs.lightlocker}/bin/light-locker --idle-hint &
    '';

    displayManager = {
      #defaultSession = "none+xmonad";
      lightdm.enable = true;
      #sddm.enable = false;
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
      #xmonad.enable = true; # import ./xmonad.nix
      jwm.enable = true;
      fluxbox.enable = true;
      awesome.enable = true;
      berry.enable = true;
    };
  };

  #system.stateVersion = "22.11";
  system.stateVersion = "${stateVersion}";
}
