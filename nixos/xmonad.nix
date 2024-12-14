#
# NOTE:
#   xdpyinfo
#
#
# Ref:
#   https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Multi_head_or_xinerama_troubles
#

{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    xorg.libXinerama
    xorg.libX11
    xorg.libXrandr
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
    };
  };

}
