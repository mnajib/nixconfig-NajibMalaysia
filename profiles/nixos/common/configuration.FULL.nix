# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
#
# nixos-rebuild switch
#
# References:
#     https://nixos.wiki/wiki/Full_Disk_Encryption
#     https://nixos.wiki/wiki/Configuration_Collection
#
# Workaround nixos-install problem:
#     nix-build '<nixpkgs/nixos>' -A config.system.build.toplevel -I nixos-config=/mnt/etc/nixos/configuration.nix
#     nixos-install
#

{
  config,
  pkgs,
  lib,
  ...
}:


#let
#
#in
{
  #
  #  0 or emergency, (highest priority messages)
  #  1 or alert,
  #  2 or critical,
  #  3 or error,
  #  4 or warning,
  #  5 or notice,
  #  6 or info
  #  7 or debuginfo (lowest priority messages)
  #
  # For a given level chosen, logs of all higher levels won't be output. Note that if no loglevel is specified in whatever systemd service .conf file, the loglevel of the daemon defaults to »
  # Regarding your specific need as worded in the title, LogLevelMax=5 (notice) should suffice (6 as reported in comments).
  #
  systemd.services.rtkit-daemon.serviceConfig.LogLevelMax = 5;

  networking.networkmanager.enable = true;

  # a workaround for error:
  #   store path starts with illegal character '.'
  # when running
  #   nix-store --delete
  #   nix-collect-garbage
  #nix.package = pkgs.nixVersions.latest;
  #nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # Binary Cache for Haskell.nix
  #nix.settings.trusted-public-keys = [
  #  "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  #];
  #nix.settings.substituters = [
  #  "https://cache.iog.io"
  #];

  nix.daemonIOSchedClass = "idle";
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedPriority = 7;            # 0(high) (default) ... 7 (low) priority

  imports = [
    ./users-najib.nix
    #./garbage-collect.nix
    #./sqlite.nix

    # Check: load in per-host config
    #./xdg.nix
    #./xdg-gtk.nix
    #./xdg-kde.nix

    #./doom-emacs.nix

    ./packages/base.nix
    #./packages/android.nix
    ./packages/browsers.nix
    #./packages/communication.nix
    #./packages/desktop.nix
    ./packages/devtools.nix
    #./packages/drivers.nix
    ./packages/editors.nix
    ./packages/filesystems.nix
    #./packages/fonts.nix
    #./packages/games.nix
    #./packages/media.nix
    #./packages/monitoring.nix
    #./packages/networking.nix
    #./packages/office.nix
    #./packages/virtualization.nix
    #./packages/calculators.nix
    #./packages/csv-tools.nix
    #./packages/archivers.nix
    #./packages/filemanagers.nix
    #./packages/extras.nix
  ];

  # Ref.:
  #   https://lh.2xlibre.net/locale/en_GB/
  #   https://lh.2xlibre.net/locale/en_GB/glibc/
  #   https://askubuntu.com/questions/21316/how-can-i-customize-a-system-locale#162714
  #
  i18n.defaultLocale = "en_US.UTF-8";
  #i18n.defaultLocale = "en_GB.UTF-8";
  #i18n.defaultLocale = "en_GB.UTF-8/UTF-8";
  i18n.supportedLocales = [
    "all"
    #"en_GB.UTF-8/UTF-8"
    #"en_US.UTF-8/UTF-8"
    #"ms_MY.UTF-8/UTF-8"
    #"ms_MY/ISO-8859-1"
  ];
  i18n.extraLocaleSettings = {
    d_fmt="%F";
    t_fmt="%T";
    d_t_fmt="%F %T %A %Z";
    date_fmt="%F %T %A %Z";

    LC_MESSAGES = "en_GB.UTF-8";
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    #LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    #LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    #LC_TIME = "ms_MY.UTF-8";
  };

  time.timeZone = "Asia/Kuala_Lumpur";
  time.hardwareClockInLocalTime = true;
  #networking.timeServers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  services.timesyncd = {
    enable = true;
    servers = [
      "mst.sirim.my"
      "my.pool.ntp.org"
      "0.asia.pool.ntp.org"
      "1.asia.pool.ntp.org"
      "2.asia.pool.ntp.org"
      "3.asia.ntp.org"
    ];
  };
  #services.ntp = {
  #  enable = true;
  #  servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  #};

#  nixpkgs.config = {
#    allowUnfree = true;
#    nvidia.acceptLicense = true;
#
#    pulseaudio = true;
#
#    xsane = {
#      libusb = true;
#    };
#
#    #firefox = {
#      #enableAdobeReader = true;
#      #enableAdobeFlash = true;
#      #enableGoogleTalkPlugin = true;
#      #enableVLC = true;
#    #};
#
#    #chromium = {
#      #enablePepperFlash = true;
#      #enablePepperPDF = true;
#    #};
#
#    #packageOverrides = pkgs: {
#    #  ##unstable = import unstableTarball {
#    #  #master = import masterTarball {
#    #    #config = config.nixpkgs.config;
#    #  #};
#    #  unstable = import <nixos-unstable> {
#    #    config = config.nixpkgs.config;
#    #  };
#    #};
#  };

  #nixpkgs.configs.packageOverrides = pkgs: {
  #  xsaneGimp = pkgs.xsane.override ( nimpSupport = true; );
  #};

  environment.sessionVariables = rec {
    #XDG_DATA_HOME = "$HOME/var/lib";
    #XDG_CACHE_HOME = "$HOME/var/cache";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  #environment.variables = {
  #  XDG_CONFIG_HOME = "${HOME}/.config";
  #  XDG_DATA_HOME = "${HOME}/var/lib";
  #  XDG_CACHE_HOME = "${HOME}/var/cache";
  #};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #

  #programs.firefox.enable = true;

  #programs.way-cooler.enable = true;

  programs.java.enable = true;

  programs.light.enable = true;

  programs.dconf.enable = true;         # for gnome?

  programs.tmux = {
    enable = true;
    clock24 = true;
    newSession = true;
    resizeAmount = 1;
    baseIndex = 1;
    historyLimit = 10000;

    #prefix = "C-a";
    #shortcut = "a";
    shortcut = "b";

    #keyMode = "vi";
    #customPaneNavigationAndResize = true;

    # XXX:
    withUtempter = true;

    secureSocket = false;               # Store tmux socket under /run, which is more secure than /tmp, but as a downside it doesn’t survive user logout.

    plugins = [
      #pkgs.tmuxPlugins.nord
    ];
  };

  #
  # Referrences:
  #   https://nixos.org/manual/nixos/stable/#module-programs-zsh-ohmyzsh
  #
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    #interactiveShellInit = "";

    histSize = 10000;
    #histFile = "${config.xdg.dataHome}/zsh/history";
    #histFile = "${HOME}.config/zsh/history";

    shellAliases = {
      l = "ls -Filah";
      j = "jobs";
      s = "sync";
      d = "export DISPLAY=:0";
      #update = "sudo nixos-rebuild switch";
    };

    # zplug: a next-generation plugin manager for zsh
    #...

    #
    # References:
    #   https://github.com/robbyrussell/oh-my-zsh/wiki
    #
    ohMyZsh = {
      enable = false;

      #plugins = [
      #  #"git"
      #  "colored-man-pages"
      #  "man"
      #  "command-not-found"
      #  "extract"
      #  "direnv"
      #  "python"
      #];

      #theme = "agnoster";        # "bureau" "agnoster" "aussiegeek" "dallas" "gentoo"
      theme = "gentoo";

      # Custom additions
      #custom = "~/path/to/custom/scripts";

      # Custom environments
      # https://search.nixos.org/packages?channel=unstable&show=zsh-vi-mode&from=0&size=50&sort=relevance&type=packages&query=zsh
      customPkgs = with pkgs; [
        nix-zsh-completions
        zsh-nix-shell
        zsh-completions
        zsh-autosuggestions
        #zsh-git-prompt
        zsh-vi-mode
        #zsh-command-time
        #zsh-powerlevel10k
        zsh-fast-syntax-highlighting
      ];
    }; # End ohMyZsh

  }; # End programs.zsh

  #programs.fish.enable = true;
  programs.xonsh.enable = true;

  #users.users.najib.shell = pkgs.fish;    #pkgs.zsh; # pkgs.fish;
  #users.defaultUserShell = pkgs.fish;    #pkgs.zsh;
  #users.users.root.shell = pkgs.fish;    #pkgs.zsh;

  #services.clipcat.enable = true;         # clipboard manager daemon

  services.urxvtd.enable = true;          # To use urxvtd, run "urxvtc".

  #services.lorri.enable = true;          # Under Linux you can set it via your desktop environment's configuration manms need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  #programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # XXX:
  #services.udev.packages = with pkgs; [ gnome3.gnome-settings-daemon ];

  #services.glusterfs.enable = true;

  # XXX: better put this on host specific file
  #services.flatpak.enable = true;
  #xdg.portal.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Keybase
  #services.kbfs.enable = true;
  #services.keybase.enable = true;

  services.atd.enable = true;

  #services.hdapsd.enable = true;       # Hard Drive Active Protection System Daemon XXX: not belong here, should put this in per host file.

  #services.taskserver.enable = true;    # sync taskwarrior

  programs.mosh.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.X11Forwarding = true;
    #ports= [ 7177 ];
    #extraConfig = ''
    #  X11DisplayOffset 10
    #'';
  };
  services.sshguard.enable = true;

  #services.toxvpn.enable = true;

  documentation.nixos.enable = true;

  #services.syncthing = {
  #  enable = false; # currently not using handphone
  #  user = "najib";
  #  dataDir = "/home/najib/.config/syncthing";
  #};

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ]; # [ pkgs.hplipWithPlugin ];

# hardware.opengl.enable = true;
# #hardware.opengl.driSupport = true; # no longer has any effect, please remove it
# hardware.opengl.driSupport32Bit = true;
# #hardware.opengl.extraPackages = with pkgs.
# #hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
# #hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
# #hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl mesa.drivers ];
# hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau mesa.drivers ]; # intel-ocl cannot be downloaded source from any mirror
# #hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva  ];
# #hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
# hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva vaapiIntel libvdpau-va-gl vaapiVdpau ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  services.fwupd = {
    enable = true;
  };

  #services.locate.enable = true; # default false
  #services.picom.enable = true; #services.compton.enable = true;
  programs.adb.enable = true;

  #services.cron = {
    #enable = true;
    #systemCronJobs = [
      #"30 22 * * * sudo --user=julia /home/julia/bin/lockmyscreen > /dev/null 2>&1"
    #];
  #};

  # By default, PostgreSQL stores its databases in /var/db/postgresql.
  #services.postgresql.enable = true;
  #services.postgresql.package = pkgs.postgresql;

  #services.ddclient.configFile = "/root/nixos/secrets/ddclient.conf"; # default "/etc/ddclient.conf"

  #
  #
  # You can find valid values for these options in
  #   $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst

#  services.xserver.desktopManager.xterm.enable = false;
#  services.xserver.windowManager.xmonad = {
#    enable = true;
#    enableContribAndExtras = true;
#    extraPackages = haskellPackages: [
#      haskellPackages.xmonad
#      haskellPackages.xmonad-extras
#      haskellPackages.xmonad-contrib
#
#      haskellPackages.dbus
#      haskellPackages.List
#      haskellPackages.monad-logger
#      haskellPackages.xmobar
#    ];
#  };
#  #
#  services.xserver.windowManager.awesome = {
#    enable = true;
#    #luaModules = [
#      #pkgs.luaPackages.vicious
#    #];
#  };

  # --------------------------------------------------------------

  #qt5.style = "adwaita";

  users.extraGroups.istana46.gid = 1001;
  users.extraGroups.najib.gid = 1002;
  users.extraGroups.julia.gid = 1003;
  users.extraGroups.naqib.gid = 1004;
  users.extraGroups.nurnasuha.gid = 1005;
  users.extraGroups.naim.gid = 1006;

  #system.copySystemConfiguration = true;

}
