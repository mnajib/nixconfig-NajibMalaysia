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

    #polybar
    trayer

    feh
    #nitrogen # 'nitrogen' has been removed as it depended on the deprecated gtk2 via gtkmm2

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
    icewm.enable = true;
    jwm.enable = true;
    fluxbox.enable = true;
    windowmaker.enable = true;
    notion.enable = true;
    herbstluftwm.enable = true;
    bspwm.enable = true;                # A tiling window manager based on binary space partitioning
    openbox.enable = true;
    berry.enable = true;
    pekwm.enable = true;
    ratpoison.enable = true;
    tinywm.enable = true;
    smallwm.enable = true;
    mlvwm.enable = true;
    leftwm.enable = true;
    i3.enable = true;
    fvwm3.enable = true;
    twm.enable = true;
    spectrwm.enable = true;
    sawfish.enable = true;
    clfswm.enable = true;
    "2bwm".enable = true;
  };

}
