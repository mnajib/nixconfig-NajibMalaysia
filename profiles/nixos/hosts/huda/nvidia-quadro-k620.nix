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

  # Allow the proprietary NVIDIA drivers
  #nixpkgs.config.allowUnfree = true;

  # Enable graphics drivers (Required for GUI and hardware acceleration)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Necessary if you run 32-bit applications/Steam
  };

  hardware.nvidia = {

    # Modesetting is required for modern desktop environments and Wayland stability
    modesetting.enable = true;

    # Power management can cause wake-from-sleep issues on older Kepler/Maxwell cards;
    # it is usually safest to keep it disabled unless needed.
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the open-source kernel module (Not supported by the 470xx legacy driver)
    open = false;

    # Enable the NVIDIA settings menu utility
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

    ##  CRITICAL: Force NixOS to use the legacy 470xx driver required for the K620
    ##    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
    ##
    ##  Verifying the Installation: Once the system boots up using the new
    ##  configuration, you can verify that the driver is active and communicating
    ##  with the hardware by running:
    ##    nvidia-smi
    ##  This should print a table showing the Quadro K620, the 470.xx driver
    ##  version, current power consumption, and any active graphical processes
    ##  running on the GPU.

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
