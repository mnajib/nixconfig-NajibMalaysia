{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        kdePackages.wacomtablet #wacomtablet
        krita
        xf86_input_wacom
        libwacom
    ];
    services.xserver.wacom.enable = true;
}
