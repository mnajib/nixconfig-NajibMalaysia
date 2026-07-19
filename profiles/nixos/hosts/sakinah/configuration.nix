{
  config, pkgs,
  lib,
  inputs, outputs,
  ...
}:
let
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  hostName = "sakinah";                 # Machine gw/firewall (Dell Inspiron 620s, with with multiple eth)
  hostId = "6a063836";                  # cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  stateVersion = "26.05";
in {

  nix = {
    #package = lib.mkForce pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #settings.experimental-features = "nix-command flakes";

    settings.trusted-users = [
      "root" "najib"
      "naqib"
      "a" # XXX
    ];

  };

  #
  # PROBLEM:
  #   The build failed because a Python library called clevercsv (specifically for Python 3.14) crashed during its pytestCheckPhase.
  #
  # TEMPORARY WORKAROUND:
  #   Since this is an upstream bug with the package's test suite and not an issue with your actual system configuration, the standard Nix workaround is to apply an overlay that tells the builder to skip tests (doCheck = false) for this specific package.
  #   By adding this, Nix will skip the pytestCheckPhase for clevercsv, successfully build the package, and allow your system compilation to finish.
  #
  # XXX: TODO:
  #   Once a few days pass and the Nixpkgs maintainers patch the test upstream, you can safely remove this overlay.
  #
  /*
  nixpkgs.overlays = [
    (final: prev: {
      # Modern NixOS way to override Python package sets globally
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          clevercsv = python-prev.clevercsv.overridePythonAttrs (old: {
            # Bypass the broken upstream tests
            doCheck = false;
          });
        })
      ];
    })
  ];
  */

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ./hardware-configuration.nix
    (fromCommon "configuration.FULL.nix")
    (fromCommon "users-najib.nix")
    (fromCommon "users-naqib-wheel.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-naim.nix")
    (fromCommon "users-julia.nix")
    (fromCommon "nfs-client-automount.nix")
    #(fromCommon "samba-client.nix")
    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")
    (fromCommon "audio-pipewire.nix")
    (fromCommon "hardware-printer.nix")
    (fromCommon "zramSwap.nix")
    (fromCommon "window-managers.nix")
    (fromCommon "nix-garbage-collector.nix")
    (fromCommon "bluetooth.nix")
    (fromCommon "flatpak.nix")
    #(fromCommon "packages/databases.nix")

    #inputs.home-manager.nixosModules.default # Home Manager module
    #inputs.home-manager-unstable.nixosModules.default # Home Manager module

    #(fromCommon "opengl.nix")
    #(fromCommon "opengl2.nix")

    #(fromCommon "xdg.nix")
    #./xdg-gtk.nix
    #./xdg-kde.nix

    #./gpu-config-wayland.nix
    #./gpu-config-xorg.nix

    #(fromCommon "flatpak.nix")
    #(fromCommon "stylix.nix")

    #(fromCommon "bluetooth.nix")

    ./winboat.nix
  ];

  home-manager = let
    userImport = user: import (./. + "/${hmDir}/${user}/${hostName}");
  in {
    #backupFileExtension = "backup";
    #extraSpecialArgs = {
    #  inherit inputs outputs; # to pass arguments to home.nix
    #};
    users = {
      najib = userImport "najib";
      #root = userImport "root";
      #julia = userImport "julia";
      a = userImport "a";
    };
  };

  # Booting
  boot.loader = {
    timeout = 10; #null;
    #grub = {
    #  useOSProber = true;
    #  timeoutStyle = "menu";
    #  efiSupport = true;
    #  #gfsmodeEfi = "1566x768";
    #  #gfsmodeBios = "1024x768";
    #  #memtest86.enable = true;
    #};
    systemd-boot = {
      enable = true;
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };

  boot.kernelParams = [
    "zfs.zfs_arc_max=2147483648"          # Limit ZFS cache (ARC) to 2GB to save RAM
  ];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.devNodes = "/dev/disk/by-id";  # Helps ZFS find drives reliably
  services.zfs.autoScrub.enable = true;

  # Ensure both swaps are activated automatically
  swapDevices = [
    { device = "/dev/sda2"; }
    { device = "/dev/sdb2"; }
  ];

  #
  # NOTE:
  #
  #   For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "${hostId}";
  networking.hostName = "${hostName}";

  hardware.enableAllFirmware = true;

  #myGpu.driver = "nvidia";
  #myGpu.driver = "nouveau";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      libva-vdpau-driver # vaapiVdpau
      mesa #mesa.drivers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      libva-vdpau-driver # vaapiVdpau
    ];
  };

  services.fstrim.enable = true;
  services.fwupd.enable = true;

  networking.useDHCP = false;
  #networking.interface.enp0s25.useDHCP = true;
  #networking.interface.wlp3s0.useDHCP = true;
  #networking.interface.wwp0s29u1u4i6.useDHCP = true;
  #networking.interface.wlp0s29u1u2.useDHCP = true;
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      enabled = "fcitx5"; # Enforces standard XKB rules system-wide across Wayland/X11 layers
    };
    /*
    extraLocaleSettings = {
      LC_ADDRESS = "ms_MY.UTF-8";
      LC_IDENTIFICATION = "ms_MY.UTF-8";
      LC_MEASUREMENT = "ms_MY.UTF-8";
      LC_MONETARY = "ms_MY.UTF-8";
      LC_NAME = "ms_MY.UTF-8";
      LC_NUMERIC = "ms_MY.UTF-8";
      LC_PAPER = "ms_MY.UTF-8";
      LC_TELEPHONE = "ms_MY.UTF-8";
      LC_TIME = "ms_MY.UTF-8";
    };
    */
  };

  # Move this configuration to per-host
  #powerManagement.enable = true;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  #services.tlp.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  services.openssh.enable = true;

  # Copy NixOS configuration file from the resulting system (to?) '/run/current-system/configuration.nix'
  # But it is not supported with flakes.
  #system.copySystemConfiguration = true;

  networking.nftables.enable = true;
  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [
      1110 # NFS cluster
      4045 # NFS lock manager
      # 30000 # minetest
    ];
    allowedUDPPorts = [
      1110 # NFS client
      4045 # NFS lock manager
    ];
  };

  #hardware.trackpoint = {
  #  enable = true;
  #  device = "TPPS/2 IBM TrackPoint";
  #  speed = 97;
  #  sensitivity = 130;
  #  emulateWheel = true;
  #};

  #services.libinput = {
  #  enable = true;
  #  touchpad = {
  #    disableWhileTyping = true;
  #    scrollMethod = "twofinger";
  #    tapping = true;
  #  };
  #};

  services.displayManager = {
    #enable = true;

    #sddm = {
    #  enable = true;
    #  wayland.enable = true;
    #};

    defaultSession = "none+xmonad";
    #autoLogin = {};
  };

  services.desktopManager = {
    plasma6.enable = true;
  };

  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "dvorak";

    displayManager = {
      #gdm.enable = true;
      lightdm.enable = true;

      sessionCommands = ''
      xset -dpms
      xset s blank
      xset s 120
      '';
    };

    #desktopManager = {
    #  #mate.enable = true;
    #  gnome.enable = true;
    #  #xfce.enable = true;
    #};

    windowManager = {
      jwm.enable = true;
      icewm.enable = true;
      fluxbox.enable = true;
    };
  };

  nix.settings.max-jobs = 2;

  users.users.a = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable 'sudo' for the user.
    ];
  };

  #programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [

    # To install (globally, instead of per user) home-manager packages ('programs.home-manager.enable = true;' in home.nix for each user)
    #inputs.home-manager.packages.${pkgs.system}.default
    ##inputs.home-manager-unstable.packages.${pkgs.system}.default

    telegram-desktop # Telegram client
    zapzap whatsie karere # Whatsapp web client
    miro zathura sioyek meowpdf evince papers # PDF reader
    xterm sakura # terminal emulator
    dmenu rofi # menu

  ];

  system.stateVersion = "${stateVersion}";
}
