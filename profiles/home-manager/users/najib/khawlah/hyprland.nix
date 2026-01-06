# profiles/home-manager/users/najib/khawlah/hyprland.nix

{ inputs, outputs, lib, config, pkgs, ... }:
let
  #username = "najib";
  #hostname = "khawlah";
  commonDir = "../../../common";
  #stateVersion = "25.05";
in
{
  imports = let
    # For simple modules (no params)
    fromCommon = name: ./. + "/${toString commonDir}/${name}";

    # For modules that take params
    fromCommonWithParams = name: params: import (./. + "/${toString commonDir}/${name}") params;
  in [
    #../default.nix
    #(fromCommon "neovim")

    #(fromCommon "wayland-desktop.nix")
    (fromCommon "hyprland.nix")
  ];

  home.packages = with pkgs; [
    kitty # terminal emulator
    wofi
    waybar
  ];

}
