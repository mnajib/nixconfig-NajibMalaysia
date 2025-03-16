{ pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    hplip
  ];

  # Enable CUPS Printing Service: Configure the CUPS service to enable browsing and sharing of printers.
  services.printing = {
    enable = true;
    listenAddresses = [
      #"*:631"
      "0.0.0.0:631"
    ];
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    #defaultShared = false;
    openFirewall = true;
    #browsed.enable = true;
    drivers = with pkgs; [
      gutenprint # Drivers for many different printers from many different vendors.
      #gutenprintBin # Additional, binary-only drivers for some printers.

      #hplip # Drivers for HP printers.
      hplipWithPlugin # Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.

      splix # Drivers for printers supporting SPL (Samsung Printer Language).
      samsung-unified-linux-driver # Proprietary Samsung Drivers

      postscript-lexmark # Postscript drivers for Lexmark

      brlaser # Drivers for some Brother printers
      brgenml1lpr brgenml1cupswrapper # Generic drivers for more Brother printers

      cnijfilter2 # Drivers for some Canon Pixma devices (Proprietary driver)
    ];

    #extraConf = ''
    ###  <Location />
    #    Order allow,deny
    #    Allow all
    ###  </Location>
    #'';

  };

  # Enable Avahi Service: Use Avahi to broadcast the printer as a zero-conf service on the network. This step is crucial for AirPrint compatibility.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    ipv4 = true;
    ipv6 = false;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
      #addresses = true;
      #workstation = true;
    };
    #extraServiceFiles = {
    #  airprint = "/etc/nixos/airprint.service";
    #};
  };

  #services.samba.package = pkgs.sambaFull;
  #services.samba = {
  #  enable = true;
  #  package = pkgs.sambaFull;
  #  openFirewall = true;
  #  settings = {
  #    "load printers" = "yes";
  #    "printing" = "cups";
  #    "printcap name" = "cups";
  #  };
  #  "printers" = {
  #    "comment" = "All Printers";
  #    "path" = "/var/spool/samba";
  #    "public" = "yes";
  #    "browseable" = "yes";
  #    # to allow user 'guest account' to print.
  #    "guest ok" = "yes";
  #    "writable" = "no";
  #    "printable" = "yes";
  #    "create mode" = 0700;
  #  };
  #};
  #systemd.tmpfiles.rules = [
  #  "d /var/spool/samba 1777 root root -"
  #];

  #hardware.printer = {
  #  ensurePrinters = [
  #    {
  #      name = "Dell_1250c";
  #      location = "Home";
  #      deviceUri = "usb://Dell/1250c%20Color%20Printer?serial=YNP023240";
  #      model = "Dell-1250c.ppd.gz";
  #      ppdOptions.PageSize = "A4";
  #    }
  #  ];
  #  ensureDefaultPrinter = "Dell_1250c";
  #};

  hardware.sane = {
    enable = true;
    openFirewall = true;
    extraBackends = with pkgs; [
      hplipWithPlugin
      sane-airscan
    ];
  };

  services.system-config-printer.enable = true;
  programs.system-config-printer.enable = true;

  # Configure Firewall Rules: Ensure that the firewall allows traffic on port 631, which is used by the CUPS printing server.
  networking.firewall = {
    allowedTCPPorts = [ 631 ];
    allowedUDPPorts = [ 631 ];
  };

}
