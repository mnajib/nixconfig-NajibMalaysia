# vim: set ts=4 sw=4 nowrap number:

{ pkgs, config, ... }:

{
	nix = {
		package = pkgs.nixFlakes;
		extraOptions = ''
			experimental-features = nix-command flakes
			'';
	};

    imports = [
		./hardware-configuration-aisyah.nix

        #./bootEFI.nix
        ./bootBIOS.nix

		./thinkpad.nix
		./touchpad-scrollTwofinger-TapTrue.nix

		./console-keyboard-dvorak.nix
        ./keyboard-with-msa.nix

		#./network-dns.nix
		./hosts2.nix

		#./users-anak2.nix
		./users-julia.nix
		./users-naqib.nix
		./users-nurnasuha.nix
		./users-naim.nix

		./nfs-client.nix

		./audio-pipewire.nix
		#./audio-pulseaudio.nix

		#./virtualbox.nix # compile fail
		#./libvirt.nix

        #./synergy-server.nix # use barrier

		./hardware-printer.nix

		./zramSwap.nix

        # Drawing tablet
        #./hardware-tablet-digimend.nix
        #./hardware-tablet-wacom.nix
        #./hardware-tablet-opentabletdriver.nix

		#./vpn-server.nix
		#./vpn-client.nix

		./typesetting.nix

		./configuration.FULL.nix
    ];

    # BIOS
    #boot.loader.grub = {
    #    enable = true;
    #    version = 2;
    #    device = "/dev/disk/by-id/ata-WDC_WD5000LPVX-08V0TT6_WD-WXG1AA5A4S78"; # "/dev/sda"; # "/dev/sdb"
    #};

    # For the value of 'networking.hostID', use the following command:
    #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    #

    # Thinkpad T430s (Farid dah tak pakai sebab asal tak boleh start)
    #networking.hostId = "b74533be"; # T430s ?
    networking.hostId = "f00315ac"; # T61/R61 ?
    networking.hostName = "aisyah"; # also called "tifoten"

    nix.settings.trusted-users = [ "root" "najib" "naqib" ];

    networking.firewall.enable = true;
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

    #boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" "vfat" "ntfs" ]; # "zfs" "bcachefs"
    boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" "vfat" "ntfs" ];

    #services.fstrim.enable = true;
    hardware.enableAllFirmware = true;

    services.acpid.enable = true; # XXX
    hardware.acpilight.enable = true; # This will allow brightness control via 'xbacklight' from users in the 'video' group.

    systemd.watchdog.rebootTime = "10m";

    powerManagement.enable = true;
    services.auto-cpufreq.enable = true;
	#
    services.tlp.enable = true;
	services.tlp.settings = {
		START_CHARGE_THRESH_BAT0 = 2; # 75;
		STOP_CHARGE_THRESH_BAT0 = 80;
		WIFI_PWR_ON_AC = "off";
		WIFI_PWR_ON_BAT = "off";
		DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
		DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
	};
	#services.tlp.extraConfig = ...;
    #
    networking.networkmanager.wifi.powersave = false;

    #services.xserver.displayManager.sddm.enable = true;
    #services.xserver.desktopManager.plasma5.enable = true;

    hardware.trackpoint.enable = true;
    # ...

    services.xserver.libinput.enable = true;
	# ...
}
