{
  pkgs,
  config,
  lib,
  ...
}:
let
  thisHost = config.networking.hostname;
in
{

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    # Card Nvidia GeForce GT 720 (in acer aspire taufiq).
    #package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    #
    # Card Nvidia Quadro K620 (in HP Z420 nyxora).
    #   --> Display Driver 570.133.07
    #   --> Display Dirver 580.119.02 (2025-12-11) (Info 2025-12-22)
    #
    #package = config.boot.kernelPackages.nvidiaPackages.stable; # v 565.77
    #package = config.boot.kernelPackages.nvidiaPackages.latest; # v 565.77

    # Version 550.135 (info ...) .
    # Version 580.119.02 (info 2025-12-22).
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    cudatoolkit

    pciutils
  ];

}
