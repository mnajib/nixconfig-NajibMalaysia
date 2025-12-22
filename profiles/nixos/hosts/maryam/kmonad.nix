{ config, pkgs, lib, ... }:

let
  keyboardDevice = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";

  kmonadConfig =
    builtins.readFile ./kmonad/dvorak.kbd;

in
{
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    kmonad
  ];

  services.kmonad = {
    enable = true;

    keyboards.dvorakWithLayers = {
      device = keyboardDevice;
      config = kmonadConfig;
    };
  };
}

