# profiles/nixos/hosts/printer2/print-scan-server.nix

{ config, pkgs, ... }:

{

  nixpkgs.config.allowUnfree = true;

  # Fact: CUPS is the battle-tested standard for Linux printing infrastructure.
  services.printing = {
    enable = true;
    # Suggestion: Include standard drivers and driverless IPP support for modern printers
    drivers = with pkgs; [
      foomatic-filters
      #epson-inkjet-printer-escpr # Adjust or add manufacturer drivers if needed (e.g., hpijs, cnijfilter2)

      gutenprint # Drivers for many different printers from many different vendors.
      #gutenprintBin # Additional, binary-only drivers for some printers.

      #hplip # Drivers for HP printers.
      hplipWithPlugin # Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.

      #splix # Drivers for printers supporting SPL (Samsung Printer Language).
      #samsung-unified-linux-driver # Proprietary Samsung Drivers

      #postscript-lexmark # Postscript drivers for Lexmark

      #brlaser # Drivers for some Brother printers
      #brgenml1lpr brgenml1cupswrapper # Generic drivers for more Brother printers

      #cnijfilter2 # Drivers for some Canon Pixma devices (Proprietary driver)
    ];
    # Allow print jobs from any local subnet IP address
    extraConf = ''
      DefaultEncryption Never
    '';
  };

  # Fact: Avahi enables automatic network printer and scanner discovery (AirPrint / IPP Everywhere)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      #services = [ "ipp" "printer" "scanner" ];
      #userServices = true;
    };
  };

  # Fact: SANE handles USB and network document scanner sharing
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-backends ];
  };

  # Open required firewall ports for CUPS (631) and SANE (6566)
  networking.firewall.allowedTCPPorts = [ 631 6566 ];
  networking.firewall.allowedUDPPorts = [ 631 ];
}
