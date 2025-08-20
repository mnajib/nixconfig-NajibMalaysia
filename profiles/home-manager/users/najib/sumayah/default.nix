# profiles/home-manager/users/najib/sumayah/default.nix

{ inputs, outputs, lib, config, pkgs, ... }:
#{ lib, config, pkgs, ... }:
let
  username = "najib";
  hostname = "sumayah";
  commonDir = "../../../common";
  stateVersion = "24.11";
in
{
  # You can import other home-manager modules here
  imports = let
    # For simple modules (no params)
    fromCommon = name: ./. + "/${toString commonDir}/${name}";

    # For modules that take params
    fromCommonWithParams = name: params: import (./. + "/${toString commonDir}/${name}") params;
  in [
    ../default.nix

    #(./. + "/${commonDir}/neovim")
    (fromCommon "neovim")

    #(./. + "/${commonDir}/stylix.nix")

    #(fromCommon "repo-bootstrap.nix")  # plain, no params, with helper function
    #(import ./. + "/${commonDir}/repo-bootstrap.nix" { basePath = "~/Projects"; }) # with params, with helper function
    (fromCommonWithParams "repo-bootstrap.nix" { basePath = "~/Projects"; })  # with params, without helper function
  ];

  #home.username = "$USER";
  #home.homeDirectory = "/home/najib";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  #home.stateVersion = "24.11";
  home.stateVersion = "${stateVersion}";

  home.packages = with pkgs; [
    #plex-desktop

    #source-code-pro  # For "Source Code Pro"
    #noto-fonts       # For "Noto Sans/Serif"
    #dejavu_fonts     # For "DejaVu" fallbacks
    #noto-fonts-emoji # For "Noto Color Emoji
    #nerdfonts
    #noto-fonts
    #liberation_ttf
    #font-awesome

    mumble

    kitty # terminal emulator
    dillo-plus # web browser but without javascript
    chisel # TCP/UDP tunnel over HTTP
  ];

  fonts.fontconfig = {
    enable = true;
    #antialias = true;
    #hinting.enable = true;
    #subpixel.lcdfilter = "default";
    #dpi = 96;
    #defaultFonts.monospace = [
    #  "Source Code Pro"
    #  "DejaVu Sans Mono"
    #];
    #defaultFonts.sansSerif = [
    #  "Noto Sans"       # Example sans-serif font
    #  "DejaVu Sans"      # Fallback font
    #];
    #defaultFonts.serif = [
    #  "Noto Serif"       # Example serif font
    #  "DejaVu Serif"     # Fallback font
    #];
    ## Optional configurations:
    #defaultFonts.emoji = [
    #  "Noto Color Emoji" # Emoji font
    #];
  };

  # NOTES:
  #   home-manager switch --flake .#najib@taufiq
  #   fc-cache -fv
  #   fc-list
  #   fc-match sans-serif
  #   fc-match serif
  #   fc-match monospace

}
