{ pkgs, config, ... }:
#let
#	nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
#	  export __NV_PRIME_RENDER_OFFLOAD=1
#	  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
#	  export __GLX_VENDOR_LIBRARY_NAME=nvidia
#	  export __VK_LAYER_NV_optimus=NVIDIA_only
#	  exec -a "$0" "$@"
#	'';
#in
{
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };

  imports = [
    ./hardware-configuration-khadijah.nix
    ./configuration.FULL.nix
    #./hosts.nix
    ./hosts2.nix
    ./bootEFI.nix
    #./bootBIOS.nix
    #./thinkpad.nix
    #./touchpad-scrollTwofinger-TapTrue.nix
    #./network-dns.nix
    ./users-anak2.nix
    ./nfs-client.nix
    #./virtualbox.nix # compile fail
    #./libvirt.nix
    #./anbox.nix
    #./anbox2.nix
    ./waydroid.nix
    ./console-keyboard-dvorak.nix       # keyboard layout for console environment
    ./keyboard-with-msa.nix             # keyboard layout for graphical environment
    #./audio-pulseaudio.nix
    ./audio-pipewire.nix
    ./hardware-printer.nix
    #./hardware-tablet-wacom.nix
    #./veikk.nix
    ./zramSwap.nix
    #./btrbk-khadijah.nix #./btrbk-pull.nix
    ./sway.nix
  ];

  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  #

  # Dell Precision M4800
  networking.hostId = "b74534bf";
  networking.hostName = "khadijah";

  nix.settings.trusted-users = [ "root" "najib" ];

  networking.useDHCP = false;          # Disabled by Najib on 20220724T0740
                                       # Enabled by Najib on 2023-02-01T1245 in attemp to decrease delay on startup.
  #networking.interfaces.eno1.useDHCP = true;

  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [
    24007         # gluster daemon
    24008         # gluster management
    #49152        # gluster brick1
    49153         # gluster brick2
    #38465-38467  # Gluster NFS
    111           # portmapper
    1110          # NFS cluster
    4045          # NFS lock manager
  ];
  networking.firewall.allowedUDPPorts = [
    111           # Gluster: portmapper
    3450          # for minetest server
    1110          # NFS client
    4045          # NFS lock manager
  ];

  # XXX: ???
  environment.systemPackages = with pkgs; [
    nvtop
  ];

  #hardware.video.hidpi.enable = true;

  services.fstrim.enable = true;

  boot.loader.timeout = null; # XXX: Not sure how to set null value here.
  #boot.loader.systemd-boot.enable = true;      # for efi boot, not bios?
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable swap on luks
  boot.initrd.luks.devices."luks-a5172078-045e-4b03-abbc-32a86dfe0d06".device = "/dev/disk/by-uuid/a5172078-045e-4b03-abbc-32a86dfe0d06";
  boot.initrd.luks.devices."luks-a5172078-045e-4b03-abbc-32a86dfe0d06".keyFile = "/crypto_keyfile.bin";

  #services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  services.xserver.dpi = 96;

  services.xserver.videoDrivers = [ "nvidia" ];
  # OR
  # Selecting an nvidia driver has been modified for NixOS 19.03. The version is now set using `hardware.nvidia.package`.
  #services.xserver.videoDrivers = [ "nvidiaLegacy470" ]; #

  #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390; # Latest Legacy GPU version (390.xx series): 390.143
  #
  # OR
  #
  # https://www.nvidia.com/en-us/drivers/unix/legacy-gpu/
  # For GK106GLM [Quadro K2100M] in Dell Precision M4800
  # Legacy driver
  # 470.xx driver
  #   NVIDIA GPU product: Quadro K2100M
  #   Device PCI ID: 11FC
  #   Subdevice PCI ID: -
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

  hardware.nvidia.nvidiaSettings = true;

  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

  #hardware.nvidia.prime.offload.enable = true;
  #
  # OR
  #
  hardware.nvidia.prime.sync.enable = true;
  hardware.nvidia.modesetting.enable = true;

  #hardware.nvidia.prime = {
  # #offload.enable = true;
  # #sync.enable = true;
  # intelBusId = "PCI:0:2:0";
  # nvidiaBusId = "PCI:1:0:0";
  #    };

  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.startx.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true; # XXX
  #services.xserver.libinput.disableWhileTyping = true;
  #services.xserver.libinput.tapping = false; # Default is 'true'
  #services.xserver.libinput.scrollMethod = "twofinger";

  #    hardware.trackpoint = {
  #        enable = true;
  #        sensitivity = 100; # default 128
  #        speed = 96; # default 97
  #        emulateWheel = true;
  #        #fakeButtons=
  #        #device=
  #    };

  services.power-profiles-daemon.enable = false;
  #powerManagement.cpuFreqGovernor = "powersave";
  #powerManagement.enable = false; # Default is true;
  powerManagement.cpufreq.min = 2000000000; # 2000000; # 800000; # Default is 'null';
  powerManagement.cpufreq.max = 2600000000; # 2600000; # 3200000; # Default is null;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  services.tlp = {
    enable = true; # default is 'false'
    settings = {
      #TLP_PERSISTENT_DEFAULT=1;
      #TLP_DEFAULT_MODE="BAT";

      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_SCALING_GOVERNOR_ON_AC="powersave"; #"performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0=40;
      STOP_CHARGE_THRESH_BAT0=50;

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      #CPU_MAX_PERF_ON_AC=75;
      #CPU_MAX_PERF_ON_BAT=60;

      # CPU frequency
      CPU_SCALING_MIN_FREQ_ON_AC="2.0GHz"; # 2000000; # 800000;
      CPU_SCALING_MAX_FREQ_ON_AC="2.6GHz"; # 2600000; # 3200000;
      CPU_SCALING_MIN_FREQ_ON_BAT="2.0GHz"; # 2000000; #800000;
      CPU_SCALING_MAX_FREQ_ON_BAT="2.6GHz"; # 2600000; #3200000; #2300000;
    };
  };
  services.auto-cpufreq = {
    enable = true;
  };
  systemd.services."auto-cpufreq" = {
    after = [ "display-manager.service" ];
  };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  # echo 1 > /sys/module/processor/parameters/ignore_ppc

  systemd.watchdog.rebootTime = "10m";

  #nix.maxJobs = lib.mkDefault 4; #8;
  nix.settings.max-jobs = 4;
  #nix.daemonNiceLevel = 19; # 0 to 19, default 0
  #nix.daemonIONiceLevel = 7; # 0 to 7, default 0

  # XXX: High-DPI console
  #console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  virtualisation.virtualbox.host.enable = true;
}
