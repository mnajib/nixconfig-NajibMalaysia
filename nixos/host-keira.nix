# vim: ts=4 sw=4 nowrap number:

{
	pkgs, 
	#sources ? import ./nix/sources.nix,
	#pkgs ? import sources.nixpkgs {},

	config,
	
	... 
}:

{
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
            experimental-features = nix-command flakes
        '';
    };

    imports = [
		#./bootEFI.nix
		#./bootBIOS.nix

		./thinkpad.nix
		#./touchpad-scrollTwofinger-TapTrue.nix

		#./hardware-configuration.nix
		./hardware-configuration-keira.nix
		#./hardware-laptopLenovoThinkpadT410eWasteCyberjaya.nix
		#./hardware-storage-keira-SSD001.nix
		#./hardware-storage-keira-SSD002.nix

		#./hosts.nix
		./hosts2.nix
		#./network-dns.nix
	
		#./users-najib.nix
		./users-julia.nix
		./users-anak2.nix

		./nfs-client.nix

		./console-keyboard-us.nix

		#./keyboard-with-msa.nix
		./keyboard-with-msa-keira.nix
		#./keyboard-without-msa.nix
		#./keyboard-us_and_dv.nix

		#./audio-pulseaudio.nix
		./audio-pipewire.nix

		#./synergy-client.nix # <-- replace with barrier

		./hardware-printer.nix

		./hardware-tablet-wacom.nix
		#./hardware-tablet-digimend.nix
		#./hardware-tablet-opentabletdriver.nix

		./zramSwap.nix

		#./configuration.MIN.nix
		./configuration.FULL.nix

		./btrbk-keira.nix
    ];


    # For Thinkpad T410
    #imports = [
    #    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/lenovo/thinkpad/t410"
    #];

    nix.trustedUsers = [
    	"root" "najib"
		"julia"
    ];

    # For the value of 'networking.hostID', use the following command:
    #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    #

    # Thinkpad T410 Shah Alam RM100 (price include T60)
    networking.hostId = "b74500be";
    networking.hostName = "keira"; # also called "tifoten"

    hardware.enableAllFirmware = true;

    #boot.kernelPackages = pkgs.linuxKernel.packages.latest;

    #boot.loader.systemd-boot.enable = true;
    #boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
        enable = true;
        version = 2;
        enableCryptodisk = true;
        copyKernels = true;
        #useOSProber = true; # XXX:
        #backgroundColor = "#7EBAE4"; # lightblue

        #------------------------------------------
        # BIOS
        #------------------------------------------
        devices = [
            #"/dev/disk/by-id/wwn-0x5000c5002ea341bc"
            #"/dev/disk/by-id/wwn-0x5000c5002ec8a164"
            "/dev/disk/by-id/ata-AGI256G06AI138_AGISAMUWK0803806"
        ];
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

    networking.useDHCP = false;
    #networking.interface.eno1.useDHCP = true;

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

	# XXX:
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

    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.disableWhileTyping = true;
    services.xserver.libinput.touchpad.scrollMethod = "twofinger";
    services.xserver.libinput.touchpad.tapping = true; #false;

    #services.xserver.displayManager.sddm.enable = true;
    #services.xserver.displayManager.defaultSession = "none+xmonad";
    #services.xserver.desktopManager.plasma5.enable = true;

    #nix.maxJobs = 4;
}
