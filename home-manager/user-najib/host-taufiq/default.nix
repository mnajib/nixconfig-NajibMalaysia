# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }:
#let
#  hostname = "nyxora";
#in
{
  # You can import other home-manager modules here
  imports = [
    ../default.nix
    ../../neovim
    #../../stylix.nix
  ];

  #home.username = "$USER";
  #home.homeDirectory = "/home/najib";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  #home.stateVersion = "22.05";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    plex-desktop

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
