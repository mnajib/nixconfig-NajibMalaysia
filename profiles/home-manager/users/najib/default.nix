# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  name = "Najib Ibrahim";
  email = "mnajib@gmail.com";
  githubUsername = "mnajib";
  commonDir = "../../common";
in
{
  # You can import other home-manager modules here
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    (./. + "/${commonDir}/youtube.nix")

    (./. + "/${commonDir}/common-configs.nix")
    (./. + "/${commonDir}/common-packages.nix")

    #../neovim
    #../neovim/lazyvim.nix
    #
    # Now define neovim per-host basis

    (./. + "/${commonDir}/helix")

    (./. + "/${commonDir}/time-management.nix")

    # Previously, my attemp to use nix-doom-emacs
    #./emacs.nix
    # My config with manually download/git clone doomemacs into ~/.config/emacs
    (./. + "/${commonDir}/doom-emacs.nix")
    #
    #inputs.nix-doom-emacs.hmModule
    #
    #./emacs-with-doom.nix

    # NOTE: nix-doom-emacs: This project has been broken for more than a year due to Doom's excessive divergence from emacs-overlay's package set, which is not Doom's fault but rather a missing Elisp package locking mechanism on our end.
    #nix-doom-emacs.hmModule

    #./hyprland.nix
    #../evince.nix

    (./. + "/${commonDir}/cmus.nix")
    (./. + "/${commonDir}/chemistry.nix")
    (./. + "/${commonDir}/git.nix")
    (./. + "/${commonDir}/alacritty.nix")
  ];

  #nixpkgs = {
  #  # You can add overlays here
  #  #overlays = [
  #  #  # Add overlays your own flake exports (from overlays and pkgs dir):
  #  #  outputs.overlays.modifications
  #  #  outputs.overlays.additions
  #  #
  #  #  # You can also add overlays exported from other flakes:
  #  #  # neovim-nightly-overlay.overlays.default
  #  #
  #  #  # Or define it inline, for example:
  #  #  # (final: prev: {
  #  #  #   hi = final.hello.overrideAttrs (oldAttrs: {
  #  #  #     patches = [ ./change-hello-to-hi.patch ];
  #  #  #   });
  #  #  # })
  #  #];
  #
  #  # Configure your nixpkgs instance
  #  config = {
  #    # Disable if you don't want unfree packages
  #    allowUnfree = true;
  #
  #    # Workaround for https://github.com/nix-community/home-manager/issues/2942
  #    allowUnfreePredicate = (_: true);
  #
  #    # XXX:
  #    permittedInsecurePackages = [
  #      #"nix-2.15.3"
  #      #"electron-25.9.0"
  #    ];
  #  };
  #};

  # TODO: Set your username
  home = {
    username = "najib";
    homeDirectory = "/home/najib";

    # NOTE: home.sessionVariables are defined in a file named hm-session-vars.sh.
    # If you are in a shell provided by a HM module, this file is already sourced
    # (They are also explicitly sourcing 31 it but it is hidden to the user.). If
    # you are not using a shell provided by a HM module (e.g. shell provided by
    # NixOS) or writing your own HM module for a shell, then you need to source that
    # file yourself to have those sessions variables defined.
    # Example, for bash:
    # programs.bash = {
    #   enable = true;
    #   sessionVariables = {
    #     EDITOR = "vim";
    #   };
    #   initExtra = ''
    #     . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    #   '';
    # };
    sessionVariables = {
      WINIT_X11_SCALE_FACTOR = 0.8;
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  home.packages = with pkgs; [
    #tmux
    mtm
    dvtm-unstable abduco

    btop
    #steam
    almanah
    #file-roller
    heimer
    #jrnl
    #kodi
    #python3.8-notebook
    #qtox
    #retroarchFull # retroarch
    tig
    treesheets
    #unrar
    vue
    vym
    xarchiver
    #xmind-8-update8
    xournalpp
    #wpsoffice

    #libreoffice-fresh
    #libreoffice-qt-fresh
    libreoffice

    #opera

    smlnj
    #waydroid
    #kmymoney
    #anbox
    #pmbootstrap
    #xwayland
    #tribler
    webtorrent_desktop
    tor-browser
    duf
    gdmap
    ncdu
    gdu
    baobab
    dutree
    btdu
    dfc
    duc
    dua
    epr
    #xpra
    bootiso
    virt-manager
    #kitty
    #jfbview
    #qmmp
    ed  # an implemintation of the standard unix editor
    sakura # a terminal emulator based on GTK and VTE

    #vscode
    #vscode-with-extensions
    #emacs

    ssh-ident

    #geogebra6 # Dynamic mathematics software with graphics, algebra and spreadsheets

    #helix # Post-modern modal text editor
    #evil-helix # Post-modern modal text editor, with vim keybindings
    #helix-gpt # Code completion LSP for Helix with support for Copilot + OpenAI
  ];

  # Environment variable t...
  #sessionVariables = {
  #};

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "Najib Ibrahim";
  programs.git.userEmail = "mnajib@gmail.com";
  programs.git.aliases = {
    co = "checkout";
  };

  programs.gpg.enable = true;
  programs.fzf.enable = true;                    # A command-line fuzzy finder written in Go
  #programs.jq.enable = true;                    # ??? lightweight and flexible command-line JSON processor
  #programs.bat.enable = true;                   # ??? battery?
  programs.command-not-found.enable = true;      # Whether interactive shells should show which Nix package (if any) provides a missing command.
  programs.dircolors.enable = true;
  programs.htop.enable = true;
  programs.info.enable = true;
  #programs.eza.enable = true;

  programs.ssh = {
    enable = true;
    matchBlocks = {
      #------------------------------------------------------------------------
      #"najib@gogs.mahirah" = {
      #  hostname = "mahirah";
      #  port = 22;
      #  user = "najib";
      #  #certificateFile = [ "~/.ssh/gogs.mahirah.localdomain/id_ed25519" ];
      #  identityFile = [ "~/.ssh/gogs.mahirah.localdomain/id_ed25519" ];
      #};
      #------------------------------------------------------------------------
    };

    #".ssh/config_source" = {
    #  source = ../shared/config/ssh/config-cmt;
    #  onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 600 ~/.ssh/config'';
    #};
  };

  #programs.tmux.shell = "\${pkgs.zsh}/bin/zsh";
  #programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  #programs.tmux.shell = "/run/current-system/sw/bin/zsh";

  # NOTE: nix-doom-emacs: This project has been broken for more than a year due to Doom's excessive divergence from emacs-overlay's package set, which is not Doom's fault but rather a missing Elisp package locking mechanism on our end.
  #programs.doom-emacs = {
  #  enable = true;
  #  # Directory containing my config.el, init.el, and packages.el files
  #  # Need to cread ~/doom.d
  #  # and copy the three files from
  #  # https://github.com/nix-community/nix-doom-emacs/tree/master/test/doom.d
  #  #doomPrivateDir = "./doom.d";
  #  doomPrivateDir = ./src/doom.d;
  #};

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
}
