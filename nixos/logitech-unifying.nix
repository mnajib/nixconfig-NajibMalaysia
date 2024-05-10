{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    solaar
    logitech-udev-rules
    gnomeExtensions.solaar-extension
  ];
  hardware.logitech.wireless.enable = true;
}
