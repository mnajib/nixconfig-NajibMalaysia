# vim: set tabstop=4 shiftwidth=4 expandtab nowrap number:

{ config, pkgs, ... }:

{
    nix = {
        package = pkgs.nixFlakes;
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

        ./hosts2.nix
        #./network-dns.nix

        #./users-najib.nix
        ./users-julia-wheel.nix
        #./users-anak2.nix

        ./nfs-client.nix

        #./console-keyboard-dvorak.nix
        ./console-keyboard-us.nix
        #./keyboard-with-msa.nix
        ./keyboard-us_and_dv.nix

        #./audio-pulseaudio.nix
        ./audio-pipewire.nix

        ./hardware-printer.nix

        ./zramSwap.nix

        ./hardware-tablet-wacom.nix

        ./configuration.FULL.nix

        ./typesetting.nix
    ];

    # For the value of 'networking.hostID', use the following command:
    #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    #

    networking.hostId = "b7c4abba";
    networking.hostName = "manggis";

    nix.trustedUsers = [ "root" "najib" "julia" ];

    #boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];
    boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" ];

    hardware.enableAllFirmware = true;

    services.fstrim.enable = true;

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
        
        #3450 # for minetest server
        
        1110 # NFS client
        4045 # NFS lock manager
    ];

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

        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
        DEVICES_TO_DISABLE_ON_STARTUP = "bluetooth wwan";
        DEVICES_TO_ENABLE_ON_STARTUP = "wifi";
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

    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.disableWhileTyping = true;
    services.xserver.libinput.touchpad.scrollMethod = "twofinger";
    services.xserver.libinput.touchpad.tapping = true; #false;

    #services.xserver.displayManager.sddm.enable = true;
    services.xserver.displayManager.defaultSession = "none+xmonad";
    services.xserver.desktopManager.plasma5.enable = false;
    services.xserver.desktopManager.gnome.enable = false;
    services.xserver.desktopManager.xfce.enable = true;

    services.xserver.windowManager.jwm.enable = true;
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.windowManager.fluxbox.enable = true;

    system.stateVersion = "22.05";
}
