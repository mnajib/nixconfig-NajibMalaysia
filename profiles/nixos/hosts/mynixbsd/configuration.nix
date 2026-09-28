# File: profiles/nixos/hosts/mynixbsd/configuration.nix
{
  pkgs,
  inputs,
  config,
  lib,
  #outputs,
  #modulesPath,
  ...
}:
let
  hostName   = "mynixbsd";
  hostID     = "35030588";
  commonDir  = "../../common";
  hmDir      = "../../../home-manager/users";
  #stateVersion = "26.05"
in {
  imports = let
    fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    #./hardware-configuration.nix
    # Import konfigurasi Disko khusus bagi ThinkPad T61 / NixBSD
    #./disko-nixbsd.nix
    ./disko-nixbsd-on-T61.nix

    # Import upstream NixBSD graphical preset module directly
    "${inputs.nixbsd}/configurations/graphical/default.nix"

    (fromCommon "users-najib.nix")
  ];

  # Stub missing NixOS options required by Disko's module evaluator on NixBSD
  options = {
    boot.resumeDevice = lib.mkOption {
      type        = lib.types.anything;
      default     = null;
      description = "Stub option for Disko compatibility on NixBSD";
    };
    boot.loader.grub = lib.mkOption {
      type        = lib.types.anything;
      default     = {};
      description = "Stub option for Disko compatibility on NixBSD";
    };
  };

  # Wrap configuration settings in an explicit config block
  config = {
    # Allow packages not yet officially tagged for x86_64-freebsd in Nixpkgs metadata
    nixpkgs.config.allowUnsupportedSystem = true;

    # Global overlay to enable dbusSupport on sdl3 and satisfy the ibusSupport assertion
    nixpkgs.overlays = [
      (final: prev: {
        sdl3 = prev.sdl3.override {
          dbusSupport = true;
        };
      })
    ];

    # System State Version
    system.stateVersion = "26.05";

    # Host Identification & Hardware
    #networking.hostName = "mynixbsd";
    networking.hostName = "${hostName}";

    # User Account Configuration
    users.users.najib = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "video" "audio" ];
      shell        = pkgs.zsh;
    };

    # Enable Zsh program integration for profile & PATH initialization
    programs.zsh.enable = true;

    # System & Graphical Services
    services.openssh.enable = true;

    # Additional Packages for the Graphical Session
    environment.systemPackages = with pkgs; [
      alacritty
      firefox
      git
      vim
      htop
    ];
  };
}
