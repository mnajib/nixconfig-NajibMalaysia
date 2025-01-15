# vim: set ts=2 sw=2 expandtab nowrap number:

{ pkgs, config, lib, ... }:
{
  nix = {
    #package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      max-jobs = 2;
      trusted-users = [ "root" "najib" "naim" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    #allowBroken = true;
    #cudaSupport = true;
  };

  imports = [
    ./hardware-configuration-zahrah.nix
    #./hardware-laptopLenovoThinkpadT410eWasteCyberjaya.nix
    #./hardware-storageSSD001.nix
    ./thinkpad.nix

    #./hosts2.nix
    #./network-dns.nix

    #./users-anak2.nix
    #./users-najib.nix
    ./users-julia.nix
    ./users-naqib.nix
    ./users-nurnasuha.nix
    ./users-naim-wheel.nix

    #./nfs-client.nix
    ./nfs-client-automount.nix

    ./console-keyboard-dvorak.nix
    #./keyboard-with-msa.nix
    ./keyboard-kmonad.nix
    ##./keyboard-without-msa.nix

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    ./hardware-printer.nix
    ./hardware-tablet-wacom.nix

    ./zramSwap.nix

    #./configuration.MIN.nix
    ./configuration.FULL.nix

    #./btrbk.nix

    ./typesetting.nix

    ./nix-garbage-collector.nix

    ./flatpak.nix
    #./emulationstation.nix # freeimage no safe?
    ./mame.nix

    #./ai.nix

    ./inspircd.nix # IRC server
    ./xdg.nix
    ./xmonad.nix

    ./opengl.nix
    #./opengl_with_vaapiIntel.nix

    ./stylix.nix

    ./barrier.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  networking.hostId = "4dcfcacd";
  networking.hostName = "zahrah"; # also called "tifoten"

  hardware.enableAllFirmware = true;

  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

  environment.systemPackages = with pkgs; [
    radeontop # T400 zahrah have GPU: AMD ATI Mobility Radeon HD 3450/3470 (RV620/M83). May need to choose 'discrete graphic' in BIOS.
    clinfo
    gpu-viewer
    vulkan-tools

    libnotify

    # Haskell Tools
    stack
    cabal-install
    haskellPackages.xmobar
    haskellPackages.X11
    haskellPackages.X11-xft
  ];

  #services.xserver.videoDrivers = [ "radeon" ];

  ## To enable hardware accelerated graphics drivers, to allow most graphical applications and environments to use hardware rendering, video encode/decode acceleration, etc. 
  ## This option should be enabled by default by the corresponding modules, so you do not usually have to set it yourself.
  #hardware.graphics.enable = true;

  #boot.loader.systemd-boot.enable = true; # gummi-boot for EFI
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 10; # in second(s)
  boot.loader.grub = {
    enable = true;
    #version = 2;
    enableCryptodisk = true;
    copyKernels = true;
    #useOSProber = true;
    #backgroundColor = "#7EBAE4"; # lightblue

    #------------------------------------------
    # BIOS
    #------------------------------------------
    devices = [
      #"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
      #"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
      #"/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"
      #"/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159"                                # /dev/sda (120GB SSD)
      #"/dev/disk/by-id/ata-LITEONIT_LCS-256M6S_2.5_7mm_256GB_TW0XFJWX550854255987"       # /dev/sdb (256GB SSD)
      "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011006"
    ];
    #device = "/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159";
    #device = "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK1011006";
    #efiSupport = true;

    #------------------------------------------
    # EFI
    #------------------------------------------
    #device = "nodev";
    #efiSupport = true;
    #mirroredBoots = [
    #    {
    #        devices = [ "/dev/disk/by-id/wwn-0x5000c5002ec8a164" ]; # /dev/sdb1
    #        path = "/boot2";
    #    }
    #];
  };


  boot.kernelParams = [
    "radeon.modeset=1" # enable radeon
  ];

  services.fstrim.enable = true;

  #networking.useDHCP = false;
  #networking.interfaces.enp0s25.useDHCP = true;
  #networking.interfaces.wlp3s0.useDHCP = true;

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

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

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

  services.xserver.displayManager = {
    lightdm.enable = true;
    #sddm = {
    #  enable = true;
    #  wayland.enable = false;
    #};
    #gdm = {
    #  enable = true;
    #  wayland = false;
    #};
    #startx.enable = true;
  };

  services.xserver.desktopManager = {
    #plasma5.enable = true;
    #plasma6.enable = true;
    gnome.enable = true;
    #xfce.enable = true;
    #pantheon.enable = true;
    #enlightenment.enable = true;
    #lumina.enable = true;
    #mate.enable = true;
    #cinnamon.enable = true;
    #lxqt.enable = true;
    #lomiri.enable = true;
  };

  services.xserver.windowManager = {
    #xmonad = {
    #  enable = true;
    #  enableContribAndExtras = true;
    #  extraPackages = haskellPackages: [
    #    haskellPackages.xmonad
    #    haskellPackages.xmonad-extras
    #    haskellPackages.xmonad-contrib
    #    haskellPackages.dbus
    #    haskellPackages.List
    #    haskellPackages.monad-logger
    #    haskellPackages.xmobar
    #  ];
    #};
    awesome = {
      enable = true;
    };
    berry.enable = true;
    notion.enable = true;
    pekwm.enable = true;
    #qtile.enable = true;
    ratpoison.enable = true;
    tinywm.enable = true;
    smallwm.enable = true;
    yeahwm.enable = true;
    mlvwm.enable = true;
    leftwm.enable = true;
    icewm.enable = true;
    i3.enable = true;
    fvwm3.enable = true;
    bspwm.enable = true;
    openbox.enable = true;
    #mwm.enable = true;
    #lwm.enable = true;
    jwm.enable = true;
    fluxbox.enable = true;
    windowmaker.enable = true;
    twm.enable = true;
    spectrwm.enable = true;
    wmderland.enable = true;
    herbstluftwm.enable = true;

    #hypr.enable = true;

    clfswm.enable = true;
    #stumpwm.enable = true;
    sawfish.enable = true;
    #exwm.enable = true;

    "2bwm".enable = true;
  };

  programs = {
    sway.enable = true;
    xwayland.enable = true;

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


  system.stateVersion = "22.05";
}
