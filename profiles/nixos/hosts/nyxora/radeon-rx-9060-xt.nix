{
  pkgs,
  config,
  #lib,
  ...
}:
let
  thisHost = config.networking.hostname;
in
{

  boot.kernelParams = [
    # Unlocks advanced clock, voltage, and power tuning controls for amdgpu
    "amdgpu.ppfeaturemask=0xffffffff"

    #
    # PPfeaturemask:
    #   A Linux kernel parameter for AMD drivers that explicitly unlocks
    #   advanced PowerPlay features (like manual voltage, clock frequency
    #   scaling, and fan control customization).
    #

  ];

  #services.xserver.videoDrivers = [ "nvidia" ];

  #
  # Using a GUI Tool (lact)
  #   The most robust and user-friendly way to manage modern RDNA 4 cards like the RX 9060 XT on NixOS is LACT (Linux AMDGPU Controller Tool). It allows you to dial in undervolts and custom fan profiles directly.
  #
  # Open the LACT GUI, and apply the following strategic changes:
  #   1. Reduce Max Clock Speed Slightly: Drop your Boost Clock down from the default 3230 MHz to roughly 2900–3000 MHz. Cutting off that final top-end frequency spike yields massive power savings with minimal frame loss.
  #   2. Lower Voltage Target (Undervolt): Step the voltage down in small increments (e.g., -25mV to -50mV steps) while verifying stability. RDNA 4 architecture responds very well to slight voltage drops, dropping wattage while letting the card run significantly cooler.
  #   3. Adjust the Fan Curve: Create a smooth linear ramp that targets keeping the core around 65°C to 70°C, preventing sudden fan acceleration.
  #
  # Undervolting:
  #   The practice of reducing the voltage supplied to the GPU core while
  #   keeping its clock speeds stable, dropping power draw significantly because
  #   power consumption scales quadratically with voltage ($P \propto V^2$).
  #
  # CoreClock Offset:
  #   Intentionally capping the maximum frequency peak of the GPU to avoid
  #   entering inefficient high-voltage/high-frequency sweet spots.
  #

  environment.systemPackages = with pkgs; [
    pciutils
    lact # Linux AMDGPU Controller Tool
  ];

  # Enable the systemd daemon for LACT to apply profiles on boot
  systemd.services.lactd = {
    description = "AMDGPU Control Daemon";
    enable = true;
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
  };

}
