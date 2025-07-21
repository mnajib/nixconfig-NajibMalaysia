# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
let
  username = "naim";
  #name = "M.Na'im Bin M.Najib";
  name = "Muhammad Na'im";
  fullname = "Muhammad Na'im Bin Mohd Najib";
  email = "muhammadnaimbinmohdnajib@gmail.com";
in
{
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    #inputs.nix-colors.homeManagerModules.default
    #inputs.hardware.nixosModules.common-cpu-intel
    #inputs.hardware.nixosModules.common-gpu-intel
    #inputs.hardware.nixosModules.common-gpu-nvidia
    ##inputs.hardware.nixosModules.common-gpu-nvidia-disable.nix
    #inputs.hardware.nixosModules.common-pc-laptop
    #inputs.hardware.nixosModules.common-pc-ssd
    #inputs.hyprland.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./roblox.nix
    ./wesnoth.nix
    #./wayland-wm/default.nix
    ./minecraft.nix

    ./common-configs.nix
    ./common-packages.nix
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
    username = "${username}";
    homeDirectory = "/home/${username}";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    #sameboy

    # CLI task manager
    #taskell # disable as it failed to build on 2023-09-19
    ctodo
    geek-life
    todoman

    # GUI task manager
    #elementary-planner # marked broken
    effitask

    foot
    minetest
    #blender
    freecad librecad
    inkscape
    #gimp
    #libreoffice
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "${name}";
    userEmail = "${email}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
