
# TODO:
#   This file will be rename from common.nix to common-configs.nix
#   Packages will be separated into common-packages.nix

{
  config,
  pkgs,
  inputs,
  lib,
  outputs,
  ...
}:
let
  # XXX: TODO: Should be placed in user specific file

  # Personal Info
  #name = "Muhammad Najib Bin Ibrahim";
  #email = "mnajib@gmail.com";
  #githubUsername = "mnajib";

  # Paths
  #dots = "/home/najib/Dotfiles/dotfiles";
  #scripts = "/home/najib/Dotfiles/scripts";
  #maildir = "/home/jon/Mail";

  # Preferences
  #font = "Droid Sans Mono Slashed"; # font-size=8 #"Hack"; # monospace #Monospace
  #backgroundColor = "#102021";
  #foregroundColor = "#f0f8ff";
  #warningColor = "#fb0a66"; # "#e2313"; "#ffc0cb"
  #lockCmd = "${pkgs.i3lock-fancy}/bin/i3lock-fancy -p -t";

  colorScheme = {
    slug = "najib";
    name = "Najib";
    author = "Najib Ibrahim (https://github.com/mnajib)";
    palette = {
      base00 = "#000000";
      base01 = "#c7002e";
      base02 = "#009200";
      base03 = "#aa8800";
      base04 = "#2278e6";
      base05 = "#aa00d4";
      base06 = "#01b5b5";
      base07 = "#afafaf";
      base08 = "#4b4b4b";
      base09 = "#fe5748";
      base0A = "#00d700";
      base0B = "#ffee00";
      base0C = "#67a2ee";
      base0D = "#c64ed7";
      base0E = "#45fdfd";
      base0F = "#ffffff";
    };
  };
  inherit (inputs.nix-colors) colorSchemes;
  #
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) colorschemeFromPicture nixWallpaperFromScheme;
in
{
  # XXX: TODO: Better if not import here; but import from user specific file
  imports = [
    inputs.nix-colors.homeManagerModule
    ./screen.nix
    ./tmux.nix
    ./rofi.nix

    #./nvim/lsp.nix
    #./nvim
    #./neovim # lets put this per-user, so disable neovim here
    ./neovide

    ./zsh.nix
    ./bash.nix # bash shell
    ./garbage-collect.nix

    ./git.nix
  ]
  ++ (builtins.attrValues outputs.homeManagerModules);
  # XXX: TODO: Should be in seperate file packages.nix

  nixpkgs.overlays = builtins.attrValues outputs.overlays;
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [
      #"nix-2.15.3"
      #"electron-25.9.0"
    ];
    #firefox.enableAdobeFlash = false;
    pulseaudio = true;
  };

  #colorscheme = lib.mkDefault colorSchemes.dracula;
  #colorscheme = lib.mkDefault colorSchemes.nord;
  #colorscheme = lib.mkDefault colorSchemes.najib;
  colorscheme = lib.mkDefault colorScheme;

  #home.sessionVariables = {
    #EDITOR = "nvim";       # yi vis nvim kak vim nano rasa jak
    #XDG_CONFIG_HOME = "$HOME/.config";
    #XDG_DATA_HOME = "$HOME/var/lib";
    #XDG_CACHE_HOME = "$HOME/var/cache";
  #};

#------------------------------------------------------------------------------
  #programs.rofi = {
  #  enable = true;
  #  #font = "${font} 8"; #9
  #  #theme = "~/.cache/wal/colors-rofi-dark-rasi";
  #};

  #programs.rofi.pass = {
  #  enable = true;
  #};

  programs.java = {
    enable = true;
    #package = "pkgs.jdk";
  };

  programs.kitty = {
    enable = true;
    #theme = "Space Gray Eighties";

    #font = {
      #package = pkgs.dejavu_fonts;
      #package = pkgs.jetbrains-mono;
      #name = "DejaVu Sans";
      #size = "12"; #"13"; # "8";
    #};

    font = {
      name = "Hack Nerd Font";  # Ensure Nerd Fonts are installed
      size = 8.0;
    };

    settings = {
      #background = "#${config.colorScheme.palette.base00}";
      #foreground = "#${config.colorScheme.palette.base05}";

      #window_padding_width = 15;
      foreground = "#${colors.base05}";
      background = "#${colors.base00}";
      selection_background = "#${colors.base05}";
      selection_foreground = "#${colors.base00}";
      url_color = "#${colors.base04}";
      cursor = "#${colors.base05}";
      active_border_color = "#${colors.base03}";
      inactive_border_color = "#${colors.base01}";
      active_tab_background = "#${colors.base00}";
      active_tab_foreground = "#${colors.base05}";
      inactive_tab_background = "#${colors.base01}";
      inactive_tab_foreground = "#${colors.base04}";
      tab_bar_background = "#${colors.base01}";
      color0 = "#${colors.base00}";
      color1 = "#${colors.base08}";
      color2 = "#${colors.base0B}";
      color3 = "#${colors.base0A}";
      color4 = "#${colors.base0D}";
      color5 = "#${colors.base0E}";
      color6 = "#${colors.base0C}";
      color7 = "#${colors.base05}";
      color8 = "#${colors.base03}";
      color9 = "#${colors.base08}";
      color10 = "#${colors.base0B}";
      color11 = "#${colors.base0A}";
      color12 = "#${colors.base0D}";
      color13 = "#${colors.base0E}";
      color14 = "#${colors.base0C}";
      color15 = "#${colors.base07}";
      color16 = "#${colors.base09}";
      color17 = "#${colors.base0F}";
      color18 = "#${colors.base01}";
      color19 = "#${colors.base02}";
      color20 = "#${colors.base04}";
      color21 = "#${colors.base06}";

      #cursor = "#cccccc";
      #cursor_text_color = "#111111";
      cursor_shape = "block"; # "beam"
      cursor_blink_interval = 1;
      cursor_stop_blinking_after = 0;

      scrollback_lines = 10000;
      enable_audio_bell = true;
      update_check_interval = 0;

      disable_ligatures = "always";  # Avoid ambiguous glyphs
      adjust_line_height = "90%";     # Compensate for small fonts
    };

    #environment = {
      #"LS_COLORS" = "1";
    #};
  };

  programs.qutebrowser = {
    enable = true;
    settings = {
      colors = {
        hints = {
          bg = "#${config.colorScheme.palette.base00}";
          fg = "#${config.colorScheme.palette.base0F}";
        };
        tabs.bar = {
          bg = "#${config.colorScheme.palette.base00}";
        };
      };
      #tabs.tabs_are_windows = true;
    };
    #colors = {
    #  # Becomes either 'dark' or 'light', based on your colors!
    #  webppage.preferred_color_scheme = "${config.colorScheme.kind}";
    #  tabs.bar.bg = "#${config.colorScheme.colors.base00}";
    #  keyhint.fg = "#${config.colorScheme.colors.base05}";
    #};

    #extraConfig = builtins.readFile ./src/.config/nvim/init.vim;

      #c.colors.webpage.darkmode.grayscale.images = 0.35
      #c.content.user_stylesheets = '~/.config/qutebrowser/stylesheet/mydarkmodefix.css'
    #extraConfig = ''
    #  c.colors.webpage.preferred_color_scheme = 'dark'
    #  c.colors.webpage.darkmode.enabled = True
    #  c.colors.webpage.darkmode.algorithm = 'lightness-hsl'
    #  c.colors.webpage.darkmode.contrast = -.022
    #  c.colors.webpage.darkmode.threshold.foreground = 150
    #  c.colors.webpage.darkmode.threshold.background = 100
    #  c.colors.webpage.darkmode.policy.images = 'never'
    #  c.content.notifications.enabled = False
    #'';
  };
  #home.file.".config/qutebrowser/stylesheet/mydarkmodefix.css" = {
  #home.file."mydarkmodefix.css" = {
  home.file.".config/qutebrowser" = {
    enable = true;
    #text = ''
    #'';
    #source = ./src/.config/qutebrowser/stylesheet/mydarkmodefix.css;
    source = ./src/.config/qutebrowser;
    #source = src/.Xresources.d;
    recursive = true;
    #target = ".config/qutebrowser/stylesheet/mydarkmodefix.css"; # Path to target file relative to HOME
    #target = ~/.config/qutebrowser/stylesheet/mydarkmodefix.css; # Path to target file relative to HOME
    #target = "~.config/qutebrowser/stylesheet/mydarkmodefix.css"; # Path to target file relative to HOME
    target = "~.config/qutebrowser"; # Path to target file relative to HOME
    #target = ".config/qutebrowser/stylesheet/"; # Path to target file relative to HOME
  };
  #xresources.extraConfig = builtins.readFile ./src/.Xresources;

  programs.urxvt = {
    enable = true;
  };

  #programs.wezterm = {
  #  enable = true;
  #  #package = pkgs.wezterm;
  #  #colorSchemes = { ... };
  #  #extraConfig = ''
  #  #'';
  #};

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

  #programs.tmux = {
  #  enable = true;
  #  #packages =
  #};

  programs.fish = {
    enable = true;

    shellAliases = {
      aoeu = "setxkbmap us";
      asdf = "setxkbmap dvorak";
      oeu = "loadkeys us";
      sdf = "loadkeys dvorak";

      #ls = "exa -g --git --time-style long-iso";
      l = "ls -alhF";
      #ll = "ls --color=tty -Filah";
      ll = "ls -Filah";
      la = "ls -Fa";
      j = "jobs";
      s = "sync";
      p = "pwd";
      a = "alias";

      #emacs = "emacs -nw";
      yi = "yi -k vim";
    };

    # Shell script code called during interactive fish shell initialisation.
    interactiveShellInit = ''
      #colorscript random
    '';

    # Shell script code called during fish shell initialisation.
    shellInit = ''
      #colorscript random
    '';

    # Shell script code called during fish login shell initialisation.
    loginShellInit = ''
      #colorscript random
    '';

    #plugin.
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      #enableFlakes = true;
    };
  };

  programs.command-not-found.enable = true;

  programs.fd.enable = true; # A faster alternative to 'find'

  programs.bat.enable = true; # For file previews

  programs.ranger = {
    enable = true; # A terminal 'file manager'.
    #extraPackages =
    #extraPlugins =
    extraConfig = ''
      set column_ratios 0,1,1
      #set mouse_enabled false
      set collapse_preview false
      set sort_directories_first false

      set preview_directories true
      set preview_files false
      set perview_images false

      # 'uv' as shortcut to unmark all in all directories
      # as command 'unmark' only unmarks marked files in the current directory.
      map uv mark_files all=True val=False

      # Color schemes
      #Ranger comes with four color schemes: default, jungle, snow and solarized. You can change your color scheme using:
      set colorscheme solarized

      # Move to trash
      map DD shell mv %s /home/$${USER}/.local/share/Trash/files/
      #
      # Alternatively, use GIO commandline tool provided by glib2 package:
      #map DD shell gio trash %s
    '';
  };
  #home.file.".config/ranger" = {
  #  source = ./src/.config/ranger;
  #  recursive = true;
  #};

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

  programs.info.enable = true;

  #programs.exa = {
  #programs.eza = {
  #  enable = true;
  #  #enableAliases = true;
  #};

  programs.dircolors.enable = true;

  programs.fzf = {
    enable = true;           # fuzzy finder
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;

    tmux.enableShellIntegration = true;
  };
  #
  programs.skim.enable = true;          # fuzzy finder

# programs.neovim = {
#   enable = true;
#   defaultEditor = true;
#   #viAlias = true;
#   #vimAlias = true;
#   #vimdiffAlias = true;
#
#   # Use Nix Package search engine to find even more plugins:
#   # https://search.nixos.org/packages
#   plugins = with pkgs.vimPlugins; [
#     ##nvim-lspconfig
#     #nvim-treesitter.withAllGrammars
#     #plenary-nvim
#     #gruvbox-material
#     #mini-nvim
#     #nvim-tree-lua
#     #vim-illuminate
#     #vim-numbertoggle
#
#     #{
#     #plugin = vim-startify;
#     #config = "let g:startify_change_to_vcs_root = 0";
#     #}
#
#   ];
#
#   extraConfig = builtins.readFile ./src/.config/nvim/init.vim;
# };

# programs.vim = {
#   enable = true;
#   extraConfig = builtins.readFile ./src/vim/vimrc;
#   settings = {
#     relativenumber = true;
#     number = true;
#     #nowrap = true;
#   };
#   plugins = with pkgs.vimPlugins; [
#     vim-elixir
#     #vim-mix-format
#     sensible
#     vim-airline
#     The_NERD_tree                      # file system explorer
#     fugitive vim-gitgutter             # git
#     rust-vim
#     #YouCompleteMe
#     vim-abolish
#     command-t
#     vim-go
#   ];
# };

  #programs.yi = {
  #    ...
  #};

  #programs.clifm = {
  #};

  #programs.emacs = {
  #  enable = true;
  #  extraPackages = epkgs: [
  #    epkgs.nix-mode
  #    epkgs.magit
  #  ];
  #};

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


#------------------------------------------------------------------------------
  #wayland.windowManager.sway = {
  #  enable = true;
  #  config = {
  #    input = {
  #      "*" = {
  #        xkb_layout = "us";
  #        xkb_variant = "dvorak";
  #      };
  #    };
  #  };
  #};

  #xsession = {
  #    enable = true;
  #    #...
  #};

  # ~/.Xresources
  # Note:
  #   hex codes (#rrggbb) are used by your terminal emulator,
  #   while escape codes (\033[x;3xm) are used by your shell.
  #   Terminal emulators and shells are two dinstinct programs.
  #
  #   When you input printf "\033[1;31mRED\033[0m\n" printf in your shell
  #   (eg, bash), the shell reads "Hey I want to print "RED" using the
  #   foreground color 1 in bold. That's all it does.
  #   The terminal emulator then interprets it as "Okay, so the shell wants
  #   color 1 in bold. By my config file, I see that the corresponding hex code
  #   is #a42331, so there you go shell".
  #
  #   Your terminal can display 256 different colors, but your shell can only
  #   use 16 at the same time. (Though there are ways to output those 256 colors
  #   to stdout. Vim can use them all for example).
  #xresources.properties = {
    #"Xft.antialias" = 1;
    #"Xft.autohint" = 0;
    #"Xft.dpi" = 100; #120; #192;
    #"Xft.hinting" = 1;
    #"Xft.hintstyle" = "hintfull";
    #"Xft.lcdfilter" = "lcddefault";
    #"Xcursor.theme" = "breeze_cursors";
    #"Xcursor.size" = 48;
  #};
  #
  #xresources.extraConfig = builtins.readFile ( pkgs.fetchFromGitHub {} + "./src/.Xresources");
  #xresources.extraConfig = builtins.readFile (
  #  pkgs.fetchFromGitHub {
  #    owner = "solarized";
  #    repo = "xresources";
  #    rev = "025ceddbddf55f2eb4ab40b05889148aab9699fc";
  #    sha256 = "0lxv37gmh38y9d3l8nbnsm1mskcv10g3i83j0kac0a2qmypv1k9f";
  #  } + "/Xresources.dark"
  #);
  #
  xresources.extraConfig = builtins.readFile ./src/.Xresources;
  home.file.".Xresources.d" = {
    source = src/.Xresources.d;
    recursive = true;
  };

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

      package = pkgs.adwaita-icon-theme;
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
    enable = false;                     # Xserver just blank/power-off the display, no need to display xscreensaver
    settings = {
      mode = "Voronoi";                 # "random";
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
  #services.udiskie = {
  #  enable = true;
  #};
  #udisks
  #udiskie
  #deepin.udisk2-qt5
  #usermount
  #services.udisks2 = {
  #  enable = true;
  #  #mountOnMedia = true;
  #  #settings = {};
  #};

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
  #home.file = {

  #home.file.".config/termite/config".source = ./termite.config;

  /*
  home.file.".tmux.conf" = {
    text = ''
      #set-option -g default-shell /run/current-system/sw/bin/fish # bash
      set-window-option -g mode-keys vi

      # Commented this two lines to fix color proble. The $TERM should be "xterm-256color" inside tmux to let it print the colors I need.
      #set -g default-terminal "screen-256color"
      #set -ga terminal-overrides ',screen-256color:Tc'
      # Commented only is not enough to solve the color problem inside tmux. Lets try this
      #set-option -sa terminal-overrides ",xterm*:Tc"

      #set timeoutlen=1000 # Defalut 1000
      #set timeoutlen=50 # Default 50
      #
      #set -g escape-time 10
      set -sg escape-time 10

      set -g clock-mode-style 24
      set -g history-limit 10000
    '';
  };
  */

  #home.file.".config/fish/config.fish" = {
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

  #home.file.".profile".source = src/.profile;

  #home.file.".Xdefaults".source = src/.Xdefaults;

  #home.file.".config/kak" = {
  #    source = ./src/.config/kak;
  #    recursive = true;
  #};

  #home.file.".config/git" = {
  #  source = ./src/.config/git;
  #  recursive = true;
  #};
  #home.file.".gitconfig" = {
  #    source = ./src/.gitconfig;
  #};

  #home.file.".config/awesome" = {
  #    source = ./src/.config/awesome;
  #    recursive = true;
  #};

  #home.file.".config/awesome/lain".source = fetchFromGitHub {
  #    owner = "lcpz";
  #    repo = "lain";
  #    rev = "9477093";
  #    sha256 = "0rfzf93b2v22iqsv84x76dy7h5rbkxqi4yy2ycmcgik4qb0crddp";
  #};

  #home.file."./bin".source = fetchFromGitHub { #fetchGit {
  #    owner = "mnajib";
  #    repo = "home-manager-conf";
  #};
  #home.file."./bin".source = fetchGit {
  #    url = "ssh://najib@mahirah:22/home/najib/GitRepos/bin.git";
  #    ...
  #};

  #home.file.".fonts" = {
  #    source = ./src/.fonts;
  #    recursive = true;
  #};

  #};

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
  #home.stateVersion = "22.11";
}
