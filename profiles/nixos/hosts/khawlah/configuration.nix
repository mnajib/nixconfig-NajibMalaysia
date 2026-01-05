# vim: set ts=2 sw=2 expandtab nowrap number:

{
  pkgs, config,
  lib,
  inputs, outputs,
  modulesPath,
  # host, home, vars,
  ...
}:
let
  hostName = "khawlah";
  hostId = "33df86ff";
  commonDir = "../../common";
  hmDir = "../../../home-manager/users";
  stateVersion = "25.05";
in
{
  nix = {
    #package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      max-jobs = lib.mkDefault 2;
      trusted-users = [
        "root" "najib"
        "naqib"
        #"a" "abdullah"
      ];
    };
  };

  #nixpkgs.config = {
  #  allowUnfree = true;
  #  #allowBroken = true;
  #  #cudaSupport = true;
  #};

  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager

    (fromCommon "remote-builders.nix")

    (fromCommon "thinkpad.nix")

    #./users-anak2.nix
    (fromCommon "users-a-wheel.nix")
    #(fromCommon "users-abdullah-wheel.nix")
    (fromCommon "users-najib.nix")
    (fromCommon "users-julia.nix")
    (fromCommon "users-naqib-wheel.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-naim.nix")

    (fromCommon "console-keyboard-dvorak.nix")
    (fromCommon "keyboard-with-msa.nix")
    #(fromCommon "keyboard-kmonad.nix")

    (fromCommon "audio-pipewire.nix")
    (fromCommon "hardware-printer.nix")
    (fromCommon "zramSwap.nix")
    (fromCommon "configuration.FULL.nix")
    (fromCommon "nix-garbage-collector.nix")
    (fromCommon "flatpak.nix")
    #(fromCommon "opengl.nix")
    #(fromCommon "xdg.nix")

    (fromCommon "window-managers.nix")
    #(fromCommon "xmonad.nix")
    #./gpu-config.nix
    #./radeon-legacy.nix

    ./desktops.nix
    #(fromCommon "desktops.nix")

    #(fromCommon "nfs-client.nix")
    (fromCommon "nfs-client-automount.nix")

    #(fromCommon "mame.nix")
    #./ai.nix
    (fromCommon "hardware-tablet-wacom.nix")
    #./inspircd.nix # IRC server
    #./opengl_with_vaapiIntel.nix
    #./stylix.nix
    #./barrier.nix

    (fromCommon "bluetooth.nix")
  ];

  home-manager = let
    userImport = user: import ( ./. + "/${hmDir}/${user}/${hostName}" );
  in {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      # Import your home-manager configuration
      #najib = import ../home-manager/user-najib;
      #root = import ../home-manager/user-root;
      #
      #najib = import (./. + "/${hmDir}/najib/zahrah");
      #root = import (./. + "/${hmDir}/root/zahrah");
      #
      root = userImport "root";
      najib = userImport "najib";
      naqib = userImport "naqib";
    };
  };

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  #networking.hostId = "33df86ff";
  #networking.hostName = "khawlah"; # x230
  networking.hostId = "${hostId}";
  networking.hostName = "${hostName}";

  users.users.root = {
    initialPassword = "root123";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINiCR5IGdvop8gCL/wdEIoZsKzLJU1jiPPhjA1UbDVrt najib@sumayah"
    ];
  };

  hardware.enableAllFirmware = true;

  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

  environment.systemPackages = with pkgs; [
    radeontop # T400 zahrah have GPU: AMD ATI Mobility Radeon HD 3450/3470 (RV620/M83). May need to choose 'discrete graphic' in BIOS.
    clinfo
    gpu-viewer
    vulkan-tools

    gnome-randr
    foot

    libnotify

    # Haskell Tools
    stack
    cabal-install
    haskellPackages.xmobar
    haskellPackages.X11
    haskellPackages.X11-xft

    inputs.home-manager.packages.${pkgs.system}.default

    wofi
  ];

  #services.xserver.videoDrivers = [ "radeon" ];

  services.flatpak.enable = true;

  ## To enable hardware accelerated graphics drivers, to allow most graphical applications and environments to use hardware rendering, video encode/decode acceleration, etc.
  ## This option should be enabled by default by the corresponding modules, so you do not usually have to set it yourself.
  #hardware.graphics.enable = true;

  boot.kernelParams = [
    #"radeon.modeset=1" # enable radeon

    "video=LVDS-1:d" # disable
    "video=VGA-1:e"  # enable
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

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
    #  zfs rollback -r MyStation/local/root@blank
    #'';
  };

  boot.supportedFilesystems = [
    "ext4" "btrfs" "xfs" "vfat"
    "zfs"
    #"bcachefs"
    "ntfs"
    "dm-crypt" "dm-snapshot" "dm-raid"
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  services.fstrim.enable = true;
  services.smartd.enable = true;

  #services.udev.packages = [
  #  pkgs.android-udev-rules
  #];

  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true; # Was enabled (true) on khawlah, ?
  #networking.interfaces.wlp3s0.useDHCP = true; # Was enabled (true) on khawlah before, ?

  networking.nftables.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [
    # Gluster
    24007         # gluster daemon
    24008         # management
    #49152        # brick1
    49153         # brick2
    #38465-38467  # Gluster NFS
    111           # portmapper
    1110          # NFS cluster
    4045          # NFS lock manager
  ];
  networking.firewall.allowedUDPPorts = [
    # Gluster
    111           # portmapper
    3450          # for minetest server
    1110          # NFS client
    4045          # NFS lock manager
  ];

  # LACT
  #systemd.packages = with pkgs; [
  #  lact
  #];
  #systemd.services.lactd.wantedBy = [ "multi-user.target" ];

  powerManagement.enable = true;
  services.auto-cpufreq.enable = true;
  systemd.services."auto-cpufreq" = {
    after = [
      "display-manager.service"
    ];
  };
  powerManagement.cpuFreqGovernor = "powersave";
  #powerManagement.cpufreq.min =  800000;
  powerManagement.cpufreq.max = 1500000;

  services.power-profiles-daemon.enable = false;

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "off";
      DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
      DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  services.acpid.enable = false; #true;
  hardware.acpilight.enable = false; #true;

  services.thinkfan.enable = true;
  services.thinkfan.levels = [
    [
      0
      0
      55
    ]
    [
      "level auto"
      48
      60
    ]
    [
      "level auto"
      50
      61
    ]
    [
      6
      52
      63
    ]
    [
      7
      56
      65
    ]
    [
      "level full-speed"
      60
      85
    ]
    [
      "level full-speed"
      80
      32767
    ]
  ];

  #hardware.trackpoint = {
  #  enable = true;
  #  device = "TPPS/2 IBM TrackPoint";
  #  speed = 97;
  #  sensitivity = 130;
  #  emulateWheel = true;
  #};

  # Custom script to decrease trackpoint sensitivity
  #...

  #services.libinput.enable = true;
  #services.libinput.touchpad = {
  #  disableWhileTyping = true;
  #  scrollMethod = "twofinger";
  #  tapping = true; #false;
  #};

  services.displayManager.defaultSession = "none+xmonad";

  services.xserver.enable = true;

  #services.xserver.displayManager = {
  #  lightdm.enable = true;
  #};

  #services.xserver.desktopManager = {
  #  #gnome.enable = true;
  #  #lxqt.enable = true;
  #};

  #
  # XXX: if using gdm; do not enable too many desktop/wm, gdm cannot scroll a long list for user to choose
  #
  services.xserver.windowManager = {
    awesome = {
      enable = true;
    };
    berry.enable = true;
    notion.enable = true;
    #pekwm.enable = true;
    #qtile.enable = true;
    #ratpoison.enable = true;
    #tinywm.enable = true;
    #smallwm.enable = true;
    #yeahwm.enable = true;
    #mlvwm.enable = true;
    #leftwm.enable = true;
    icewm.enable = true;
    #i3.enable = true;
    #fvwm3.enable = true;
    #bspwm.enable = true;
    #openbox.enable = true;
    #mwm.enable = true;
    #lwm.enable = true;
    jwm.enable = true;
    fluxbox.enable = true;
    #windowmaker.enable = true;
    #twm.enable = true;
    #spectrwm.enable = true;
    wmderland.enable = true;
    #herbstluftwm.enable = true;

    #hypr.enable = true;

    #clfswm.enable = true;
    #stumpwm.enable = true;
    #sawfish.enable = true;
    #exwm.enable = true;

    #"2bwm".enable = true;
  };

  programs = {
    sway.enable = true;
    xwayland.enable = lib.mkDefault true;
    river.enable = true;

    firefox.enable = false;

    starship = {
      enable = false;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };

    dconf.enable = true;
    #seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    virt-manager.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

  };

  system.stateVersion = "${stateVersion}";
}
