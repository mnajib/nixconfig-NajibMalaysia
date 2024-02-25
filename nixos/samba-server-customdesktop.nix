{ config, pkgs, ... }:
{
  #----------------------------------------------------------------------------
  # Prepare directories
  #----------------------------------------------------------------------------

  #...

  #----------------------------------------------------------------------------
  # Samba Server
  #----------------------------------------------------------------------------

  services.samba = {
    enable = true;
    securityType = "user";              # Default: "user"
    #enableNmbd = true;                 # Default: true

    extraConfig = ''
      workgroup = WORKGROUP
      server string = customdesktop
      netbios name = customdesktop
      server role = standalone server

      log file = /var/log/samba/smbd.%m
      max log size = 50

      security = user
      use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      #hosts allow = 192.168.0. 192.168.1. 127.0.0.1 localhost
      hosts allow = 0.0.0.0/0
      hosts deny = 0.0.0.0/0
      dns proxf = no
      guest account = nobody
      map to guest = bad user
    '';

    shares = {

      #public = {
      #  path = "/home/Shares/Public";
      #  comment = "Najib's Public Samba Share.";
      #  browseable = "yes";
      #  "writeable" = "yes";
      #  "read only" = "no";
      #  "guest ok" = "yes";
      #  "public" = "yes";
      #  "create mask" = "0644";
      #  "directory mask" = "0755";
      #  #"force user" = "najib";
      #  "force user" = "share";
      #  "force group" = "users";
      #};

      #private = {
      #  path = "/home/Shares/Private";
      #  browseable = "yes";
      #  "read only" = "no";
      #  "guest ok" = "no";
      #  "create mask" = "0644";
      #  "directory mask" = "0755";
      #  "force user" = "najib";
      #  "force group" = "users";
      #};

      data = {
        #path = "/home/nfs/share/DATA";
        path = "/home/nfs/share";
        comment = "Najib's NFS and CIFS Shared Storage";
        browseable = "yes";
        #"writeable" = "yes";
        "read only" = "yes";            # "no"
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        #"force user" = "najib";        # "share" "cadey" "abdullah"
        "force user" = "share";         # "share" "cadey" "abdullah"
        "force group" = "users";        # "within"
      };

    };

    # Printer Sharing
    # The `samba` packages comes without cups support compiled in;
    # however `sambaFull` packages features printer sharing support.
    # To use it set the `services.samba.package` option:
    #package = pkgs.sambaFull;
    openFirewall = true;               # To automatically open firewall ports
    #...
  };

  #systemd.tmpfiles.rules = [ "d /home/Shares/Public 0755 share users" ];
  #systemd.tmpfiles.rules = [ "d /home/nfs/share/DATA 0755 share users" ];
  systemd.tmpfiles.rules = [ "d /home/nfs/share 0755 share users" ];

  users.users.share = {
    isNormalUser = false;
  };

  services.samba-wsdd.enable = true;    # To make shares visible for Windows-10

  #----------------------------------------------------------------------------
  # Open Firewall Ports
  #----------------------------------------------------------------------------
  # If your firewall is enabled, or if you consider enabling it:
  #   networking.firewall.enable = true;
  #   networking.firewall.allowPing = true;
  #   services.samba.openFirewall = true;

  networking.firewall.allowedTCPPorts = [
    5357      # wsdd
  ];

  networking.firewall.allowedUDPPorts = [
    3702      # wsdd
  ];
}
