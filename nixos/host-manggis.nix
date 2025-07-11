# vim: set tabstop=2 shiftwidth=2 expandtab nowrap number:

{ config, pkgs, ... }:

{
  nix = {
    #package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-manggis.nix

    #./bootEFI.nix
    ./bootBIOS.nix

    ./thinkpad.nix
    #./touchpad-scrollTwofinger-TapTrue.nix

    #./hosts2.nix
    #./network-dns.nix

    #./users-najib.nix
    ./users-julia-wheel.nix
    #./users-anak2.nix

    ./samba-client.nix
    ./nfs-client.nix
    ./flatpak.nix

    # Keyboard for console:
    #./console-keyboard-dvorak.nix
    ./console-keyboard-us.nix
    #
    # Keyboard for xorg:
    #./keyboard-us_and_dv.nix
    #./keyboard-with-msa.nix
    ./keyboard-with-msa-keira.nix

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    ./hardware-printer.nix

    ./zramSwap.nix

    ./hardware-tablet-wacom.nix

    ./configuration.FULL.nix

    ./typesetting.nix
    ./jupyter.nix

    ./nix-garbage-collector.nix
    ./teamviewer.nix

    ./lutris.nix

    ./xdg.nix
    ./opengl.nix
  ];

  environment.systemPackages = with pkgs; [
    #blender
    obs-studio
    #steam
    #steam-run
    lightlocker
  ];

  #programs.steam.enable = true;

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #

  networking.hostId = "b7c4abba";
  networking.hostName = "manggis";

  #nix.trustedUsers = [ "root" "najib" "julia" ];
  nix.settings.trusted-users = [ "root" "najib" "julia" ];

  boot.loader.timeout = 10;   # wait for 10 seconds
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];
  boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];

  hardware.enableAllFirmware = true;

  services.fstrim.enable = true;

  #--------------------------------------
  networking.nftables.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [
    # Gluster
    #24007 # gluster daemon
    #24008 # management
    ##49152 # brick1
    #49153 # brick2
    ##38465-38467 # Gluster NFS

    #111 # portmapper

    1110 # NFS cluster
    4045    # NFS lock manager
  ];
  networking.firewall.allowedUDPPorts = [
    # Gluster
    #111 # portmapper

    #3450 # for minetest server

    1110 # NFS client
    4045 # NFS lock manager
  ];
  #--------------------------------------

  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";

  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  services.power-profiles-daemon.enable = false;

  services.tlp.enable = true;
  services.tlp.settings = {
    #SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
    #USB_BLACKLIST_PHONE = 1;
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;

    # Power saving mode for wifi while on AC power
    WIFI_PWR_ON_AC = "off";
    # Power saving mode for wifi while on BAT power
    WIFI_PWR_ON_BAT = "off";

    #DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
    DEVICES_TO_ENABLE_ON_STARTUP = "wifi";

    #DEVICES_TO_DISABLE_ON_AC = "bluetooth wwan";
    DEVICES_TO_ENABLE_ON_AC = "wifi";

    #DEVICES_TO_DISABLE_ON_BAT = "bluetooth wwan";
    DEVICES_TO_ENABLE_ON_BAT = "wifi";

    #DEVICES_TO_DISABLE_ON_WIFI_CONNECT="bluetooth wwan";
    DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT="";
  };
  #services.tlp.extraConfig = ;

  hardware.trackpoint.enable = true;
  hardware.trackpoint.device = "TPPS/2 IBM TrackPoint";
  hardware.trackpoint.speed = 97;
  hardware.trackpoint.sensitivity = 130; #128;
  hardware.trackpoint.emulateWheel = true;

  security.sudo.extraRules = [
    {
      users = [ "najib" "julia" ];
      groups = [ "users" ];
      commands = [
        {
          command = "/home/julia/bin/decrease-trackpoint-sensitivity-x220.sh";
          options = [ "SETENV" "NOPASSWD" ];
        }
      ];
    }
  ];

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    touchpad.scrollMethod = "twofinger";
    touchpad.tapping = true; #false;
  };

  services.displayManager = {
    #enable = false;
    defaultSession = "none+xmonad";
    #sddm.enable = true;
  };

  services.xserver = {
    enable = true;
    #dpi = 96;

    # services.xserver.displayManager
    displayManager = {
      defaultSession = "none+xmonad";

      lightdm = {
        enable = true;
        #background = "";
        greeters = {
          gtk.enable = false;
          slick.enable = true;
          mini.enable = false;
          tiny.enable = false;
          enso.enable = false;
          lomiri.enable = false;
        };
      };

      gdm = {
        enable = false;
        wayland = false;
        autoSuspend = false;
      };

      #sddm = {
      #  enable = false;
      #};

      sessionCommands = ''
      xset -dpms                      # Disable Energy Star, as we are going to suspend anyway and it may hide "success" on that
      xset s blank                    # `noblank` may be useful for debugging
      xset s 120                      # in seconds
      #xset s 300                     # in seconds
      #${pkgs.lightlocker}/bin/light-locker --idle-hint &
      '';

      #sddm.enable = true;

    }; # End services.xserver.displayManager

    # services.xserver.displayManager.desktopManager
    desktopManager = {
      plasma5.enable = false;
      gnome.enable = false;
      #xfce.enable = true;
      #mate.enable = true;
    };

    # services.xserver.displayManager.windowManager
    windowManager = {
      awesome.enable = true;
      jwm.enable = true;
      icewm.enable = true;
      fluxbox.enable = true;
      xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages = haskellPackages: [
          haskellPackages.xmonad
          haskellPackages.xmonad-extras
          haskellPackages.xmonad-contrib
          haskellPackages.dbus
          haskellPackages.List
          haskellPackages.monad-logger
          haskellPackages.xmobar
        ];
      };
    }; # End services.xserver.displayManager.windowManager

  }; # End services.xserver

  system.stateVersion = "22.05";
}
