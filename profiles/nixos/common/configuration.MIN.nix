# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#nix-build '<nixpkgs/nixos>' -A config.system.build.toplevel -I nixos-config=/mnt/etc/nixos/configuration.nix
#nixos-install

{ config, pkgs, ... }:

{
	#boot.kernelParams = [ "nomodeset" "i915.modeset=0" ];
	#boot.kernelPackages = pkgs.linuxPackages_latest;

	boot.loader.grub.useOSProber = true;
	boot.loader.systemd-boot.enable = true;

	boot.supportedFilesystems = [ "ext4" "btrfs" ]; #"ext4" "zfs" "bcachefs" "xfs" ];
	boot.initrd.supportedFilesystems = [ "ext4" "btrfs" ];
	#boot.loader.grub.copyKernels = true; # zfs
	#services.zfs.autoScrub.enable = true; # zfs
	#hardware.enableAllFirmware = true;

	networking.networkmanager.enable = true;
  
	nix.daemonCPUSchedPolicy = "idle"; # nix.daemonNiceLevel = 19;
	nix.daemonIOSchedPriority = 7;     # nix.daemonIONiceLevel = 7;

	nix.trustedUsers = [ "root" "najib" ];

	# Select internationalisation properties.
	console.font = "Lat2-Terminus16";
	console.keyMap = "dvorak";
	i18n.defaultLocale = "en_US.UTF-8";

	# Set time zone.
	time.timeZone = "Asia/Kuala_Lumpur";
	time.hardwareClockInLocalTime = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix-env -qaP | grep wget
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gptfdisk efibootmgr
    btrfs-progs
    #bcachefs-tools
    wget curl
    mtr iproute # busybox
    tmux htop atop mc irssi most mosh coreutils xterm rxvt_unicode file bc lsof tree
    hardinfo
    nano micro neovim kakoune vis
    zip unzip
    lynx elinks w3m
    dmenu xorg.xhost xlockmore xclip pasystray
    #fish most
    xmlstarlet
    firefox
    dmidecode
    git #gitAndTools.gitFull gitAndTools.gitflow
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

  documentation.nixos.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  #networking.firewall.allowedTCPPorts = [ ... ];
  #networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

	#sound.enable = true;
	#hardware.pulseaudio.enable = true;
	#hardware.pulseaudio.systemWide = true;
	#hardware.pulseaudio.package = pkgs.pulseaudioFull;
	#hardware.pulseaudio.support32Bit = true;

	services.xserver.enable = true;
	#services.xserver.layout = "us";
	#services.xserver.xkbVariant = "dvorak";

	#services.xserver.libinput.enable = true;
	#services.xserver.libinput.scrollMethod = "edge";
	#services.xserver.libinput.tapping = false;
	#services.xserver.libinput.disableWhileTyping = true;

	#services.xserver.displayManager.sddm.enable = true;
	#services.xserver.desktopManager.plasma5.enable = true;
	#services.xserver.desktopManager.xfce.enable = true;
	#services.xserver.windowManager.jwm.enable = true;
	services.xserver.windowManager.fluxbox.enable = true;
	services.xserver.windowManager.awesome.enable = true;
	services.xserver.windowManager.xmonad = {
		enable = true;
		enableContribAndExtras = true;
		extraPackages = haskellPackages: [
				haskellPackages.xmonad
				haskellPackages.xmonad-extras
				haskellPackages.xmonad-contrib
			];
	};

	users.extraGroups.istana46.gid = 1001;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.najib = {
		description = "Muhammad Najib Bin Ibrahim";
		uid = 1001;
		isNormalUser = true;
		#initialPassword = "password";
		createHome = true;
		home = "/home/najib";
		extraGroups = [ "wheel" "networkmanager" "istana46" "audio" "video" "cdrom"  "adbusers" "vboxusers" "scanner" "lp" ];
	};

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  #system.stateVersion = "20.03";
  system.stateVersion = "20.09";
  #system.stateVersion = "21.05";

  fonts = {
    #enableFontDir = true;
    fontDir.enable = true;

    enableGhostscriptFonts = true;

    fonts = with pkgs; [
      #corefonts 		# microsoft fre fonts
      inconsolata 		# monospaced
      ubuntu_font_family 	# ubuntu fonts
      unifont 			# some international languages
    ];
  };

}
