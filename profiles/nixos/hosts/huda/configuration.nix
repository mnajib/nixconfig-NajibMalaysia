{
  pkgs, config, lib, home,
  vars, host,
  inputs, outputs, # need for home-manager
  ...
}:
let

  commonDir = "../../common";
  hmDir = "../../../home-manager/users";

  hostName = "huda";            # Machine gw/firewall (Dell Inspiron 620s, with with multiple eth)
  hostId = "cfe5d01f";          # cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  stateVersion = "25.11";

   prismPkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
    # Replace <COMMIT_HASH> with a commit from late April 2025.
    # Example: Find a commit where pkgs.prismlauncher.version == "9.4"
    sha256 = "0m0xmk8sjb5gv2pq7s8w7qxf7qggqsd3rxzv3xrqkhfimy2x7bnx";    # Run 'nix-prefetch-url --unpack <url>' to get this
  }) { system = pkgs.system; };

in
{
    
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    ./hardware-configuration.nix
    (fromCommon "bootBIOS.nix")

    #./roles/base.nix
    #./roles/stage-1.nix
    #./roles/stage-2.nix\
    ./nvidia-quadro-k620.nix

    #(fromCommon "remote-builders.nix")
    (fromCommon "configuration.FULL.nix") # timezone, locale, ...

    (fromCommon "users-a-wheel.nix")
    (fromCommon "users-naqib-wheel.nix")
    #(fromCommon "users-naqib.nix")
    (fromCommon "users-naim.nix")
    (fromCommon "users-nurnasuha.nix")
    (fromCommon "users-julia-wheel.nix")
    inputs.home-manager.nixosModules.home-manager

    (fromCommon "console-keyboard-dvorak.nix")       # keyboard layout for console environment
    (fromCommon "keyboard-with-msa.nix")             # keyboard layout for graphical environment

    (fromCommon "zramSwap.nix")
    (fromCommon "audio-pipewire.nix")
    (fromCommon "hardware-printer.nix")
    (fromCommon "nix-garbage-collector.nix")

    (fromCommon "nfs-client-automount.nix")
    #(fromCommon "nfs-client.nix")

    #(fromCommon "opengl.nix")
    #(fromCommon "opengl2.nix")
    #(fromCommon "xdg-gtk.nix")
    #(fromCommon "xdg.nix")
    (fromCommon "window-managers.nix")
    (fromCommon "desktops.nix")
    #(fromCommon "desktops-xorg.nix")
    #(fromCommon "hyprland.nix")
    #(fromCommon "stylix.nix")

    (fromCommon "bluetooth.nix")
    #(fromCommon "packages/databases.nix")
    (fromCommon "flatpak.nix")
  ];

  #services.xserver = {
  #  enable = true;
  #  displayManager.lightdm.enable = true;
  #  desktopManager.lxqt.enable = true;
  #};

  home-manager = {
    backupFileExtension = "backup";
    #overwriteBackup = true;
    extraSpecialArgs = { inherit inputs outputs; }; # to pass arguments to home.nix
    users = {
      #root = import "${hmDir}/root/taufiq";
      #najib = import "${hmDir}/najib/taufiq";
      #root = import (./. + "/${hmDir}/root/taufiq");
      najib = import (./. + "/${hmDir}/najib/${hostName}");
      naqib = import (./. + "/${hmDir}/naqib/${hostName}");
    }; # End home-manager.users = { ... };
  }; # End home-manager = { ... };

  nix.settings.trusted-users = [ "root" "najib" "naqib" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  networking.hostName = "${hostName}";
  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  networking.hostId = "${hostId}";

  networking.useDHCP = false;
  #networking.interfaces.eno1.useDHCP = true;

  programs.nm-applet.enable = true;

  #--------------------------------------------------------
  networking.nftables.enable = true;    # 'nftable' is enable; 'iptables' if not.
  networking.firewall = {
    enable = true;                      #'false' is the default.

    #trustedInterfaces = [ "enp0s2" ];
    #interfaces = {};
    #interfaces."enp0s2".allowedTCPPorts = [];
    allowPing = true;                   #'true' is the default.
    #pingLimit = "2/second";
    #pingLimit = "1/minute burst 5 packets";
    allowedTCPPorts = [
      # 24007                            # gluster daemon
      # 24008                            # gluster management
      # 49152                            # gluster brick1
      # 49153                            # gluster brick2
      #{ from = 38465; to = 38467; }    # Gluster NFS
      # 111                              # portmapper
      1110                              # NFS cluster
      4045                              # NFS lock manager
    ];
    allowedUDPPorts = [
      # 111                              # Gluster: portmapper
      # 3450                             # for minetest server
      1110                              # NFS client
      4045                              # NFS lock manager
      #{ from = 4000; to = 4007; }
      #{ from = 8000; to = 8010; }
    ];
  };
  #--------------------------------------------------------

  environment.systemPackages = with pkgs; [
    nvtopPackages.full #nvtop
    cudatoolkit
    pciutils
    file
    gnumake
    gcc
    gparted
    fatresize
    #prismlauncher
    #flatpak
    #luanti
    (prismPkgs.prismlauncher.override {
      jdks = [ jdk25 jdk21 jdk17 jdk8 ]; # Include jdk25 and other versions you need
    })   
    #kate
    #kitty
    #blender
    freecad

    inputs.home-manager.packages.${pkgs.system}.default # To install (globally, instead of per user) home-manager packages
  ];

  services.fstrim.enable = true;
  services.flatpak.enable = true;  

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = [
  #  #"i915.modeset=0" "nouveau.modeset=1"                                        # to disable i915 and enable nouveau
  #  "video=eDP-1:1920x1080" "video=VGA-1:1280x1024" "video=DP-1-3:1280x1024"    #
  #];
  boot.kernelPackages = pkgs.linuxPackages_6_12; # Pinned to 6.12 because 6.13+ causes networking issues on HP Z420 hardware

  services.openssh = {
    enable = true;
    #settings = {
    #  PermitRootLogin = "yes";
    #};
  };

  services.logind.settings.Login = {
    RuntimeDirectorySize = "4G";
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  # echo 1 > /sys/module/processor/parameters/ignore_ppc

  systemd.watchdog.rebootTime = "10m";

  # High-DPI console
  #console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "${stateVersion}";
}
