# vim: set ts=4 sw=4 nowrap number:

{ pkgs, config, ... }:

{
	nix = {
		#package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
		extraOptions = ''
			experimental-features = nix-command flakes
		'';

	};

	imports = [
		./hardware-configuration-maryam.nix

		#./bootEFI.nix
		./bootBIOS.nix

		./thinkpad.nix

		#./network-dns.nix

		#./users-anak2.nix
		#./users-najib.nix
		./users-julia.nix
		./users-naqib.nix
		./users-nurnasuha.nix
		./users-naim.nix

		./nfs-client.nix

		./console-keyboard-dvorak.nix

		./keyboard-with-msa.nix
		#./keyboard-with-msa-keira.nix
		#./keyboard-without-msa.nix
		#./keyboard-us_and_dv.nix

		#./audio-pulseaudio.nix
		./audio-pipewire.nix

		./hardware-printer.nix
		./zramSwap.nix

		#./hardware-tablet-wacom.nix
		#./hardware-tablet-digimend.nix
		#./hardware-tablet-opentabletdriver.nix

		#./btrbk.nix

		./typesetting.nix

		./hosts2.nix
		./configuration.FULL.nix

		#./dnsmasq.nix # XXX: Experimental
	];

	# For the value of 'networking.hostID', use the following command:
	#     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
	#
	# t61
	networking.hostId = "35030584"; #"e13671e8"; #"ce145569";
	networking.hostName = "maryam";

	#boot.loader.grub.useOSProber = true; # move to bootBIOS.nix

	#boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.supportedFilesystems = 		[ "ext4" "btrfs" "xfs" "vfat" "ntfs" ];
	boot.initrd.supportedFilesystems = 	[ "ext4" "btrfs" "xfs" "vfat" "ntfs" ];

	#services.fstrim.enable = true;
	hardware.enableAllFirmware = true;

	nix.settings.trusted-users = [ "root" "najib" ];
	#security.sudo.extraRules = [
	#	users = [ "najib" ];
	#	#groups = [ "users" ];
	#	command = [
	#		{
	#			command = "";
	#			options = [];
	#		}
	#	];
	#];

	#
	#services.openssh.permitRootLogin = "prohibit-password";

	networking.firewall.enable = false;
	networking.networkmanager.wifi.powersave = false;

	services.acpid.enable = true;
	hardware.acpilight.enable = true;

	systemd.watchdog.rebootTime = "10m";

	#powerManagement.enable = true;
	#services.auto-cpufreq.enable = true;

	services.tlp.enable = true;
	services.tlp.settings = {
		START_CHARGE_THRESH_BAT0 = 75;
		STOP_CHARGE_THRESH_BAT0 = 80;

		WIFI_PWR_ON_AC = "off";
		WIFI_PWR_ON_BAT = "off";
		DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
		DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
	};
	#services.tlp.extraConfig = ...;

	hardware.trackpoint.enable = true;
	hardware.trackpoint.device = "TPPS/2 IBM TrackPoint";
	hardware.trackpoint.speed = 97;
	hardware.trackpoint.sensitivity = 130;
	hardware.trackpoint.emulateWheel = true;

	services.xserver.libinput.enable = true;
	services.xserver.libinput.touchpad.disableWhileTyping = true;
	#services.xserver.libinput.touchpad.scrollMethod = "twofinger";
	#services.xserver.libinput.touchpad.tapping = true;

	#services.xserver.displayManager.sddm.enable = true;
	services.xserver.displayManager.defaultSession = "none+xmonad";
	#services.xserver.desktopManager.plasma5.enable = true;
	#services.xserver.desktopManager.xfce.enable = true;
	#services.xserver.desktopManager.enlightenment.enable = true;

	services.xserver.windowManager.jwm.enable = true;
	services.xserver.windowManager.icewm.enable = true;
	services.xserver.windowManager.fluxbox.enable = true;
	#services.xserver.windowManager.qtile.enable = true;

	#nix.maxJobs = 4;

    system.stateVersion = "22.05";
}
