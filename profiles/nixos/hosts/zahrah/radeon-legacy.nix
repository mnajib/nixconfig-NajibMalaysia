{ config, lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "radeon" ];

  # Wayland compositors should work (but GPU is very old → expect poor acceleration)
  # Better to use lightweight WMs like i3, openbox, or sway without effects.

  # Mesa drivers (includes r300, r600, etc. for legacy cards)
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    mesa
  ];

  # Kernel firmware for Radeon cards
  hardware.firmware = with pkgs; [
    firmwareLinuxNonfree
  ];
}

