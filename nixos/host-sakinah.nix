{ config, pkgs, ... }:
{
  nix = {
    #package = lib.mkForce pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    #settings.experimental-features = "nix-command flakes";
  };

  imports = [
    ./hardware-configuration-sakinah.nix
    ./bootEFI.nix
    #./bootBIOS.nix
    ./thinkpad.nix
    #<nixos-hardware/lenovo/thinkpad/x220>
    ./touchpad-scrollTwofinger-TapTrue.nix

    #./users-anak2.nix
    ./users-nurnasuha-wheel.nix
    ./users-naqib-wheel.nix
    ./users-naim.nix
    ./users-julia-wheel.nix

    #inputs.home-manager.nixosModules.default # Home Manager module

    #./hosts.nix
    #./hosts2.nix

    #./nfs-client.nix
    ./nfs-client-automount.nix
    #./nfs-client.nix

    ./console-keyboard-dvorak.nix
    ./keyboard-with-msa.nix

    ./audio-pipewire.nix
    #./audio-pulseaudio.nix

    #./synergy-client.nix
    ./hardware-printer.nix
    ./hardware-tablet-wacom.nix
    ./zramSwap.nix
    ./configuration.FULL.nix
    #./btrbk.nix
    ./zfs.nix
    ./timetracker.nix

    ./3D.nix

    # Games
    ./openra.nix
  ];

  # Booting
  boot.loader = {
    timeout = 100;                     #null;
    grub = {
      useOSProber = true;
      timeoutStyle = "menu";

      #gfsmodeEfi = "1566x768";
      #gfsmodeBios = "1024x768";
      memtest86.enable = true;
    };
  };

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #
  # Thinkpad T400 kepong
  networking.hostId = "6a063836";
  networking.hostName = "sakinah";

  nix.settings.trusted-users = [ "root" "najib" "nurnasuha" ];

  hardware.enableAllFirmware = true;

  # XXX:
  networking.useDHCP = false;
  #networking.interface.enp0s25.useDHCP = true;
  #networking.interface.wlp3s0.useDHCP = true;
  #networking.interface.wwp0s29u1u4i6.useDHCP = true;
  #networking.interface.wlp0s29u1u2.useDHCP = true;
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # XXX: Move this configuration to per-host
  #powerManagement.enable = true;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  #services.tlp.enable = true;
  networking.networkmanager.wifi.powersave = false;
  systemd.watchdog.rebootTime = "10m";
  services.acpid.enable = true;
  hardware.acpilight.enable = true;

  networking.firewall.enable = true;

  hardware.trackpoint = {
    enable = true;
    device = "TPPS/2 IBM TrackPoint";
    speed = 97;
    sensitivity = 130;
    emulateWheel = true;
  };

  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+xmonad";
  services.xserver = {
    enable = true;
    #displayManager.gdm.enable = true;
    displayManager.lightdm.enable = true;
    #desktopManager.xfce.enable = true;
    desktopManager.mate.enable = true;
    #desktopManager.gnome.enable = true;
  };

  nix.settings.max-jobs = 2;

  #environment.systemPackages = [
    #pkgs.blender
    #pkgs.sweethome3d.application
    #pkgs.sweethome3d.textures-editor
    #pkgs.sweethome3d.furniture-editor
  #];

  # Home Manager configuration
  #home-manager = {
  #  extraSpecialArgs = { inherit inputs; };
  #  users = {
  #    "najib" = import ./home.nix;
  #  };
  #};

  system.stateVersion = "23.11";
}
