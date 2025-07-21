{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        linuxPackages.digimend
    ];
    services.xserver.digimend.enable = true;
}
