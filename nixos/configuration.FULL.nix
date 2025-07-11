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

  # XXX:
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
    ./sqlite.nix

    # Check: load in per-host config
    #./xdg.nix
    #./xdg-gtk.nix
    #./xdg-kde.nix

    #./doom-emacs.nix
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

  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;

    pulseaudio = true;

    xsane = {
      libusb = true;
    };

    #firefox = {
      #enableAdobeReader = true;
      #enableAdobeFlash = true;
      #enableGoogleTalkPlugin = true;
      #enableVLC = true;
    #};

    #chromium = {
      #enablePepperFlash = true;
      #enablePepperPDF = true;
    #};

    #packageOverrides = pkgs: {
    #  ##unstable = import unstableTarball {
    #  #master = import masterTarball {
    #    #config = config.nixpkgs.config;
    #  #};
    #  unstable = import <nixos-unstable> {
    #    config = config.nixpkgs.config;
    #  };
    #};
  };

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
    socat
    redis

    csvq
    csvtk
    csvkit
    csview
    csv2md
    csvtool
    csvlens
    csvdiff
    csv2svg
    csv2odf
    csv-tui
    csvquote
    xlsx2csv
    #qsv
    xan #xsv
    clevercsv
    graph-cli
    zsv
    textql
    tabview
    tidy-viewer
    tabiew
    miller
    json-plot
    clevercsv

    unixODBC
    unixODBCDrivers.sqlite
    unixODBCDrivers.psql
    unixODBCDrivers.mariadb
    #unixODBCDrivers.mysql
    unixODBCDrivers.msodbcsql18

    glom

    firmware-updater
    firmware-manager
    fwts
    gnome-firmware
    linux-firmware
    fwup
    fwupd
    fwupd-efi

    sshfs # FUSE-based filesystem that allows remote filesystems to be mounted over SSH; mount.fuse.sshfs, mount.sshfs, sshfs

    beep

    cachix

    #unstable.minetest
    #unstable.google-chrome
    google-chrome

    gptfdisk efibootmgr btrfs-progs btrbk #bcachefs-tools
    exfat
    fatresize	# The FAT16/FAT32 non-destructive resizer
    gsmartcontrol smartmontools
    #lizardfs                 # marked as broken?
    wget curl killall
    mtr iproute2 # busybox
    htop mc irssi most mosh coreutils
    glances
    nload
    zenith                    # Sort of like top or htop but with zoom-able charts, network, and disk usage
    bmon                      # Network bandwidth monitor
    btop
    enlightenment.evisum
    tldr # community-driven simplified man pages

    screen
    tmux
    dtach
    byobu
    zellij

    #xpra
    #run-scaled

    file lsof tree syslinux
    iw

    arandr autorandr
    xorg.libxcvt

    inxi

    darcs
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

    geteltorito woeusb #k3b
    #ventoy-bin

    #stack

    ripgrep

    #qgis
    #obs-studio #obs-linuxbrowser
    vokoscreen #vokoscreen-ng
    #darktable

    #kodi-wayland
    # XXX:
    #( pkgs.kodi.passthru.withPackages ( kodiPkgs: with kodiPkgs; [
    #  jellyfin
    #  kodi-six #six
    #  youtube
    #  pdfreader
    #]))

    acpid # A daemon for delivering ACPI events to userspace programs. 'services.acpid.enable'
    acpitool acpidump-all #XXX: should be in hardware specific file
    #tpacpi-bat # Tool to set battery charging thesholds on Lenovo Thinkpad
    acpi acpilight

    mkpasswd
    pass # CLI password manager
    qtpass
    bsd-finger

    picom    # compositor manager; try to use picom for gromit-mpx (screen annotation) in xmonad (window manager).

    fluxbox    # Need this because I need to use command 'fbsetroot' to set plain black background when using xmonad.

    #--------------------------------------------------------------------------
    #rofi    # Using rofi in xmonad.
    #rofi-pass
    #rofi-calc
    #rofi-emoji
    #rofimoji
    #rofi-rbw # bitrwarden password manager
    #--------------------------------------------------------------------------
    #(rofi.override {
    #  plugins = [
    #    rofi-file-browser
    #    rofi-pass
    #    rofi-calc
    #    rofi-emoji
    #    rofi-rbw
    #    rofi-rbw-x11
    #    rofi-systemd
    #    rofi-screenshot
    #    rofi-power-menu
    #    rofi-pulse-select
    #  ];
    #})
    #--------------------------------------------------------------------------

    dzen2     # A general purpose messaging, notification and menuing program for X11
    gnumake   # install gnumake, needed for ihp
    cmake     # needed for doom-emacs vterm
    libtool   # needed for doom-emacs vterm
    ispell    # needed for doom-emacs vterm

    expect    # tool for automating interactive applications

    saldl    # cli downloader optimized for speed
    axel      # Console downloading program with some features of parallel connections for faster downloading
    aria      # a lightweight, multi-protocol, multi-source, command-line download utility <-- aria2 ?
    ariang    # a modern web frontend making aria2 easier to use
    persepolis  # a GUI for aria2

    scrot maim  # to take screenshot
    jq      # CLI JSON processor
    xdotool    # xserver dispaly tool
    xbindkeys

    #qtox    # chat using tox protocol
    #keybase keybase-gui

    bluez # official linux Bluetooth protocol stack

    #gnomeExtensions.draw-on-your-screen
    #pentablet-driver
    gromit-mpx                          # Desktop annotation tool
    #xournal                            # note-taking application (supposes stylus)
    xournalpp                           # handwriting notetaking software with PDF annotation support
    rnote                               # Simple drawing application to create handwritten notes
    pdftk                               # CLI tool for working with PDFs
    pdfarranger                         # python38Packages.pikepdf
    #pdfchain                           #
    gnote                               # GUI A note taking application
    notes                               # GUI A fast and beautiful note-taking app; but look too complex on quick first look.
    cherrytree                          # GUI An hierarchical note taking application

    #glow       # markdown viewer for CLI
    retext      # markdow editor
    litemdview  # a suckless markdown viewer

    gnome-clocks

    screenkey onboard xorg.xkbcomp # xorg.xkbprint

    qemu qemu_kvm qemu-utils
    qemu_full
    virt-viewer
    libvirt virt-manager bridge-utils vde2 # virtmanager virt-manager-qt
    #virtualbox
    ethtool

    adwaita-qt
    adwaita-icon-theme

    niv
    npins

    fontforge  # fontforge-gtk
    fontforge-fonttools
    xlsfonts  # To see which fonts are currently available to X.

    sigil    # Create and edit epub.
    manuskript  # for writing story, etc.

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
    #
    # XXX: should move this to host specific config file.
    #rodeontools
    #rocm-smi
    #radeon-profile
    #radeontop
    #rgp
    #umr
    #
    #nvtop
    drm_info
    gpuvis gputils

    pinfo

    lm_sensors

    taskwarrior3 timewarrior
    taskwarrior-tui vit tasknc

    oneko xcape find-cursor #gnomeExtensions.jiggle hlcursors

    #synergy synergyWithoutGUI
    barrier # share keyboard & mouse; remote

    iosevka

    inkscape

    gnucash
    homebank
    #kmymoney # XXX: compile failed while upgrade keira

    gtypist
    tuxtype

    mgba

    screenfetch

    #---------------------------------------------------------------
    # Terminar Emulator
    #---------------------------------------------------------------

    xterm
    st
    #rxvt                               #<-- have vulnerablility
    rxvt-unicode
    #mrxvt
    #termonad
    #termonad-with-packages
    enlightenment.terminology           #
    gnome-console

    #kitty                               # one of my favourite?
    termite                             # alacritty replaced by alacritty?
    alacritty                           #
    rio

    #---------------------------------------------------------------
    # text editor
    #---------------------------------------------------------------

    ed
    nano neovim vim kakoune micro jedit vis # jed
    vimHugeX
    #emacs # emacs-nox
    #vscode
    #leafpad # old, not maintain
    xfce.mousepad
    notepadqq geany      # kate
    #pulsar                             # forked from atom text editor
    #unstable.yi # Install yi the other way to allow enable personalized configuration.
    #leksah
    enlightenment.ecrire
    gnome-text-editor

    #---------------------------------------------------------------
    # archiver
    #---------------------------------------------------------------

    patool # portable archive file manager
    zip unzip
    atool # Archive command line helper
    unrar
    p7zip
    xarchiver
    file-roller           # Archive manager for the GNOME desktop environment

    #---------------------------------------------------------------
    # Games
    #---------------------------------------------------------------
    gnome-chess
    #bzflag

    #---------------------------------------------------------------
    # Emulator, subsystem, container, vitualization, ...
    #---------------------------------------------------------------

    #genymotion
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

    #---------------------------------------------------------------
    # gnome
    #---------------------------------------------------------------

    simple-scan
    gnomeExtensions.appindicator
    #gnomeExtensions.cpufreq # Not available anymore on 2024-11-05

    #---------------------------------------------------------------
    # xfce
    #---------------------------------------------------------------

    #xfce.xfce4-xkb-plugin
    #xfce.xfce4-mpc-plugin
    #xfce.xfce4-eyes-plugin
    #xfce.xfce4-verve-plugin
    #xfce.xfce4-timer-plugin
    #xfce.xfce4-notes-plugin
    #xfce.xfce4-sensors-plugin
    #xfce.xfce4-netload-plugin
    ##xfce.xfce4-namebar-plugin
    #xfce.xfce4-fsguard-plugin
    #xfce.xfce4-cpufreq-plugin
    #xfce.xfce4-clipman-plugin
    #xfce.xfce4-battery-plugin
    #xfce.xfce4-windowck-plugin
    ##xfce.xfce4-dockbarx-plugin
    #xfce.xfce4-datetime-plugin
    #xfce.xfce4-cpugraph-plugin
    #xfce.xfce4-mailwatch-plugin
    #xfce.xfce4-systemload-plugin
    #xfce.xfce4-pulseaudio-plugin
    #xfce.xfce4-whiskermenu-plugin
    ##xfce.xfce4-hardware-monitor-plugin

    #xfce.xfce4-volumed-pulse
    #xfce.xfce4-terminal
    #xfce.xfce4-taskmanager
    #xfce.xfce4-settings
    #xfce.xfce4-screenshooter
    #xfce.xfce4-power-manager
    ##xfce.xfce4-panel-profiles
    #xfce.xfce4-panel
    #xfce.xfce4-notifyd
    #xfce.xfce4-icon-theme
    #xfce.xfce4-dict

    #---------------------------------------------------------------
    # Web browser
    #---------------------------------------------------------------

    lynx elinks w3m
    firefox chromium qutebrowser #flashplayer rambox
    floorp  # web browser, forked from firefox ?
    brave
    #midori surf epiphany
    #epiphany

    #---------------------------------------------------------------
    # E-mail Client
    #---------------------------------------------------------------

    neomutt # mutt

    #---------------------------------------------------------------
    # Instant Messenger
    #---------------------------------------------------------------

    telegram-desktop #tdesktop
    signal-desktop
    hexchat
    discord discord-ptb

    simplex-chat-desktop
    session-desktop

    briar-desktop

    #---------------------------------------------------------------
    # File Sharing and Download Manager, File transfer
    #---------------------------------------------------------------

    transmission_4-gtk
    rtorrent                            # An ncurses client for libtorrent, ideal for use with screen, tmux, or dtach
    qbittorrent                         # Featureful free software BitTorrent client
    rsync grsync zsync luckybackup      # remote file sync / backup
    rclone                              # Command line program to sync files and directories to and from major cloud storage
    #deluge                             # A lightweight, Free Software, cross-platform BitTorrent client
    deluge-gtk
    #deluged
    #vuze
    #torrenttools

    popcorntime                         # An application that streams movies and TV shows from torrents

    #---------------------------------------------------------------
    # File Manager, File viewer/reader
    #---------------------------------------------------------------

    filezilla

    #xfce.thunar
    xfe
    clipgrab
    #dfilemanager # File manager written in Qt/C++
    pcmanfm # File manager with GTK interface
    #nautilus
    index-fm # Multi-platform file manager
    worker # A two-pane file manager with advanced file manipulation features
    #keepnote
    #planner <-- removed from nixpkgs
    #gqview # 'gqview' has been removed due to lack of maintenance upstream and depending on gtk2. Consider using 'gthumb' instead
    enlightenment.ephoto
    gtkimageview
    gthumb
    eog                           # Gnome image viewer

    hakuneko                            # comic/manga/manhwa downloader/viewer
    #mcomix                             # Comic book reader and image viewer

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

    vifm-full vimPlugins.vifm-vim
    # vifm

    #mucommander    #<-- build failed?
    trash-cli

    sxiv
    feh
    evince                              # Documents viewer
    calibre                             # Comprehensive e-book software
    koodo-reader			# Cross-platform ebook reader
    bookworm				# Simple, focused eBook reader
    foliate				# Simple and modern GTK eBook reader
    alexandria				# A minimalistic cross-platform eBook reader
    koreader				# An ebook reader application supporting PDF, DjVu, EPUB, FB2 and many more formats, running on Cervantes, Kindle, Kobo, PocketBook and Android devices
    sioyek                              # A PDF viewer designed for research papers and technical books
    #qpdfview

    #---------------------------------------------------------------
    # tools to interact with android phone
    #---------------------------------------------------------------

    android-tools
    #android-studio         # Not all host need this software

    adbfs-rootless          # Mount Android phones on Linux with adb, no root required
    android-file-transfer   # Reliable MTP client with minimalistic UI
    adb-sync                # a tools to synchonise files between a PC and an Android devices using ADB (Android Debug Bridge)
    #gnirehtet

    abootimg                # a tools to manipulate android boot image
    imgpatchtools           # a tools to manipulate android OTA archives
    apktool                 # a tools to reverse engineering Android apk files
    #universal-android-debloater
    cargo-apk               # a tool for creating Android packages
    android-backup-extractor
    #ghost                   # Android post-exploitation flakework: that exploits the Android Debug Bridge (ADB) to remotely access the android device.


    #---------------------------------------------------------------
    # android emulator
    #---------------------------------------------------------------

    #anbox
    #genymotion

    #---------------------------------------------------------------
    # Media player
    #---------------------------------------------------------------

    vlc

    # mpv-with-scripts
    # Renamed to/replaced by
    mpv
    # or
    #mpv.override { scripts = [ mpvScripts.plugin-name ]; }

    smplayer
    enlightenment.rage

    #---------------------------------------------------------------
    # Desktop Application, Office Suit, Word Processor, Spreadsheet, Presentation, Graphic Editor, Video Editor, Audio Editor, ...
    #---------------------------------------------------------------

    jdk #openjdk

    #libreoffice
    #libreoffice-fresh
    #wpsoffice

    scribus

    #aseprite   # disabled because always need recompile, and usually not being use

    #gimp-with-plugins
    gimp

    drawing drawpile

    gnome-clocks
    gnome-calendar
    gnome-contacts
    gnome-font-viewer
    gnome-screenshot
    gnome-system-monitor
    totem
    #plots
    gnome-graphs # Simple, yet powerful tool that allows you to plot and manipulate your data with ease
    gnome-weather
    gnome-decoder         # Scan and Generate QR Codes

    elastic               # Design spring animations
    emblem                # Generate project icons and avatars from a symbolic icon
    eyedropper            # Pick and format colors
    #gaphor                # Simple modeling tool written in Python

    gephi                 # A platform for visualizing and manipulating large graphs
    #graphia               # A visualisation tool for the creation and analysis of graphs

    vym freemind treesheets dia minder drawio
    #ardour audacity avogadro dia freemind treesheets umlet vue xmind jmol
    #krita

    texlive.combined.scheme-full
    #texlive.combined.scheme-basic
    texmaker
    texstudio
    lyx
    tikzit
    pandoc
    tectonic

    #freecad
    #blender
    #librecad
    #sweethome3d.application sweethome3d.furniture-editor sweethome3d.textures-editor

    #alchemy lmms marvin mixxx mypaint
    cheese
    snapshot              # Take pictures and videos on your computer, tablet, or phone
    simplescreenrecorder #qt-recordmydesktop
    audio-recorder

    gramps

    #zathura

    #ghostwriter
    mindforger
    #notes-up

    #gnomeExtensions.draw-on-your-screen
    #pentablet-driver
    gromit-mpx  	# Desktop annotation tool
    #xournal     	# note-taking application (supposes stylus)
    xournalpp   	# handwriting notetaking software with PDF annotation support
    rnote       	# Simple drawing application to create handwritten notes
    pdftk       	# Command-line tool for working with PDFs
    #pdfchain   	#
    gnote               # A note taking application
    gnome-notes     	# Note editor designed to remain simple to use
    rednotebook		# Modern journal that includes a calendar navigation, customizable templates, export functionality and word clouds

    screenkey onboard xorg.xkbcomp # xorg.xkbprint


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
    deepin.deepin-calculator  # A easy to use calculator for ordinary users
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

    taskwarrior3 timewarrior
    taskwarrior-tui vit tasknc
    acpi

    libinput
    libinput-gestures

    #virtscreen

    #synergy synergyWithoutGUI
    barrier     # share keyboard & mouse; remote

    iosevka

    xsel

    graphviz-nox
    #zgrviewer
    kgraphviewer

    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.git-hub
    gitg

    #seaweedfs

    # XXX
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

  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmonad
      haskellPackages.xmonad-extras
      haskellPackages.xmonad-contrib

      haskellPackages.dbus
      haskellPackages.List
      haskellPackages.monad-logger
      haskellPackages.xmobar
    ];
  };
  #
  services.xserver.windowManager.awesome = {
    enable = true;
    #luaModules = [
      #pkgs.luaPackages.vicious
    #];
  };

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
