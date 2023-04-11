# vim: set ts=4 sw=4 nowrap autoindent noexpandtab number:

{ pkgs, config, ... }:

{
	nix = {
    		package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    		extraOptions = ''
      			experimental-features = nix-command flakes
    		'';
	};

	imports = [
		#<nixos-hardware/lenovo/thinkpad/t410> # XXX: temporarily disabled because lazy to add nix channel
		#./hardware-configuration-zahrah.nix
		./hardware-configuration-husna.nix
		./thinkpad.nix

		#./hosts.nix
		#./network-dns.nix
		./users-anak2.nix
		./nfs-client.nix

		./console-keyboard-dvorak.nix
		#./keyboard-with-msa.nix
		./keyboard-without-msa.nix

		#./audio-pulseaudio.nix
		./audio-pipewire.nix

		./hardware-printer.nix
		#./hardware-tablet-wacom.nix

		./zramSwap.nix

		#./configuration.MIN.nix
		#./configuration.FULL.nix
		./configuration.NOGUI.nix

		#./btrbk.nix
	];

	# For the value of 'networking.hostID', use the following command:
	#     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
	#

	nix.trustedUsers = [
		"root" "najib"
		#"julia"
		#"naim"
	];

	networking.hostId = "5dcfcacd";
	networking.hostName = "husna";

	#services.fstrim.enable = true;
	hardware.enableAllFirmware = true;

	#boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.kernelParams = [ "nomodeset" "pcie_port_pm=off" ];

	boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" "vfat" ];

	#boot.loader.systemd-boot.enable = true; # gummi-boot for EFI
	#boot.loader.efi.canTouchEfiVariables = true;
	boot.loader.grub = {
		enable = true;
		version = 2;
		enableCryptodisk = true;
		copyKernels = true;
		#useOSProber = true;
		#backgroundColor = "#7EBAE4"; # lightblue

		#------------------------------------------
		# BIOS
		#------------------------------------------
		#devices = [
		#	#"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
		#	#"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
		#	#"/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"
		#
		#	"/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159" # /dev/sda (120GB SSD)
		#	#"/dev/disk/by-id/ata-LITEONIT_LCS-256M6S_2.5_7mm_256GB_TW0XFJWX550854255987" # /dev/sdb (256GB SSD)
		#];
		device = "/dev/disk/by-id/ata-PH6-CE120-G_511190117056007159";
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

	services.fstrim.enable = true;

	#networking.useDHCP = false;
	#networking.interfaces.enp0s25.useDHCP = true;
	#networking.interfaces.wlp3s0.useDHCP = true;

	networking.firewall.enable = false;
	networking.firewall.allowedTCPPorts = [
		# Gluster
		24007 # gluster daemon
		24008 # management
		#49152 # brick1
		49153 # brick2
		#38465-38467 # Gluster NFS

		111 # portmapper

		1110 # NFS cluster
		4045    # NFS lock manager
	];
	networking.firewall.allowedUDPPorts = [
		# Gluster
		111 # portmapper

		3450 # for minetest server

		1110 # NFS client
		4045 # NFS lock manager
	];

	powerManagement.enable = true;
	#services.auto-cpufreq.enable = true;

	services.tlp = {
		enable = true;
		settings = {
			START_CHARGE_THRESH_BAT0 = 75;
			STOP_CHARGE_THRESH_BAT0 = 80;

			WIFI_PWR_ON_AC = "off";
			WIFI_PWR_ON_BAT = "off";
			DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
			#DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
		};
	};

	#networking.networkmanager.enable = true;
	networking.networkmanager.wifi.powersave = false;
	systemd.watchdog.rebootTime = "10m";
	services.acpid.enable = true;
	hardware.acpilight.enable = true;

	hardware.trackpoint = {
		enable = true;
		device = "TPPS/2 IBM TrackPoint";
		speed = 97;
		sensitivity = 130;
		emulateWheel = true;
	};

	# Custom script to decrease trackpoint sensitivity
	#...

	services.xserver.libinput.enable = true;
	services.xserver.libinput.touchpad.disableWhileTyping = true;
	services.xserver.libinput.touchpad.scrollMethod = "twofinger";
	services.xserver.libinput.touchpad.tapping = true; #false;

	#services.xserver.displayManager.sddm.enable = true;
	#services.xserver.displayManager.defaultSession = "none+xmonad";
	#services.xserver.desktopManager.plasma5.enable = true;
	#services.xserver.desktopManager.gnome.enable = true;
	#services.xserver.desktopManager.xfce.enable = true;

	services.xserver.windowManager.xmonad.enable = true;
	services.xserver.windowManager.qtile.enable = true;
	services.xserver.windowManager.awesowewm.enable = true;
	services.xserver.windowManager.jwm.enable = true;

	#nix.maxJobs = 4;

	system.stateVersion = "22.05";
}
