{
  config,
  pkgs,
  ...
}:
let
  # Personal Info
  name = "Muhammad Najib Bin Ibrahim";
  email = "mnajib@gmail.com";
  githubUsername = "mnajib";

  # Paths
  #dots = "/home/najib/Dotfiles/dotfiles";
  #scripts = "/home/najib/Dotfiles/scripts";
  #maildir = "/home/jon/Mail";

  # Preferences
  #font = "Droid Sans Mono Slashed"; # font-size=8 #"Hack"; # monospace #Monospace
  backgroundColor = "#102021";
  foregroundColor = "#f0f8ff";
  warningColor = "#fb0a66"; # "#e2313"; "#ffc0cb"
  #lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p -t";
  in
{
    nixpkgs.config = {
      allowUnfree = true;
      #firefox.enableAdobeFlash = false;
      pulseaudio = true;
    };

    home.packages = [
      #pkgs.htop
      pkgs.atop

      pkgs.gnome.gnome-disk-utility

      pkgs.fortune
      pkgs.mgba

      #pkgs.git
      pkgs.zeal               # Offline API documentation browser for software developers
      pkgs.broot              # something like tree command
      pkgs.exa                # can be alias to ls command

      pkgs.xorg.xdpyinfo
      pkgs.xorg.xwininfo
      pkgs.mc
      pkgs.ncdu               # Disc space usage analyzer
      pkgs.diskonaut          # Disk space usage analyzer
      pkgs.bc
      pkgs.rlwrap             # A readline wrapper
      pkgs.unzip
      pkgs.wget
      pkgs.gnupg
      pkgs.translate-shell    # CLI translator using Google Translate, Bing Translator, ...
      pkgs.whois
      pkgs.youtube-dl
      pkgs.coreutils

      pkgs.dzen2              # A general purpose messaging, notification and menuing program for X11

      #pkgs.kakoune
      #pkgs.neovim
      #pkgs.vim
      pkgs.yi
      pkgs.vis
      #pkgs.emacs

      # MIME related, xdg-utils
      pkgs.handlr

      pkgs.ranger
      #pkgs.nnn
      pkgs.broot

      #pkgs.termite
      pkgs.termonad
      pkgs.tmux
      pkgs.mosh

      pkgs.pavucontrol

      pkgs.libreoffice
      pkgs.wpsoffice
      pkgs.xournal
      pkgs.xournalpp
      pkgs.inkscape #pkgs.unstable.inkscape
      pkgs.gimp
      pkgs.imagemagick
      pkgs.pandoc
      pkgs.texlive.combined.scheme-tetex
      pkgs.ardour #pkgs.unstable.ardour
      pkgs.simplescreenrecorder
      pkgs.obs-studio

      pkgs.firefox
      pkgs.qutebrowser
      #pkgs.google-chrome
      #pkgs.chromium
      pkgs.brave #pkgs.unstable.brave # web browser
      pkgs.tuir #pkgs.rtv     # Browse Reddit from terminal

      #pkgs.tdesktop          # Telegram
      pkgs.qtox
      pkgs.zoom-us
      #pkgs.unstable.slack    # Desktop client for Slack
      pkgs.pass               # CLI password manager
      #pkgs.gitsi
      pkgs.vlc
      pkgs.shutter            # Screenshots
      pkgs.zathura            # Document viewer

      #pkgs.webtorrent_desktop

      pkgs.dropbox #pkgs.unstable.dropbox
      pkgs.wpa_supplicant_gui

      # electronic
      pkgs.qucs               # Integrated circuit simulator
      pkgs.ngspice            # The Next Generation Spice (Electronic Circuit Simulator)
      #pkgs.xcircuit          # Generic drawing program tailored to circuit diagrams
      pkgs.fritzing
      #pkgs.kicad

      #pkgs.graphviz
      #pkgs.graphviz-nox
      #pkgs.zgrviewer
      #pkgs.kgraphviewer
    ];

    #home.sessionVariables = {
    #  EDITOR = "nvim";       # yi vis nvim kak vim nano rasa jak
    #};

#------------------------------------------------------------------------------
    programs.rofi = {
      enable = true;
      #font = "${font} 8"; #9
      #theme = "~/.cache/wal/colors-rofi-dark-rasi";
    };

    programs.rofi.pass = {
      enable = true;
    };

    programs.urxvt = {
      enable = true;
    };

    programs.termite = {
      enable = true;
      #font = "${font} 5"; #8"; #9

      #foregroundColor = "";
      #foregroundBoldColor = "";
      #highlightColor = "";
      backgroundColor = "rgb(20, 20, 20)"; #rgba(63, 63, 63, 0.8); #"rgba(32, 39, 51, 0.3)";

      cursorShape = "block"; # "block" "underline" "ibeam"
      cursorBlink = "on";
      #cursorColor = "#dcdccc";
      #cursorForegroundColor = "";

      audibleBell = true;
      #scrollbar = [ "off" ];
    };

    # SessionPath and sessionVariables creates a hm-session file that must be sourced:
    # Beware, it puts it in .profile, not in the .bashrc!
    programs.bash = {
      enable = true;

      #shellOptions = [
      #];

      # Environment variable t...
      #sessionVariables = {
      #};

      shellAliases = {
        aoeu = "setxkbmap us";
        asdf = "setxkbmap dvorak";

        l = "ls -alhF";
        ll = "ls --color=tty -Filah";
        j = "jobs";
        s = "sync";
        emacs = "emacs -nw";
        la = "ls -Fa";
        p = "pwd";
        a = "alias";

        yi = "yi -k vim";
      };

      # Extra commands that should be run when initializing a login shell.
      # This will append to ~/.profile
      profileExtra = ''
        umask 0002
      '';

      # Extra commands that should be run when initializing an interactive shell.
      #initExtra = ''
      #  umask 0002
      #'';
      #initExtra = ''
      #  "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      #'';

      # Extra commands that should be placed in ~/.bashrc.
      # Note that these commands will be run even in non-interactive shells.
      bashrcExtra = ''
      umask 0002
      #. ~/.bashrc
      #eval "$(direnv hook bash)"
      '';

      #logoutExtra = ''
      #'';
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        aoeu = "setxkbmap us";
        asdf = "setxkbmap dvorak";

        l = "ls -alhF";
        ll = "ls --color=tty -Filah";
        j = "jobs";
        s = "sync";
        la = "ls -Fa";
        p = "pwd";
        a = "alias";

        emacs = "emacs -nw";
        yi = "yi -k vim";
      };
    };

    programs.direnv = {
      enable = true;
    };

    programs.command-not-found.enable = true;

    programs.nnn = {
      enable = true;
      extraPackages = with pkgs; [
        ffmpegthumbnailer
        mediainfo
        sxiv
      ];
      #plugins = {
      #...
      #};
    };

    programs.broot = {
      enable = true;
    };

    programs.htop = {
      enable = true;
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      # Use Nix Package search engine to find even more plugins:
      # https://search.nixos.org/packages
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        plenary-nvim
        gruvbox-material
        mini-nvim
      ];

      extraConfig = builtins.readFile ./src/.config/nvim/init.vim;
    };

    programs.vim = {
      enable = true;
      extraConfig = builtins.readFile ./src/vim/vimrc;
      settings = {
        relativenumber = true;
        number = true;
        #nowrap = true;
      };
      plugins = with pkgs.vimPlugins; [
        vim-elixir
        #vim-mix-format
        sensible
        vim-airline
        The_NERD_tree                      # file system explorer
        fugitive vim-gitgutter             # git
        rust-vim
        #YouCompleteMe
        vim-abolish
        command-t
        vim-go
      ];
    };

    #programs.yi = {
    #    ...
    #};

    #programs.clifm = {
    #};

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: [
        epkgs.nix-mode
        epkgs.magit
      ];
    };

    programs.kakoune = {
      enable = true;
      #tabStop = 4;
      #indentWidth = 4;
      #alignWithTabs = false;
      #ui.enableMouse = false;
      #showWhitespace.enable = true;
      #autoReload = [ "ask" ];
      #autoComplete = [ "prompt" ];
      #scrollOff.lines = 1;
      #scrollOff.columns = 1;
      extraConfig = builtins.readFile ./src/.config/kak/kakrc;
    };

    #programs.chromium = {
    #  enable = true;
    #};

    #programs.git = {
    #    enable = true;
    #    package = pkgs.gitAndTools.gitFull;
    #    userName =  "${name}"; #"Najib Ibrahim";
    #    userEmail = "${email}"; # "mnajib@gmail.com";
    #    aliases = {
    #        co = "checkout";
    #        ci = "commit";
    #        st = "status";
    #        br = "branch";
    #        #hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cr)' --graph --date=short --all";
    #        hist = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all";
    #        histp = "log --pretty=format:'%C(yellow)%h%Cred%d%Creset - %C(cyan)%an %Creset: %s %Cgreen(%cd)' --graph --date=short --all -p";
    #        type = "cat-file -t";
    #        dump = "cat-file -p";
    #        branchall = "branch -a -vv";
    #    }
    #    extraConfig = {
    #        core = {
    #            editor = "vim";
    #            excludesfile = "~/.gitignore";
    #            whitespace = "trailing-space,space-before-tab";
    #        };
    #        merge = {
    #            tool = "vimdiff";
    #        };
    #        color = {
    #            ui = "auto";
    #            diff = "auto";
    #            status = "auto";
    #            branch = "auto";
    #        };
    #    };
    #};

#------------------------------------------------------------------------------
    #xsession = {
    #    enable = true;
    #    #...
    #};

    # ~/.Xresources
    xresources.properties = {
      #"Xft.antialias" = 1;
      #"Xft.autohint" = 0;
      #"Xft.dpi" = 100; #120; #192;
      #"Xft.hinting" = 1;
      #"Xft.hintstyle" = "hintfull";
      #"Xft.lcdfilter" = "lcddefault";
      "Xcursor.theme" = "breeze_cursors";
      #"Xcursor.size" = 48;
    };
    #xresources.extraConfig = builtins.readFile ./src/.Xresources;
    #xresources.extraConfig = builtins.readFile ( pkgs.fetchFromGitHub {} + "./src/.Xresources");
    xresources.extraConfig = builtins.readFile (
      pkgs.fetchFromGitHub {
        owner = "solarized";
        repo = "xresources";
        rev = "025ceddbddf55f2eb4ab40b05889148aab9699fc";
        sha256 = "0lxv37gmh38y9d3l8nbnsm1mskcv10g3i83j0kac0a2qmypv1k9f";
      } + "/Xresources.dark"
    );

  gtk = {
    enable = true;
    theme = {
      #package = pkgs.arc-theme;
      #name = "Arc"; #"Arc-Dark"; "Arc-Darker" "Arc-Lighter"

      # murrine theme engine, orchis theme, tela icon
      #package = pkgs.orchis;
      #name = "Orchis";

      #package = pkgs.adwaita;
      name = "Adwaita";
    };
    iconTheme = {
      #package = pkgs.paper-icon-theme;
      #name = "Paper";

      #package = pkgs.tela-icon-theme;
      #name = "Tela";

      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    # Give Termite some internal spacing.
    #gtk3.extraCss = ".termite {padding: 20px;}";
  };

  qt = {
    enable = false;
    platformTheme = "gtk"; #"useGtkTheme = true;
  };

#------------------------------------------------------------------------------
  # Dotfiles for ~/.config, ~/.local/share, etc.
  #xdg = {
  #  enable = true;
  #};

#------------------------------------------------------------------------------
  # Dunst is a lightweight replacement for the notification daemons provided by most desktop environments.
  #services.dunst = {
  #    enable = true;
  #    ...
  #};

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  services.xscreensaver = {
    enable = true;
    settings = {
      mode = "random";
      lock = false;
      fadeTicks = 20;
    };
  };

  #services.screen-locker = {
  #    enable = true;
  #    lockCmd = $"{LockCmd}";
  #}

  #services.compton = {
  #    enable = true;
  #    blur = true;
  #    shadow = true;
  #};

  #services.kbfs.enable = true;
  #services.syncthing.enable = true;

  # Removable disk automounter for udisks
  services.udiskie = {
    enable = true;
  };

  # This will automatically install the lorri command.
  # Note: There's a known issue preventing the lorri daemon from starting automatically upon installation. Until it's resolved, you'll have to reload the user daemon by hand by running systemctl --user daemon-reload, or reboot.
  #services.lorri.enable = true;

#------------------------------------------------------------------------------
  #systemd.user.dropbox = {
  #systemd.user.services.dropbox = {
  #    Unit = {
  #        ...
  #    };
  #    Service = {
  #        ...
  #    };
  #    Install = {
  #        ...
  #    };
  #};

  #systemd.user.services.syndaemon = {
  #    ...
  #};

  #systemd.user.services.fetchmail = {
  #    ...
  #};

  #systemd.user.timers.fetchmail = {
  #    ...
  #};

  #systemd.user.syncmail = {
  #};

  #systemd.user.timer = {
  #}

  #----------------------------------------------------------------------------
  home.file = {

    #".config/termite/config".source = ./termite.config;

    ".tmux.conf" = {
      text = ''
        #set-option -g default-shell /run/current-system/sw/bin/fish # bash
        set-window-option -g mode-keys vi
        set -g default-terminal "screen-256color"
        set -ga terminal-overrides ',screen-256color:Tc'

        #set timeoutlen=1000 # Defalut 1000
        set ttimeoutlen=50 # Default 50
        #
        #set -g escape-time 10
        set -sg escape-time 10

        set -g clock-mode-style 24
        set -g history-limit 10000
      '';
    };

    #".config/fish/config.fish" = {
    #    text = ''
    #    set -x GPG_TTY (tty)
    #    gpg-connect-agent updatestartuptty /bye > /dev/null
    #    set -x SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gnupg/S.gpg-agent.ssh
    #    set -x EDITOR vim
    #    set -x TERM xterm-256color
    #    if status --is-interactive
    #        set -g fish_user_abbreviations
    #        abbr h 'home-manager switch'
    #        abbr r 'sudo nixos-rebuild switch'
    #        abbr gvim vim -g
    #        abbr mc 'env TERM=linux mc'
    #        abbr tmux 'tmux -2'
    #    end
    #    function __fish_command_not_found_handler --on-event fish_command_not_found
    #        command-not-found $argv[1]
    #    end
    #    '';
    #};

    #".profile".source = src/.profile;

    #".Xdefaults".source = src/.Xdefaults;

    #".config/kak" = {
    #    source = ./src/.config/kak;
    #    recursive = true;
    #};

    ".config/ranger" = {
      source = ./src/.config/ranger;
      recursive = true;
    };

    #".config/git" = {
      #source = ./src/.config/git;
      #recursive = true;
    #};
    ".gitconfig" = {
        source = ./src/.gitconfig;
    };

    #".config/awesome" = {
    #    source = ./src/.config/awesome;
    #    recursive = true;
    #};

    #".config/awesome/lain".source = fetchFromGitHub {
    #    owner = "lcpz";
    #    repo = "lain";
    #    rev = "9477093";
    #    sha256 = "0rfzf93b2v22iqsv84x76dy7h5rbkxqi4yy2ycmcgik4qb0crddp";
    #};

    #"./bin".source = fetchFromGitHub { #fetchGit {
    #    owner = "mnajib";
    #    repo = "home-manager-conf";
    #};
    #"./bin".source = fetchGit {
    #    url = "ssh://najib@mahirah:22/home/najib/GitRepos/bin.git";
    #    ...
    #};

    #".fonts" = {
    #    source = ./src/.fonts;
    #    recursive = true;
    #};

  };

  #------------------------------------------------------------------------------
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  #home.stateVersion = "21.11";
  #home.stateVersion = "21.05";
  home.stateVersion = "22.11";
}
