# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  name = "Juliani Jaffar";
  email = "jung_jue@yahoo.com";
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
    ../neovim/lazyvim.nix
    #./roblox.nix
    #./wesnoth.nix

    ../common-configs.nix
    ../common-packages.nix

    ../neovim
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
    username = "julia";
    homeDirectory = "/home/julia";
  };

  # Add stuff for your user as you see fit:

  #programs.neovim.enable = true;

  home.packages = with pkgs; [
    #posterazor                          # for print on big paper?
    #remmina                             # RDP remote desktop client ?
    #wpsoffice                           #
    libreoffice
    clamav                              # scan anti-virus ?
    mindustry                           # game
    minetest                            # game
    #audacity
    #shotcut
    #calligra                           # calligra marked unsecure because using qtwebkit
    #openshot-qt
    #kmymoney
    #shotwell
    gv                                  # view and navigate through PostScript and PDF documents on an X display (user interface for the ghostscript interpreter)

    gnuchess                            # chess-engine
    stockfish                           # strong open source chess-engine
    fairymax                            # a small chess-engine supporting fairy pieces
    xboard                              # gui for chess-engine
    eboard                              # chess interface for unix-like systems
    gnome.gnome-chess                   # gui chess game
    #kdePackages.knights                 # Chess board program
    cutechess                           # GUI, CLI, and library for playing chess
    uchess                              # play chess against UCI engines in your terminal
    gambit-chess                        # play chess in your terminal
    arena                               # Chess GUI for analyzing with and playing against various engines
    chessx                              # browse and analyse chess games
    chessdb                             # a free chess database

    gshogi                              # a GUI implementation of the Shogi board game (also known as Japanese Chess)
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Juliani Jaffar";
    userEmail = "juliani.jaffar@gmail.com";
  };

  programs.fzf.enable = true;
  programs.command-not-found.enable = true;
  programs.htop.enable = true;
  programs.info.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.11";
  #home.stateVersion = "24.05";
  # I separate this to user@host specific;
  #   nixconfig-NajibMalaysia/home-manager/julia-keira.nix
  #   nixconfig-NajibMalaysia/home-manager/julia-manggis.nix
  #   nixconfig-NajibMalaysia/home-manager/julia-taufiq.nix
}
