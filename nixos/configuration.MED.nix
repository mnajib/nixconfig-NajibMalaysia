# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #boot.loader.grub.device = "nodev";
  #boot.kernelParams = [ "nomodeset" "i915.modeset=0" ];  
  #boot.loader.efi.efiSysMountPoint = "/boot";
  #boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.systemd-boot.enable = true;
  boot.supportedFilesystems = [ "bcachefs" ];
  boot.initrd.supportedFilesystems = [ "bcachefs" ];

  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" ];
  nix.daemonIONiceLevel = 7;
  nix.daemonNiceLevel = 19;

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "dvorak";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Asia/Kuala_Lumpur";
  time.hardwareClockInLocalTime = true;

  nixpkgs.config = {
    allowUnfree = true;
    xsane = {
        libusb = true;
    };
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gptfdisk efibootmgr btrfs-progs bcachefs-tools
    wget curl
    mtr iproute # busybox
    tmux htop mc irssi most mosh coreutils 
    xterm # rxvt_unicode 
    file bc lsof tree 
    nano neovim kakoune
    zip unzip
    lynx elinks w3m
    dmidecode

    micro gitAndTools.gitFull xlockmore xorg.xhost xclip pulsemixer feh
    haskellPackages.xmobar rfkill
    mc atop wavemon mutt
    xmlstarlet
    xsane sane-backends sane-frontends hplip
    #efibootmgr
    bind gnupg
    rxvt_unicode-with-plugins st
    dmenu xorg.xmodmap pasystray
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  services.ntp = {
    enable = true;
    servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  };

  services.hdapsd.enable = true;

  services.openssh.enable = true;

  documentation.nixos.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.systemWide = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.cpu.intel.updateMicrocode = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "dvorak";

  services.xserver.libinput.enable = true;
  services.xserver.libinput.scrollMethod = "edge";
  services.xserver.libinput.tapping = false;
  #services.xserver.libinput.disableWhileTyping = true;

  # Fingerprint reader... fprintd-enroll
  #services.fprintd.enable = true;

  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.windowManager.jwm.enable = true;
  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.xmonad.enableContribAndExtras = true;
  services.xserver.windowManager.awesome.enable = true;

  users.extraGroups.istana46.gid = 1001;

  users.users.najib = {
    description = "Muhammad Najib Bin Ibrahim";
    uid = 1001;
    isNormalUser = true;
    #initialPassword = "najib123";
    createHome = true;
    home = "/home/najib";
    extraGroups = [ "wheel" "networkmanager" "istana46" "audio" "video" "cdrom"  "adbusers" "vboxusers" "scanner" "lp" "systemd-journal" ];
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
        corefonts
	inconsolata
	ubuntu_font_family
	unifont
    ];
  };
 
  system.stateVersion = "19.03";

}
