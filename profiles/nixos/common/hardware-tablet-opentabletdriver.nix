{ pkgs, config, ... }:
{
    # XXX: Focus on OSU game. How about for professional drawing?
    environment.systemPackages = [
        pkgs.opentabletdriver
        #pkgs.krita
    ];
    hardware.opentabletdriver.enable = true;
}
