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
  };

}
