{ pkgs, config, ... }:
{
  # Enable CUPS to print docoments.
  services.printing.enable = true;
  services.printing.browsing = true;
  services.printing.defaultShared = false;
  services.printing.drivers = with pkgs; [ gutenprint hplip splix ];

  services.avahi.enable = false;
  ##services.avahi.nssmdns = false;
  services.avahi.nssmdns4 = false;
  #
  #services.ipp-usb.enable = true;

  hardware.sane.enable = true;

  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;

  services.printing.browsed.enable = true;

  networking.firewall = {
    allowedTCPPorts = [ 631 ];
    allowedUDPPorts = [];
  };
}
