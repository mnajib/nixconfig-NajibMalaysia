# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  name = "Nur Nasuha";
  #email = "";
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
    #./roblox.nix
    #./wesnoth.nix
    #./minecraft.nix

    ../common-configs.nix
    ../common-packages.nix

    ../time-management.nix
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
    username = "nurnasuha";
    homeDirectory = "/home/nurnasuha";
  };

  # Add stuff for your user as you see fit:

  #programs.neovim.enable = true;

  home.packages = with pkgs; [
    #posterazor
    remmina
    #wpsoffice
    libreoffice
    clamav
    #audacity
    #shotcut
    #calligra        # calligra marked unsecure because using qtwebkit
    #openshot-qt
    kmymoney
    #shotwell

    teeworlds
    minetest
    #minecraft-launcher
    #minecraft-server
    openttd
    #0ad
    #grapejuice
    #zoom-us
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Nur Nasuha";
    userEmail = "nurnasuhabintimohdnajib@gmail.com";
    #cincludes.
  };
  programs.gitui.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.11";
}
