{ pkgs, config, ... }:

{
    sound.enable = true;

    hardware.pulseaudio.enable = true;
    #hardware.pulseaudio.systemWide = true;
    hardware.pulseaudio.package = pkgs.pulseaudioFull;
    hardware.pulseaudio.support32Bit = true;
}
