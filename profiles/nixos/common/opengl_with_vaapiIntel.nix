{
  pkgs,
  config,
  ...
}:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-vaapi-driver #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      libva-vdpau-driver # vaapiVdpau
      mesa #mesa.drivers
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      intel-vaapi-driver #vaapiIntel # conflic with nixos-hardware config
      libvdpau-va-gl
      libva-vdpau-driver # vaapiVdpau
    ];
  };
}
