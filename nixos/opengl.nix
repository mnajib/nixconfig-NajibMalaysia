{
  pkgs,
  config,
  ...
}:
{
  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      vaapiVdpau
      mesa.drivers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      vaapiVdpau
    ];
  };
}
