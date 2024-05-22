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
  #boot.kernelModules = [ "snd-ctxfi" "snd-ca0106" "snd-hda-intel" ];
  #boot.kernelParams = [ "nomodeset" "i915.modeset=0" ];

  #Bboot.loader.grub.useOSProber = true;
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.grub.splashImage = ./grub-background-najibbox.png;

  # XXX: move to host spesific (eg.: host-asmak.nix)
  #boot.supportedFilesystems =        [ "ext4" "zfs" "btrfs" "xfs" ]; # "bcachefs"
  #boot.initrd.supportedFilesystems = [ "ext4" "zfs" "btrfs" "xfs" ];

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

  #boot.loader.grub.copyKernels = true;  # To avoid boot error "external pointer tables not supported" when the number of hardlinks in the nix store gets very high.
  #services.zfs.autoScrub.enable = true; # Regular scrubbing of ZFS pools is recommended

  #services.fstrim.enable = true; # utk trim SSD
  # no access time and continuous TRIM for SSD
  #fileSystems."/".options = [ "noatime" "discard" ];

  #boot.kernelPackages = pkgs.linuxPackages_latest; # XXX: Move this configuration seperate from each host.
  hardware.enableAllFirmware = true;

  networking.networkmanager.enable = true; # <-- will move to host specifix file

  #nix.trustedUsers = [ "root" "najib" ]; <-- moved to host-hostname.nix

  # Binary Cache for Haskell.nix
  nix.settings.trusted-public-keys = [
    "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
  ];
  nix.settings.substituters = [
    "https://cache.iog.io"
  ];

  #nix.daemonIONiceLevel = 7;
  nix.daemonIOSchedPriority = 7; # 0(high) (default) ... 7 (low) priority
  #nix.daemonNiceLevel = 19;
  nix.daemonCPUSchedPolicy = "idle";
  nix.daemonIOSchedClass = "idle";

  imports = [
    ./users-najib.nix
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
    LC_TIME = "en_GB.UTF-8";
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  #
  environment.systemPackages = with pkgs; [
    cachix

    #unstable.minetest
    #unstable.google-chrome
    google-chrome

    gptfdisk efibootmgr btrfs-progs btrbk #bcachefs-tools
    gsmartcontrol smartmontools
    #lizardfs                 # marked as broken?
    wget curl killall
    mtr iproute # busybox
    htop mc irssi most mosh coreutils mutt
    nload
    zenith                    # Sort of like top or htop but with zoom-able charts, network, and disk usage
    bmon                      # Network bandwidth monitor
    btop
    enlightenment.evisum

    screen
    tmux
    dtach
    byobu
    zellij

    xpra
    run-scaled

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
    gnupg
    xorg.xmodmap

    ghostscript

    geteltorito woeusb #k3b
    ventoy-bin

    #stack

    #ripgrep
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

    dzen2    # A general purpose messaging, notification and menuing program for X11
    gnumake    # install gnumake, needed for ihp

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

    qtox    # chat using tox protocol
    #keybase keybase-gui

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

    gnome.gnome-clocks

    screenkey onboard xorg.xkbcomp # xorg.xkbprint

    qemu qemu_kvm qemu-utils
    qemu_full
    virt-viewer
    libvirt virt-manager bridge-utils vde2 # virtmanager virt-manager-qt
    #virtualbox
    ethtool

    adwaita-qt
    gnome3.adwaita-icon-theme

    niv

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

    taskwarrior timewarrior
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
    emacs # emacs-nox
    #vscode
    leafpad notepadqq geany      # kate
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
    gnome.file-roller           # Archive manager for the GNOME desktop environment

    #---------------------------------------------------------------
    # Games
    #---------------------------------------------------------------
    gnome.gnome-chess
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
    hardinfo
    lshw
    hwinfo
    neofetch
    acpi
    libinput
    libinput-gestures
    alsaUtils
    partclone           # Utilities to save and restore used blocks on a partition

    diskonaut           # a terminal disk space navigator
    duf
    diskus
    dfc
    btdu                # sampling disk usage profiler for btrfs
    gdu                 # Disk usage analyzer with console interface
    godu                #
    ncdu                # Disk usage analyzer with an ncurses interface
    dua                 # A tool to conveniently learn about the disk usage of directories, fast! View disk space usage and delete unwanted data, fast. 
    dutree
    du-dust #dust
    duc                 # Collection of tools for inspecting and visualizing disk usage
    gdmap
    baobab              # Graphical application to analyse disk usage in any GNOME environment
    k4dirstat           # A small utility program that sums up disk usage for directory trees
    qdirstat
    jdiskreport
    gnome.gnome-disk-utility      # A udisks graphical front-end

    gnome.gnome-logs    # A log viewer for the systemd journal

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

    gnome3.simple-scan
    gnomeExtensions.appindicator
    gnomeExtensions.cpufreq

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

    mutt

    #---------------------------------------------------------------
    # Instant Messenger
    #---------------------------------------------------------------

    tdesktop
    signal-desktop
    hexchat
    discord discord-ptb

    #---------------------------------------------------------------
    # File Sharing and Download Manager, File transfer
    #---------------------------------------------------------------

    transmission-gtk
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
    #gnome.nautilus
    index-fm # Multi-platform file manager
    worker # A two-pane file manager with advanced file manipulation features
    #keepnote
    #planner <-- removed from nixpkgs
    gqview
    enlightenment.ephoto
    gtkimageview
    gthumb
    gnome.eog                           # Gnome image viewer

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

    libreoffice
    #libreoffice-fresh
    #wpsoffice

    scribus

    #aseprite   # disabled because always need recompile, and usually not being use

    #gimp-with-plugins
    gimp

    drawing drawpile

    gnome.gnome-clocks
    gnome.gnome-calendar
    gnome.gnome-contacts
    gnome.gnome-font-viewer
    gnome.gnome-screenshot
    gnome.gnome-system-monitor
    gnome.totem
    plots
    gnome.gnome-weather
    gnome-decoder         # Scan and Generate QR Codes

    elastic               # Design spring animations
    emblem                # Generate project icons and avatars from a symbolic icon
    eyedropper            # Pick and format colors
    #gaphor                # Simple modeling tool written in Python

    gephi                 # A platform for visualizing and manipulating large graphs
    #graphia               # A visualisation tool for the creation and analysis of graphs

    vym freemind treesheets drawio dia minder
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
    gnome.cheese
    snapshot              # Take pictures and videos on your computer, tablet, or phone
    simplescreenrecorder #qt-recordmydesktop
    audio-recorder

    gramps

    #zathura
    ghostwriter mindforger #notes-up

    #gnomeExtensions.draw-on-your-screen
    #pentablet-driver
    gromit-mpx  # Desktop annotation tool
    #xournal     # note-taking application (supposes stylus)
    xournalpp   # handwriting notetaking software with PDF annotation support
    rnote       # Simple drawing application to create handwritten notes
    pdftk       # Command-line tool for working with PDFs
    #pdfchain   #
    gnote                 # A note taking application
    gnome.gnome-notes     # Note editor designed to remain simple to use

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
    qtox        # chat using tox protocol
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
    gnome.gnome-calculator
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
    gnome3.adwaita-icon-theme

    niv

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

    taskwarrior timewarrior
    taskwarrior-tui vit tasknc
    acpi

    libinput
    libinput-gestures
    alsaUtils

    oneko xcape find-cursor #gnomeExtensions.jiggle hlcursors
    #virtscreen

    #synergy synergyWithoutGUI
    barrier     # share keyboard & mouse; remote

    diskonaut   # a terminal disk space navigator

    iosevka

    xsel

    graphviz-nox
    #zgrviewer
    kgraphviewer

    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.git-hub
    gitg

    seaweedfs

    # XXX
    maven
    edid-decode
    javaCup
    javacc
    jetty
    mono
    samba
    steam-run
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
    jitsi-meet

    # GAMES
    #teeworlds
    #minecraft-launcher
    #minecraft-server
    #openttd
  ];

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
  services.openssh.enable = true;
  services.openssh.settings.X11Forwarding = true;
  #services.openssh.ports= [ 7177 ];
  services.sshguard.enable = true;

  #services.toxvpn.enable = true;

  documentation.nixos.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ 3450 ]; # 3450 for minetest server
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #services.syncthing = {
  #  enable = false; # currently not using handphone
  #  user = "najib";
  #  dataDir = "/home/najib/.config/syncthing";
  #};

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ]; # [ pkgs.hplipWithPlugin ];

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  #hardware.opengl.extraPackages = with pkgs.
  #hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  #hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl ];
  #hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau intel-ocl mesa.drivers ];
  hardware.opengl.extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau mesa.drivers ]; # intel-ocl cannot be downloaded source from any mirror
  #hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva  ];
  #hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva vaapiIntel libvdpau-va-gl vaapiVdpau ];

  hardware.cpu.intel.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

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

  services.xserver.enable = true;
  #services.xserver.xautolock.enable = true;

  # Keyboard: setxkbmap -layout us,us,ara,my -variant dvorak,,,
  #
  #services.xserver.layout = "us";
  #services.xserver.xkbVariant = "dvorak";
  #
  #services.xserver.layout = "us,us";
  #services.xserver.xkbVariant = "dvorak,";
  #
  #services.xserver.layout = "us,us,ara,my";
  #services.xserver.xkbVariant = "dvorak,,,";
  #
  #services.xserver.layout = "us,us,ara,msa";
  #services.xserver.xkbVariant = "dvorak,,,";
  #
  #services.xserver.layout = "us,us,ara";
  #services.xserver.xkbVariant = "dvorak,,";

  #
  #
  # You can find valid values for these options in
  #   $(nix-build --no-out-link '<nixpkgs>' -A xkeyboard_config)/etc/X11/xkb/rules/base.lst

  #services.xserver.xkbOptions = "grp:shift_caps_toggle";

  #services.xserver.exportConfiguration = true;
  #services.xserver.extraLayouts.msa = { # msa ? myjawi?
    #description = "Jawi SIRIM Malaysia";
    #languages = [ "msa" ]; # msa, may, ms. https://en.wikipedia.org/wiki/List_of_ISO_639-2_codes
    #layoutFile = builtins.toFile "myjawi.xkb" ''
    #  xkb_keymap {
    #    xkb_keycodes { include "evdev+aliases(qwerty)" };
    #    xkb_types { include "complete" };
    #    xkb_compatibility { include "complete" };
    #    //xkb_symbols "pc+msa(jawisirim)+inet(evdev)+group(shift_caps_toggle)" {
    #    xkb_symbols "basic" {
    #
    #    };
    #    xkb_geometry { include "pc(pc101)" };
    #  };
    #'';
    #keycodesFile = ./xkb/keycodes/msa;   #
    #typesFile = ./xkb/types/msa;         #
    #compatFile = ./xkb/compat/msa;       #
    #symbolsFile = ./xkb/symbols/msa;     # xkb_symbols: The main section that defines what each key does.
    #geometryFile = ./xkb/geometry/msa;   # xkb_geometry: A completely irrelevant section describing physical keyboard layout. Can be deleted without any consequences.
  #};

  #let
  #  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
  #    ${pkgs.xorg.xkbcomp}/bin/xkbcomp ${/etc/nixos/najibkeyboardlayout.xkb} $out
  #    '';
  #in
  #  service.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${compiledLayout} $DISPLAY";
  #
  # Tested and working good!
  #services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp ${/etc/nixos/najibkeyboardlayout.xkb} $DISPLAY";

  # Touchpad
  #services.xserver.libinput.enable = true;
  #services.xserver.libinput.scrollMethod = "edge"; #"twofinger"; #"edge";
  #services.xserver.libinput.disableWhileTyping = true;

  #services.xserver.libinput.tapping = false;
  # Default is 'true', but usually I will set 'false'.
  # Need tapping for 'asmak' because touchpad left-button (hardware) is mulfucntion.
  # OR as alternative for 'asmak', I can use command
  #     xinput list
  #     xinput list-props "..."
  #     xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Tap Action" 0
  # OR
  #     just attach an USB mouse
  #
  #lib.mkIf (config.networking.hostName == "aisyah"){
    #services.xserver.libinput.scrollMethod = "twofinger";
    #services.xserver.libinput.tapping = true;
  #}; else
    ##services.xserver.libinput.tapping = false;
    #
    #services.xserver.libinput = lib.mkIf (config.networking.hostname == "asmak") {
      ##if networking.hostName == "asmak" then
        #tapping = true
      ##else
      ##tapping = false;
  #};

  # Trackpoint
  #hardware.trackpoint.sensitivity = 97; # default 97
  #hardware.trackpoint.speed = 100; # default 128
  #hardware.trackpoint.emulateWheel = true;

  # Fingerprint reader
  # Note: fprintd-enroll
  #services.fprintd.enable = true;

  # Moved to separate file: hardware-tablet-opentabletdriver.nix, ...
  ##services.xserver.digimend.enable = true;
  #services.xserver.wacom.enable = true;
  ##hardware.opentabletdriver.enable = true;


  # --------------------------------------------------------------
  # Display Manager
  # --------------------------------------------------------------
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.startx.enable = true;
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.displayManager.xpra.enable = true;

  # --------------------------------------------------------------
  # Desktop Manager
  # --------------------------------------------------------------
  services.xserver.desktopManager.xterm.enable = false;
  #services.xserver.desktopManager.plasma5 = {
  #  enable = true;
  #  #extraPackages = [
  #  #  kate
  #  #];
  #};
  #
  #services.xserver.desktopManager.plasma5.enable = true;
  #services.xserver.desktopManager.gnome.enable = true; # .gnome3.enable
  #services.xserver.desktopManager.mate.enable = true;
  #services.xserver.desktopManager.enlightenment.enable = true;
  #services.xserver.desktopManager.xfce = {
    #enable = true;

    # to make xfce workt with xmonad
    #noDesktop = true;
    #enableXfwm = false;
  #};
  #services.xserver.desktopManager.lxqt.enable = true;
  #services.xserver.desktopManager.pantheon.enable = true;
  #services.xserver.desktopManager.cinnamon.enable = true;
  #services.xserver.desktopManager.kodi = {
  #   enable = false;
  #};
  #services.xserver.desktopManager.lumina.enable = true;

  # --------------------------------------------------------------
  # Default Desktop Manager
  # --------------------------------------------------------------
  #services.xserver.displayManager.defaultSession = "none+xmonad";
  #services.xserver.desktopManager.default = "plasma5";

  # --------------------------------------------------------------
  # Window Manager
  # --------------------------------------------------------------
  #services.xserver.windowManager.jwm.enable = true;
  #services.xserver.windowManager.windowmaker.enable = true;
  #services.xserver.windowManager.dwm.enable = true;
  ##services.xserver.windowManager.twm.enable = true;
  #services.xserver.windowManager.icewm.enable = true;
  #services.xserver.windowManager.i3.enable = true;
  #services.xserver.windowManager.herbstluftwm.enable = true;
  #services.xserver.windowManager.fluxbox.enable = true;
  #services.xserver.windowManager.qtile.enable = true;
  #services.xserver.windowManager.sawfish.enable = true;
  #services.dwm-status.enable = true;
  #
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
  #==================================================
  # This is working solution as tested on
  # 2022-11-07
  # 2023-04-05
  #--------------------------------------------------
  # fc-list -v | grep -i edward
  # ln -s ~/.fonts ~/.local/share/fonts
  # rm -vRf ~/.cache/fontconfig
  # fc-cache --really-force --verbose
  # fc-list -v | grep -i edward
  #==================================================
  #
  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;              # Create a directiry with links to all fonts in /run/current-system/sw/share/X11/fonts

    # System-wide default font(s). Multiple fonts may be listed in case multiple languages must be supported.
    #fontconfig.defaultFonts.serif = [ "DejaVu Serif" ];
    #fontconfig.defaultFonts.emoji = [ "Noto Color Emoji" ];
    #fontconfig.defaultFonts.sansSerif = [ "DejaVu Sans" ];
    #fontconfig.defaultFonts.monospace = [ "DejaVu Sans Mono" ]; # "jetbrains mono"
    fontconfig.defaultFonts.monospace = [
      "Fira Mono for Powerline (Bold)"
      "DejaVu Sans Mono"
      "jetbrains mono"
    ];

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
      noto-fonts-cjk
      noto-fonts-emoji
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

      nerdfonts
      #(nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ] })

      jetbrains-mono # An opensource typeface made for developers. suitable for coding
      mononoki # A font for programming and code review
    ];
  };

  #system.copySystemConfiguration = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  #system.stateVersion = "16.09";
  #system.stateVersion = "17.03";
  #system.stateVersion = "17.09";
  #system.stateVersion = "18.03";
  #system.stateVersion = "18.09";
  #system.stateVersion = "19.03";
  #system.stateVersion = "19.09";
  #system.stateVersion = "20.03";
  #system.stateVersion = "20.09";
  #system.stateVersion = "22.05";
  #system.stateVersion = "22.11";
  #
  # XXX: Move this config into host specifix file.
}
# vim: nowrap:ts=8
