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

  systemd.services.rtkit-daemon.serviceConfig.LogLevelMax=5;
#
#    0 or emergency, (highest priority messages)
#    1 or alert,
#    2 or critical,
#    3 or error,
#    4 or warning,
#    5 or notice,
#    6 or info
#    7 or debuginfo (lowest priority messages)
#
# For a given level chosen, logs of all higher levels won't be output. Note that if no loglevel is specified in whatever systemd service .conf file, the loglevel of the daemon defaults to 7, in other words allowing the highest level of verbosity.
# Regarding your specific need as worded in the title, LogLevelMax=5 (notice) should suffice (6 as reported in comments).
#

  networking.networkmanager.enable = true; # <-- will move to host specifix file

  # a workaround for error:
  #   store path starts with illegal character '.'
  # when running
  #   nix-store --delete
  #   nix-collect-garbage
  #nix.package = pkgs.nixVersions.latest;
  #nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  nix.daemonIOSchedClass = "idle";
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedPriority = 7;            # 0(high) (default) ... 7 (low) priority

  imports = [
    ./users-najib.nix
    #./garbage-collect.nix
  ];

  # Q: Each time I change my configuration.nix and run nixos-rebuild switch,
  #    I must run the command 'loadkeys dvorak' in order to use my preferred
  #    keyboard. How can I configure nixos to load the dvorak keymap
  #    automatically?
  # A: Try the configuration option: 'i18n.consoleKeyMap = "dvorak";'
  #
  # or you can run
  #   "setxkbmap dvorak"
  # in X or
  #   "loadkeys dvorak"
  # on the console.
  #
  console.font = "Lat2-Terminus16";
  #console.keyMap = "dvorak"; # default: us

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
    servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  };
  #services.ntp = {
  #  enable = true;
  #  servers = [ "mst.sirim.my" "my.pool.ntp.org" "0.asia.pool.ntp.org" "1.asia.pool.ntp.org" "2.asia.pool.ntp.org" "3.asia.ntp.org" ];
  #};

# Move to flake.nix
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

  environment.unixODBCDrivers = with pkgs.unixODBCDrivers; [
    sqlite
    psql
    mariadb
    #mysql
    msodbcsql18
    #msodbcsql17
    #redshift
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    unixODBC
    unixODBCDrivers.sqlite
    unixODBCDrivers.psql
    unixODBCDrivers.mariadb
    #unixODBCDrivers.mysql
    unixODBCDrivers.msodbcsql18
    tmux
    file lsof tree syslinux
    iw
    arandr autorandr
    xorg.libxcvt
    inxi
    atop gotop wavemon iotop nethogs
    iperf
    bandwhich
    xmlstarlet
    xsane sane-backends sane-frontends hplip
    #efibootmgr
    bind
    drill
    gnupg
    xorg.xmodmap
    ghostscript
    ripgrep
    acpid # A daemon for delivering ACPI events to userspace programs. 'services.acpid.enable'
    acpitool acpidump-all #XXX: should be in hardware specific file
    #tpacpi-bat # Tool to set battery charging thesholds on Lenovo Thinkpad
    acpi acpilight
    mkpasswd
    pass # CLI password manager
    qtpass
    bsd-finger
    gnumake   # install gnumake, needed for ihp
    cmake     # needed for doom-emacs vterm
    libtool   # needed for doom-emacs vterm
    ispell    # needed for doom-emacs vterm
    expect    # tool for automating interactive applications
    saldl    # cli downloader optimized for speed
    axel      # Console downloading program with some features of parallel connections for faster downloading
    scrot maim  # to take screenshot
    jq      # CLI JSON processor
    xdotool    # xserver dispaly tool
    xbindkeys
    bluez # official linux Bluetooth protocol stack
    ethtool
    adwaita-qt
    adwaita-icon-theme
    fontforge  # fontforge-gtk
    fontforge-fonttools
    xlsfonts  # To see which fonts are currently available to X.
    binutils-unwrapped
    pciutils
    usbutils
    xbrightness
    pstree broot
    psmisc
    xorg.xdpyinfo
    glxinfo
    glmark2
    intel-gpu-tools inteltool intelmetool
    drm_info
    gpuvis gputils
    pinfo
    lm_sensors
    iosevka
    screenfetch
    xterm
    st
    #rxvt                               #<-- have vulnerablility
    rxvt-unicode
    ed
    nano neovim vim kakoune micro jedit vis # jed
    vimHugeX
    patool # portable archive file manager
    zip unzip
    atool # Archive command line helper
    unrar
    p7zip
    xarchiver
    file-roller           # Archive manager for the GNOME desktop environment
    dosbox

    #---------------------------------------------------------------
    # System tools
    #---------------------------------------------------------------

    dmidecode
    #hardinfo
    lshw
    hwinfo
    neofetch
    cpufetch
    acpi
    libinput
    libinput-gestures
    alsa-utils
    partclone           # Utilities to save and restore used blocks on a partition
    hdparm
    lsscsi

    #diskonaut           # a terminal disk space navigator
    duf
    diskus
    dfc
    btdu                # sampling disk usage profiler for btrfs
    gdu                 # Disk usage analyzer with console interface
    godu                #
    ncdu                # Disk usage analyzer with an ncurses interface
    fdupes              # find duplicate files
    fsearch             # find duplicate files (GUI)
    dua                 # A tool to conveniently learn about the disk usage of directories, fast! View disk space usage and delete unwanted data, fast. 
    dutree
    du-dust #dust
    duc                 # Collection of tools for inspecting and visualizing disk usage
    gdmap
    baobab              # Graphical application to analyse disk usage in any GNOME environment
    k4dirstat           # A small utility program that sums up disk usage for directory trees
    qdirstat
    jdiskreport
    gnome-disk-utility      # A udisks graphical front-end

    gnome-logs    # A log viewer for the systemd journal

    #---------------------------------------------------------------
    # find duplicate files
    #---------------------------------------------------------------

    jdupes              # A powerful duplicate file finder and an enhanced fork of 'fdupes'
    fclones             # Efficiient Duplicate File Finder and Remover
    fclones-gui         # Interactive duplicate file remover

    #---------------------------------------------------------------
    # Desktop, window manager and tools
    #---------------------------------------------------------------

    volumeicon networkmanagerapplet #gnome3.networkmanagerapplet
    #xkblayout-state <-- disabled because have runtime error segmentation fault.
    xkb-switch
    #xkbprint
    xorg.xev
    dmenu
    volumeicon pasystray trayer #phwmon
    xlockmore xorg.xhost
    xclip
    #i3lock
    pulsemixer qpaeq pulseeffects-legacy #pulseeffects-pw #pulseeffects pipewire
    xscreensaver
    haskellPackages.xmobar #rfkill
    brightnessctl

    mc                                  # File Manager and User Shell for the GNU Project
    fff                                 # A simple file manager written in bash
    nnn
    clifm                               # This is leo-arch/clifm (written in c); not the pasqu4le/clifm (written in haskell)
    sfm                                 # Simple file manager
    clex
    ranger
    deer                                # A ranger-like file navigation for zsh
    #hunter
    #rox-filer
    #spaceFM
    #xfe

    joshuto    # Ranger-like terminal file manager written in Rust
    lf      # A terminal file manager written in Go and heavily inspired by ranger

    trash-cli

    sxiv
    feh
    evince                              # Documents viewer

    #---------------------------------------------------------------
    # Programming, software development, ...
    #---------------------------------------------------------------

    nix-top
    direnv      # nix-direnv # nix-shell
    elvish      # A friendly and expressive command shell
    lua         # love

    acpid       # A daemon for delivering ACPI events to userspace programs. 'services.acpid.enable'
    acpitool acpidump-all #XXX: should be in hardware specific file
    #tpacpi-bat # Tool to set battery charging thesholds on Lenovo Thinkpad
    acpi acpilight

    mkpasswd
    pass        # CLI password manager
    qtpass

    picom       # compositor manager; try to use picom for gromit-mpx (screen annotation) in xmonad (window manager).

    fluxbox     # Need this because I need to use command 'fbsetroot' to set plain black background when using xmonad.

    rsync grsync zsync luckybackup
    expect      # tool for automating interactive applications
    saldl       # cli downloader optimized for speed
    scrot maim  # to take screenshot
    jq          # CLI JSON processor
    xdotool     # xserver dispaly tool
    xbindkeys

    #gnomeExtensions.draw-on-your-screen
    #pentablet-driver
    gromit-mpx  # Desktop annotation tool

    partclone   # Utilities to save and restore used blocks on a partition
    keybase keybase-gui
    python3Minimal      #python3Full #python39Full

    gxmessage   #xorg.xmessage # to be used with xmonad, but not support scroll? maybe yad, zenity, dialog, xdialog, gdialog, kdialog, gxmessage, hmessage
    exiftool
    wireshark
    # steghide
    gdb gdbgui
    parcellite  # clipboard manager in GUI
    clipboard-jh  # clipboard manager in CLI
    clipcat # clipboard manager
    screenkey onboard xorg.xkbcomp # xorg.xkbprint
    cryptsetup  # luks disk encryption

    bc  # GNU CLI calculator
    eva # A CLI calculator REPL, similar to bc
    clac # CLI Interactive stack-based calculator
    pro-office-calculator speedcrunch wcalc pdd galculator # calculator
    qalculate-gtk # qalculate-qt # the ultimate desktop calculator
    gnome-calculator
    rink  # unit-aware CLI calculator
    fend # CLI arbitrary-precision unit-aware calculator
    wcalc # A command line (CLI) calculator
    quich # The advanced terminal (CLI) calculator
    kalker  # A command line (CLI) calculator that supports math-like syntax with user-defined variables, functions, derivation, integration, and complex numbers
    #deepin.deepin-calculator  # A easy to use calculator for ordinary users
    pantheon.elementary-calculator # GUI Calculator app designed for elementary OS
    mate.mate-calc # GUI calculator for the MATE desktop
    lumina.lumina-calculator # Scientific calculator for the Lumina Desktop
    ipcalc  # Simple CLI IP network calculator
    sipcalc # advanced console (CLI) ip subnet calculator
    pdd # CLI tiny date, time diff calculator

    ethtool

    adwaita-qt
    adwaita-icon-theme

    fontforge   # fontforge-gtk
    fontforge-fonttools

    sigil       # Create and edit epub.
    manuskript  # for writing story, etc.
    #genymotion

    binutils-unwrapped
    pciutils
    usbutils
    xbrightness
    pstree broot
    psmisc

    lm_sensors

    acpi

    libinput
    libinput-gestures

    #virtscreen

    #synergy synergyWithoutGUI
    xsel

    graphviz-nox
    #zgrviewer
    kgraphviewer

    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.git-hub
    gitg

    #seaweedfs

    maven
    edid-decode
    javaCup
    javacc
    jetty
    mono
    samba
    #steam-run # look at nixos/steam.nix
    tabula-java

    #-------------------------------------------
    # Wine
    #-------------------------------------------

    # Support both 32-bit and 64-bit applications
    wineWowPackages.full
    #wineWowPackages.unstableFull
    #wineWowPackages.stable

    # OR
    # Support 32-bit only
    #wine

    # OR
    # Support 64-bit only
    #(wine.override {wineBuild = "wine64";})

    # OR
    # Native wayland support (unstable)
    #wineWowPackages.waylandFull

    # Winetricks (all versions)
    winetricks

    #-------------------------------------------

    xorg.xdpyinfo
    xorg.xkill
    xorg.xwininfo
    flatpak
    #ihp

    #jami-daemon
    #jami-client-gnome
    jitsi
    #jitsi-meet

    # GAMES
    #teeworlds
    #minecraft-launcher
    #minecraft-server
    #openttd
  ];

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

  services.atd.enable = true;

  #services.hdapsd.enable = true;       # Hard Drive Active Protection System Daemon XXX: not belong here, should put this in per host file.

  services.taskserver.enable = true;    # sync taskwarrior

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

  # --------------------------------------------------------------

  #qt5.style = "adwaita";

  users.extraGroups.istana46.gid = 1001;
  users.extraGroups.najib.gid = 1002;
  users.extraGroups.julia.gid = 1003;
  users.extraGroups.naqib.gid = 1004;
  users.extraGroups.nurnasuha.gid = 1005;
  users.extraGroups.naim.gid = 1006;

  # can also use 'xlsfonts' to see which fonts are available to X.
  # if some fonts appear distorted, e.g. characters are invisible, or not anti-aliases you may need to rebuild the font cache with 'fc-cache --really-force --verbose'.
  # (after rm -vRf ~/.cache/fontconfig)
  #
  # Adding personal fonts to ~/.fonts doesn't work
  # The ~/.fonts directory is being deprecated upstream. It already doesn't work in NixOS.
  # The new preferred location is in $XDG_DATA_HOME/fonts, which for most users will resolve to ~/.local/share/fonts
  # $ ln -s /run/current-system/sw/share/X11/fonts ~/.local/share/fonts
  # $ ln -s ~/.local/share/fonts ~/.fonts
  #
  # Example: Install 'SourceCodePro-Regular':
  #font=$(nix-build --no-out-link '<nixpkgs>' -A source-code-pro)/share/fonts/opentype/SourceCodePro-Regular.otf
  #cp $font ~/.local/share/fonts
  #fc-cache
  # Verify that the font has been installed
  #fc-list -v | grep -i source
  #
  # $ cd /nix/var/nix/profiles/system/sw/share/X11/fonts
  # $ fc-query DejaVuSans.ttf | grep '^\s\+family:' | cut -d'"' -f2
  #
  #
  #==================================================
  # This is working solution as tested on
  # 2022-11-07
  # 2023-04-05
  # 2025-05-04
  # NOTE:
  #   - Must not in zip file, need to extracted
  #   - Can be in subdirectories
  #--------------------------------------------------
  # fc-list -v | grep -i edward
  # ln -s ~/.fonts ~/.local/share/fonts
  #
  # rm -vRf ~/.cache/fontconfig
  # fc-cache --really-force --verbose
  # fc-list -v | grep -i edward
  #==================================================
  #
  #
  fonts = {

    fontconfig.enable = true;
    #
    # System-wide default font(s). Multiple fonts may be listed in case multiple languages must be supported.
    #fontconfig.defaultFonts.serif = [ "DejaVu Serif" ];
    #fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
    #fontconfig.defaultFonts.sansSerif = [ "DejaVu Sans" ];
    #fontconfig.defaultFonts.monospace = [ "DejaVu Sans Mono" ]; # "jetbrains mono"
    #
    fontconfig.defaultFonts.monospace = [
      "Fira Mono for Powerline (Bold)"
      "DejaVu Sans Mono"
      "jetbrains mono"
    ];
    #
    #fontconfig.defaultFonts = {
    #  # --- Prioritize bitmap/monospace fonts ---
    #  monospace = [ "Terminus" "DejaVu Sans Mono" "Liberation Mono" ];  # Fallback chain
    #  sansSerif = [ "DejaVu Sans" "Liberation Sans" ];  # Avoid anti-aliased fonts
    #  serif = [ "DejaVu Serif" "Liberation Serif" ];
    #  #emoji = [];
    #};

    #fontconfig.antialias = false; # Disable anti-aliasing globally
    #fontconfig.hinting = {
    #  enable = true; # Force hinting for sharpness
    #  style = "full"; # Maximum hinting
    #};

    fontDir.enable = true;              # Create a directiry with links to all fonts in /run/current-system/sw/share/X11/fonts

    #enableCoreFonts = true;
    enableGhostscriptFonts = true;
    #fonts = with pkgs; [
    packages = with pkgs; [
      corefonts                         # Microsoft free fonts; Microsoft's TrueType core fonts for the Web
      inconsolata                       # monospaced
      ubuntu_font_family                # ubuntu fonts
      unifont                           # some international languages
      cardo                             # Cardo is a large Unicode font specifically designed for the needs of classicists, Biblical scholars, medievalists, and linguists.
      google-fonts
      tewi-font
      #kochi-substitude-naga10
      anonymousPro
      dejavu_fonts
      noto-fonts #font-droid
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-emoji-blob-bin
      noto-fonts-lgc-plus
      terminus_font_ttf
      source-code-pro                   # monospaced font family for user interface and coding environments
      fira-code                         # suitable for coding
      fira-code-symbols
      cascadia-code                     # Monospaced font that includes programming ligatures and is designed to enhance the modern look and feel of the Windows Terminal
      #mplus-outline-fonts
      dina-font
      proggyfonts
      freefont_ttf
      liberation_ttf                    # Liberation Fonts, replacements for Times New Roman, Arial, and Courier New
      liberation-sans-narrow            # Liberation Sans Narrow Font Family is a replacement for Arial Narrow
      powerline-fonts
      terminus_font
      ttf_bitstream_vera

      vistafonts                        # Some TrueType fonts from Microsoft Windows Vista (Calibri, Cambria, Candara, Consolas, Constantia, Corbel)
      carlito                           # A sans-serif font, metric-compatible with Microsoft Calibri
      wineWowPackages.fonts             # Microsoft replacement fonts by the Wine project

      amiri
      scheherazade-new

      national-park-typeface

      source-han-sans-japanese
      source-han-sans-korean
      source-han-sans-simplified-chinese
      source-han-sans-traditional-chinese

      iosevka

      #nerdfonts
      #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ] })
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.meslo-lg
      nerd-fonts.sauce-code-pro
      nerd-fonts.terminess-ttf
      nerd-fonts.monoid
      nerd-fonts.noto
      nerd-fonts.iosevka-term
      nerd-fonts._0xproto
      nerd-fonts.jetbrains-mono
      nerd-fonts.ubuntu

      jetbrains-mono # An opensource typeface made for developers. suitable for coding
      mononoki # A font for programming and code review
    ];
  };

  #system.copySystemConfiguration = true;

}
