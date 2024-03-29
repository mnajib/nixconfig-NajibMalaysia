{ config, pkgs, ... }:

{
    imports = [
        #./bootEFI.nix
        ./bootBIOS.nix
        ./thinkpad.nix
	#./touchpad-scrollTwofinger-TapTrue.nix
	#./touchpad-scrollEdge-TapTrue.nix
	./users-anak2.nix
	./nfs-client.nix
	./keyboard-with-msa.nix
	./audio-pipewire.nix
	#./synergy-client.nix
	./hardware-printer.nix
    ];

    # For the value of 'networking.hostID', use the following command:
    #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    #
    # Thinkpad R61 magnifix hadiah
    networking.hostId = "ec4da958";
    networking.hostName = "asmak";

    nix.trustedUsers = [ "root" "najib" "naqib" ];

    #services.xserver.libinput.tapping = pkgs.lib.mkForce true; # Will delete this line, do not need this anymore; instead I have put if-then-else for this in configuration.FULL.nix

    # Open ports in the firewall.
    #networking.firewall.allowedTCPPorts = [ ... ];
    #networking.firewall.allowedUDPPorts = [ ... ];
    #networking.firewall.allowedUDPPorts = [ 3450 ]; # 3450 for minetest server
    #
    # Or disable the firewall altogether.
    networking.firewall.enable = false;

    #boot.kernelParams = [ "nomodeset" ]; # Need this to run OBS.
    boot.kernelPackages = pkgs.linuxPackages_latest; # Need this to make graphical display work on asmak.
    #boot.kernelPackages = pkgs.linuxPackages_5_4;
    #boot.kernelPackages = pkgs.linuxPackages_4_19;

    boot.supportedFilesystems =        [ "ext4" "btrfs" "xfs" ]; # "zfs" "bcachefs"
    boot.initrd.supportedFilesystems = [ "ext4" "btrfs" "xfs" ]; # "zfs" "bcachefs"

    ## Pinning a kernel version
    #boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_5_4.override {
    #    argsOverride = rec {
    #        src = pkgs.fetchurl {
    #
    #           # Refer to
    #           #   https://www.kernel.org/
    #           #   https://nixos.wiki/wiki/Linux_kernel#Pinning_a_kernel_version
    #
    #           #url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.125.tar.xz";
    #           url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${version}.tar.xz";
    #
    #           #sha256 = "0ibayrvrnw2lw7si78vdqnr20mm1d3z0g6a0ykndvgn5vdax5x9a";
    #           sha256 = "0g73xfkmj4sahrk7gx72hm2i4m98gqghswqyf8yqh77b9857bvhp";
    #       };
    #
    #       version = "5.4.125";
    #       modDirVersion = "5.4.125";
    #   };
    #});

    services.xserver.synaptics.enable = false;
    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.disableWhileTyping = true;

    # Click Method
    services.xserver.libinput.touchpad.tapping = true;
    #service.xserver.libinput.clickMethod = "clickfinger";

    # Scroll Method
    #services.xserver.libinput.scrollMethod = "edge";
    #
    services.xserver.libinput.touchpad.scrollMethod = "twofinger";
    #
    #services.xserver.libinput.scrollMethod = "button";
    #services.xserver.libinput.scrollButton = 1;

    networking.networkmanager.wifi.powersave = false;
    systemd.watchdog.rebootTime = "10m";

    system.stateVersion = "22.05";
}
