{ config, pkgs, lib, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure display manager (e.g., LightDM)
  #services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.defaultSession = "none+xmonad";

  # Enable XMonad
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true; # Enables xmonad-contrib and xmonad-extras

    # XXX:
    #config = builtins.readFile /home/a/.config/xmonad/xmonad.hs;
    #config = lib.mkDefault builtins.readFile /home/a/.xmonad/xmonad.hs;
    
    # Declare any extra Haskell packages your xmonad.hs will need (e.g., dbus, etc.)
    extraPackages = hp: [
      hp.xmonad-contrib
      hp.xmonad-extras
      hp.xmonad
      hp.hostname
    ];
  };

  # Optional: Common utilities often used with XMonad
  environment.systemPackages = with pkgs; [
    dmenu
    git
    haskellPackages.xmobar # Status bar
    alacritty             # Terminal emulator
    rofi
    trayer
    pulsemixer
  ];
}
