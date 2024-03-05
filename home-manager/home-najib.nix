# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  name = "Najib Ibrahim";
  email = "mnajib@gmail.com";
  githubUsername = "mnajib";
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix

    ./youtube.nix

    ./common-configs.nix
    ./common-packages.nix

    # My attemp to use nix-doom-emacs
    #./emacs.nix
    #
    #inputs.nix-doom-emacs.hmModule
    #
    #./emacs-with-doom.nix

    #./hyprland.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;

      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "najib";
    homeDirectory = "/home/najib";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;

  home.packages = with pkgs; [
    btop
    #steam
    almanah
    #file-roller
    heimer
    #jrnl
    #kodi
    #python3.8-notebook
    qtox
    #retroarchFull # retroarch
    tig
    treesheets
    unrar
    vue
    vym
    xarchiver
    #xmind-8-update8
    xournalpp
    wpsoffice
    chemtool
    marvin
    smlnj
    #waydroid
    #kmymoney
    #anbox
    #pmbootstrap
    #xwayland
    #tribler
    webtorrent_desktop
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
    xpra
    bootiso
    virt-manager
    kitty
    #jfbview
    #qmmp
    ed  # an implemintation of the standard unix editor
    sakura # a terminal emulator based on GTK and VTE
  ];

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
  programs.eza.enable = true;

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
  };

  # XXX:
  #programs.tmux.shell = "\${pkgs.zsh}/bin/zsh";
  #programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  programs.tmux.shell = "/run/current-system/sw/bin/zsh";

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
  home.stateVersion = "22.05";
}
