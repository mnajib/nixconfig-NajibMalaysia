#
# NOTE:
#   xdpyinfo
#
#
# Ref:
#   https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Multi_head_or_xinerama_troubles
#   https://nixos.wiki/wiki/XMonad
#

{
  pkgs,
  config,
  lib,
  xmonad-contexts,
  ...
}:
let
  #commonDir = "./";
in
{

  imports = let
    #fromCommon = name: ./. + "/${toString commonDir}/${name}";
  in [
    #(fromCommon "xmonad.nix")
    ./xmonad.nix
  ];

  environment.systemPackages = with pkgs; [
    #xorg.libXinerama
    #xorg.libX11
    #xorg.libXrandr

    polybar
    trayer

    feh

    dmenu
    rofi

    ranger nnn

    #xorg.xbacklight                    # use xrandr?
    acpilight                           # use acpi? "acpilight" is a backward-compatibile replacement for xbacklight
  ];

  services.xserver.windowManager = {
    awesome = {
      enable = true;
    };
    jwm.enable = true;
    icewm.enable = true;
    fluxbox.enable = true;
    notion.enable = true;
    herbstluftwm.enable = true;
    bspwm.enable = true;                # A tiling window manager based on binary space partitioning
  };

}
