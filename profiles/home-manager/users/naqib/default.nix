# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  name = "Muhammad Naqib Bin Muhammad Najib";
  email = "m.naqib.bin.m.najib@gmail.com";
  #githubUsername = "";
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
    #../neovim/lazyvim.nix
    #../neovim # NOTE: Commented because I decided to set neovim per user per host configuration

    (fromCommon "common-configs.nix")
    (fromCommon "common-packages.nix")

    #../roblox.nix
    #../wesnoth.nix
    #./system-benchmark.nix
    #./minecraft.nix

    (fromCommon "youtube.nix")
    (fromCommon "evince.nix")
    (fromCommon "time-management.nix")
    (fromCommon "desktop-apps.nix")

    (fromCommon "repo-bootstrap.nix")
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
    }; # End nixpkgs.config{};

  }; # End nixpkgs{};

  # TODO: Set your username
  home = {
    username = "naqib";
    homeDirectory = "/home/naqib";
  };

  programs.repo-bootstrap.enable = true;
  programs.repo-bootstrap.basePath = "~/src";

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    ihaskell
    #posterazor
    remmina
    #wpsoffice
    #libreoffice
    clamav
    #audacity
    #shotcut
    #calligra        # calligra marked unsecure because using qtwebkit
    #openshot-qt
    #kmymoney
    #shotwell
    #steam
    almanah
    #file-roller
    heimer
    #jrnl
    #kodi
    #python3.8-notebook
    #qtox
    #retroarch
    tig
    treesheets
    unrar
    vue
    vym
    xarchiver
    #xmind-8-update8
    xournalpp
    #evince
    gnome-clocks
    smlnj
    waydroid
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
    #xpra
    bootiso
    virt-manager

    #blender
    #gimp
    inkscape
    #libreoffice
    pixelorama

    godot_4
    gdtoolkit_4
    godot_4-export-templates-bin

    #firefox
    #brave
    qutebrowser

    ranger
    #nnn
    nano
    #neovim # plus manually install LazyVim in ~/.config/nvim from git repo. NOTE: Decided to set neovim per user per host configuration
    micro
    emacs
    #haskellPackages.yi # marked as broken

    #zeroad
    luanti #minetest
    _4d-minesweeper

    fluxbox                             # need fbsetroot to set desktop background color

    #clang
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # programs.neovim.enable = true;

  programs.git = {
    enable = true;
    #userName = "Naqib Najib";
    userName = "Muhammad Naqib";
    userEmail = "m.naqib.bin.m.najib@gmail.com";
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
