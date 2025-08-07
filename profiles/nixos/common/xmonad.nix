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
{
  imports = [
    #./rofi.nix
  ];

  environment.systemPackages = with pkgs; [
    xorg.libXinerama
    xorg.libX11
    xorg.libXrandr

    #xmobar
    haskellPackages.xmobar

    trayer
    volumeicon
    pasystray # pulseaudio system tray

    rofi
    dmenu
    killall
    networkmanagerapplet
    alacritty alacritty-theme
  ];

  services.xserver.windowManager = {
    xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages: [
        haskellPackages.xmonad
        haskellPackages.xmonad-extras
        haskellPackages.xmonad-contrib
        haskellPackages.dbus
        haskellPackages.List
        haskellPackages.monad-logger
        haskellPackages.xmobar
        haskellPackages.network

        haskellPackages.GLHUI
      ];
      #config = builtins.readFile ~/.xmonad/xmonad.hs;
      ghcArgs = [
        "-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
        "-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
        "-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
      ];
    };
  };

}
