{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        wacomtablet
        krita
        xf86_input_wacom
        libwacom
    ];
    services.xserver.wacom.enable = true;
}
