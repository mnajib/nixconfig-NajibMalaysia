{
  pkgs, config, lib, home,
  vars, host,
  ...
}:
#let
#  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
#    export __NV_PRIME_RENDER_OFFLOAD=1
#    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
#    export __GLX_VENDOR_LIBRARY_NAME=nvidia
#    export __VK_LAYER_NV_optimus=NVIDIA_only
#    exec -a "$0" "$@"
#  '';
#in
with lib;
#with host;
{
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
        experimental-features = nix-command flakes
    '';

    #bash-prompt-prefix = "";
    #bash-prompt = "[develop] ";
    #bash-prompt-suffix = "[develop-env] ";

    #
    # References:
    #   https://nixos.wiki/wiki/Distributed_build
    #   https://search.nixos.org/options?channel=unstable&show=nix.buildMachines
    #   https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-use-xdg-base-directories
    #
    #distributedBuilds = true;
    #builders = "ssh://sakinah x86_64-linux; ssh://customdesktop x86_64-linux;";
    #builders = "ssh://nurnasuha@sakinah.localdomain x86_64-linux";
    #buildMachines = [
    #  {
    #    hostName = "sakinah.localdomain";
    #    protocol = "ssh"; # "ssh-ng"
    #    system = "x86_64-linux";
    #    #maxJobs = 1;
    #    #speedFactor = 2;
    #    #supportedFeatures = [
    #    #  "nixos-test"
    #    #  "benchmark"
    #    #  "big-parallel"
    #    #  "kvm"
    #    #];
    #  }
    #];
    #max-jobs = 0; # Disable (never build on local machine, even when connecting to remote builders fails) building on local machine; only build on remote builders.
  };

  nixpkgs.config = {
    allowUnfree = true;
    #cudaSupport = true;                 # May cause a mass rebuild
  };

  imports = [
    #./hardware-configuration-cheetah.nix
    ./hardware-configuration-taufiq.nix
    ./configuration.FULL.nix

    #./hosts.nix
    #./hosts2.nix

    #./bootEFI.nix
    #./bootBIOS.nix

    #./thinkpad.nix
    #./touchpad-scrollTwofinger-TapTrue.nix
    #./network-dns.nix

    #./users-anak2.nix
    ./users-naqib-wheel.nix
    ./users-naim.nix
    ./users-nurnasuha.nix
    ./users-julia-wheel.nix
    ./users-abdullah.nix

    ./nfs-client-automount.nix
    #./nfs-client-automount-games.nix
    #./nfs-client.nix

    #./virtualbox.nix # compile fail
    #./libvirt.nix
    #./anbox.nix
    #./anbox2.nix
    #./waydroid.nix

    ./3D.nix                            # freecad, qcad, ...
    ./steam.nix                         # steam for game, blender-LTS, ...
    ./roblox.nix
    #./mame.nix
    #./emulationstation.nix

    ./console-keyboard-dvorak.nix       # keyboard layout for console environment
    ./keyboard-with-msa.nix             # keyboard layout for graphical environment

    #./audio-pulseaudio.nix
    ./audio-pipewire.nix

    ./hardware-printer.nix
    #./hardware-tablet-wacom.nix
    #./veikk.nix

    ./zramSwap.nix

    # Data Backup (local/remote)
    #./btrbk-khadijah.nix #./btrbk-pull.nix

    #./sway.nix

    #./nix-garbage-collector.nix

    #./flatpak.nix
    #./appimage.nix

    #./walkie-talkie.nix

    ./ai.nix
  ];

  # Dell Precision M4800
  networking.hostName = "taufiq";   # "cheetah";
  # For the value of 'networking.hostID', use the following command:
  #     cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
  networking.hostId = "fc10af0f";

  nix.settings.trusted-users = [
    "root" "najib"
    "naqib"
    "julia"
  ];

  networking.useDHCP = false;          # Disabled by Najib on 20220724T0740
                                       # Enabled by Najib on 2023-02-01T1245 in attemp to decrease delay on startup.
  #networking.interfaces.eno1.useDHCP = true;

  #--------------------------------------------------------
  networking.nftables.enable = true;    # 'nftable' is enable; 'iptables' if not.
  networking.firewall = {
    enable = false;                      #'false' is the default.
    #enable = true;                      #'false' is the default.

    #trustedInterfaces = [ "enp0s2" ];
    #interfaces = {};
    #interfaces."enp0s2".allowedTCPPorts = [];
    allowPing = true;                   #'true' is the default.
    #pingLimit = "2/second";
    #pingLimit = "1/minute burst 5 packets";
    allowedTCPPorts = [
      #24007                            # gluster daemon
      #24008                            # gluster management
      #49152                            # gluster brick1
      #49153                            # gluster brick2
      #{ from = 38465; to = 38467; }    # Gluster NFS
      #111                              # portmapper
      1110                              # NFS cluster
      4045                              # NFS lock manager
    ];
    allowedUDPPorts = [
      #111                              # Gluster: portmapper
      #3450                             # for minetest server
      1110                              # NFS client
      4045                              # NFS lock manager
      #{ from = 4000; to = 4007; }
      #{ from = 8000; to = 8010; }
    ];
  };
  #--------------------------------------------------------

  # XXX: ???
  environment.systemPackages = with pkgs; [
    #tmux
    nvtop
    cudatoolkit
    pciutils
    file
    gnumake
    gcc
    gparted
    fatresize
    kate

    #blender
    #freecad
  ];
  #config = mkIf (config.services.xserver.videoDrivers == "nvidia") {
  #  environment.systemPackages = [
  #    pkgs.nvtop
  #  ];
  #};
  #config.environment = {
  #environment = {
  #  systemPackages =
  #    mkIf  ( config.services.xserver.videoDrivers == [ "nvidia" ] )
  #      [ pkgs.nvtop ];
  #      ##[
  #      ##  pkgs.htop
  #      ##  { mkIf (config.services.xserver.videoDrivers == [ "nvidia" ])  pkgs.nvtop }
  #      ##];
  #};

  #hardware.video.hidpi.enable = true;

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/"
    ];
    interval = "weekly";
  };

  services.fstrim.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 300; # in seconds
  #boot.loader.timeout = null;        # XXX: Not sure how to set null value here.

  #boot.loader.grub = {
  #  enable = true;
  #  version = 2;
  #  #device = "/dev/sda";
  #  device = "/dev/disk/by-id/ata-WDC_WD10JPVX-08JC3T6_WD-WX71AB6RKVV1";
  #
  #  enableCryptodisk = true;
  #  copyKernels = true;
  #
  #  useOSProber = true;
  #};

  # Setup keyfile
  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = null;
  #};
  #
  # XXX:
  # sudo touch /crypto_keyfile.bin

  # TODO:
  # Ref: https://nixos.wiki/wiki/Nvidia
  # Multiple Boot Configurations
  # Imagine you have a laptop that you mostly use in clamshell mode (docked, connected to an external display and plugged into a charger) but that you sometimes use on the go.
  # In clamshell mode, using PRIME Sync is likely to lead to better performance, external display support, etc., at the cost of potentially (but not always) lower battery life. However, when using the laptop on the go, you may prefer to use offload mode.

  # NixOS supports "specialisations", which allow you to automatically generate different boot profiles when rebuilding your system. We can, for example, enable PRIME sync by default, but also create a "on-the-go" specialization that disables PRIME sync and instead enables offload mode:
  #specialisation = {
  #  on-the-go.configuration = {
  #    system.nixos.tags = [ "on-the-go" ];
  #    hardware.nvidia = {
  #      prime.offload.enable = lib.mkForce true;
  #      prime.offload.enableOffloadCmd = lib.mkForce true;
  #      prime.sync.enable = lib.mkForce false;
  #    };
  #  };
  #};

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelParams = [
  #  #"i915.modeset=0" "nouveau.modeset=1"                                        # to disable i915 and enable nouveau
  #  "video=eDP-1:1920x1080" "video=VGA-1:1280x1024" "video=DP-1-3:1280x1024"    #
  #];

  #
  # NOTE:
  # When using a laptop with NVIDIA's Optimus technology (usually found
  # in laptops built in 2010 and later), everything will be passed through the
  # integrated graphics controller (usually Intel) before it gets to the
  # discrete video card (NVIDIA), which can cause a lot of otherwise
  # unexplained problems when enabled. There are a few ways to handle this, but
  # the simplest is to disable Optimus through the BIOS (normally accessed by
  # pressing F12 during boot). This will result in increased power consumption
  # (decreased battery life, increased running temperature), as the NVIDIA card
  # will now be handling all of the work all of the time.
  #
  # 1. Laptop Configuration: Hybrid Graphics (Nvidia Optimus PRIME)
  #   1.1 Optimus PRIME Option A: Offload Mode                        # Not using Nvidia GPU as default. Need manually call/script when we do want use Nvidia GPU.
  #   1.2 Optimus PRIME Option B: Sync Mode                           # Do using Nvidia GPU as default. Need manually call/script when do no want to use Nvidia GPU.
  #   1.3 Optimus Option C: Reverse Sync Mode (Experimental)
  # *PRIME 'Offload Mode' and 'Sync Mode' cannot be enabled at the same time.
  #
  # References:
  # - https://nixos.wiki/wiki/Nvidia
  #

  #
  # NOTE:
  # - A pre-requisite for PRIME synchronization with the NVIDIA driver is to enable modesetting.
  # - PRIME synchronization is not available with the AMDGPU DDX driver (xf86-video-amdgpu).
  #
  # References:
  # - https://wiki.archlinux.org/title/PRIME
  #

  # Enable swap on luks
  #boot.initrd.luks.devices."luks-a5172078-045e-4b03-abbc-32a86dfe0d06".device = "/dev/disk/by-uuid/a5172078-045e-4b03-abbc-32a86dfe0d06";
  #boot.initrd.luks.devices."luks-a5172078-045e-4b03-abbc-32a86dfe0d06".keyFile = "/crypto_keyfile.bin";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
    };
  };

  services.xserver.enable = true;

  #services.xserver.dpi = 96;

  #----------------------------------------------------------------------------
  #services.xserver.videoDrivers = [ "modesetting" "nvidia" ];
  #services.xserver.videoDrivers = [ "nvidia" "modesetting" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  #
  # Selecting an nvidia driver has been modified for NixOS 19.03. The version is now set using `hardware.nvidia.package`, not here.
  ##services.xserver.videoDrivers = [ "nvidiaLegacy390" ]; #

  hardware.nvidia = {
    #hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
    #hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

    #hardware.nvidia.prime.sync.enable = true;
    #hardware.nvidia.modesetting.enable = true;    # enable in order to prevent tearing on nvidia.prime.sync

    #hardware.nvidia.powerManagement.enable = false;
    #hardware.nvidia.powerManagement.finegrained = false;
    #hardware.nvidia.open = false;
    #hardware.nvidia.nvidiaSettings = true;
    ##hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #
    # Refer:
    #   https://www.nvidia.com/en-us/drivers/unix/
    #
    # 01:00.0 VGA compatible controller: NVIDIA Corporation GK106GLM [Quadro K2100M] (rev a1)
    # For GK106GLM [Quadro K2100M] in Dell Precision M4800
    # Card: Quadro K2100M --> Driver: nvidia legacy, version 390
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
    #
    # card: nvidia gt 720 --> driver: nvidia legacy, version 470
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };
  #----------------------------------------------------------------------------

  services.logind.extraConfig = "RuntimeDirectorySize=4G";    # before this it is 100% full with 1.6G tmpfs /run/user/1001

  #----------------------------------------------------------------------------

  #services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.startx.enable = true;

  services.xserver.displayManager.defaultSession = "none+xmonad";

  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.plasma6.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;
  #services.xserver.desktopManager.mate.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  #services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.lumina.enable = true;

  #services.xserver.windowManager.spectrwm.enable = true;
  #services.xserver.windowManager.qtile.enable = true;
  #services.xserver.windowManager.notion.enable = true;
  #services.xserver.windowManager.leftwm.enable = true;
  #services.xserver.windowManager.nimdow.enable = true;
  #services.xserver.windowManager.herbstluftwm.enable = true;

  #----------------------------------------------------------------------------

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
  ##powerManagement.cpuFreqGovernor = "powersave";
  ##powerManagement.enable = false; # Default is true;
  #powerManagement.cpufreq.min = 2000000000; # 2000000; # 800000; # Default is 'null';
  #powerManagement.cpufreq.max = 2600000000; # 2600000; # 3200000; # Default is null;
  #services.upower.enable = true;
  #powerManagement.powertop.enable = true;
  services.tlp = {
    enable = false;#true; # default is 'false'
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
      #CPU_SCALING_MIN_FREQ_ON_AC="2.0GHz"; # 2000000; # 800000;
      #CPU_SCALING_MAX_FREQ_ON_AC="2.6GHz"; # 2600000; # 3200000;
      #CPU_SCALING_MIN_FREQ_ON_BAT="2.0GHz"; # 2000000; #800000;
      #CPU_SCALING_MAX_FREQ_ON_BAT="2.6GHz"; # 2600000; #3200000; #2300000;
    };
  };
  #services.auto-cpufreq = {
  #  enable = true;
  #};
  #systemd.services."auto-cpufreq" = {
  #  after = [ "display-manager.service" ];
  #};

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

  #virtualisation.virtualbox.host.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11";
}
