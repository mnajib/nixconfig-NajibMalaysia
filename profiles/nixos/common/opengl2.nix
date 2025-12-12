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

      #vaapiIntel # conflic with nixos-hardware config
      intel-vaapi-driver

      libvdpau-va-gl

      #vaapiVdpau
      libva-vdpau-driver

      mesa #mesa.drivers
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva

      #vaapiIntel # conflic with nixos-hardware config
      intel-vaapi-driver

      libvdpau-va-gl

      #vaapiVdpau
      libva-vdpau-driver
    ];

  }; # End hardware.graphics
}
