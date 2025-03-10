#
# Note:
#   run: smbpasswd -a <USER> to setup user.
#

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
    nmbd.enable = false;                 # Default: true
    winbindd.enable = false;

    settings = {
      global = {
        workgroup = "WORKGROUP";
        "server string" = "customdesktop";
        "netbios name" = "customdesktop";
        "server role" = "standalone server";

        #"log file" = "/var/log/samba/smbd.%m";
        "max log size" = 50;

        security = "user";

        "use sendfile" = "yes";
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        #hosts allow = 192.168.0. 192.168.1. 127.0.0.1 localhost
        "hosts allow" = "0.0.0.0/0";
        "hosts deny" = "0.0.0.0/0";
        "dns proxy" = "no";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        #"vfs objects" = "catia fruit streams_xattr";

	      "pam password change" = "yes";
        "usershare allow guests" = "yes";
        "create mask" = 0664;
        "force create mode" = 0664;
        "directory mask" = 0775;
        "force directory mode" = 0775;
        "follow symlinks" = "yes";
        "load printers" = "no";
        "printing" = "bsd";
        "printcap name" = "/dev/null";
        "disable spoolss" = "yes";
        "strict locking" = "no";
        "aio read size" = 0;
        "aio write size" = 0;
        #"vfs objects" = "acl_xattr catia fruit streams_xattr";
        "inherit permissions" = "yes";
      };

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
      
      najibzfspool1 = {
        path = "/home/share/public";
        comment = "Public Read-only access";
      
        "security" = "user";
      
        browseable = "yes";
        #"writeable" = "yes";
        "read only" = "yes";            # "no"
        "guest ok" = "yes";
        "guest account" = "nobody";
      
        "create mask" = "0644";
        "directory mask" = "0755";
        #"create mask" = "0666";
        #"directory mask" = "0777";
      
        #"force user" = "najib";        # "share" "cadey" "abdullah"
        #"force user" = "share";         # "share" "cadey" "abdullah"
        "force user" = "nobody";
        "force group" = "users";        # "within"
      };
      
      najib = {
        path = "/MyTank/backups/offsite/najibzfspool1/nfs/share/DATA/01 Najib";
        browseable = "yes";
        "read only" = "yes"; #"no"; # This is zfs remote backup, should only allow read-only
      
        # Make this private
        "guest ok" = "no";
        "valid users" = "najib";
      };
      
      naqib = {
  	  	path = "/MyTank/backups/offsite/najibzfspool1/nfs/share/DATA/03 Naqib";
  		  browseable = "yes";
  		  "read only" = "yes"; #"no"; # This is zfs remote backup, should only allow read-only
  		
  		  # Make this private
  		  "guest ok" = "no";
  		  "valid users" = "naqib";
      };

    }; # End services.samba.settings

    # Printer Sharing
    # The `samba` packages comes without cups support compiled in;
    # however `sambaFull` packages features printer sharing support.
    # To use it set the `services.samba.package` option:
    #package = pkgs.sambaFull;
    openFirewall = true;               # To automatically open firewall ports
    #...

  }; # End services.samba

  #systemd.tmpfiles.rules = [ "d /home/Shares/Public 0755 share users" ];
  #systemd.tmpfiles.rules = [ "d /home/nfs/share/DATA 0755 share users" ];
  systemd.tmpfiles.rules = [ "d /home/nfs/share 0755 share users" ];
  #
  # Create the shared directory and set permissions
  #systemd.tmpfiles.rules = [
  #  "d ${sharedFolder} 0777 nobody nogroup - -"
  #];

  users.users = {
    share = {
      isSystemUser = true;
      isNormalUser = false;
      group = "users";
    };
  };

  services.samba-wsdd = {
    enable = true;    # To make shares visible for Windows-10
    openFirewall = true;
  };

  #----------------------------------------------------------------------------
  # Open Firewall Ports
  #----------------------------------------------------------------------------
  # If your firewall is enabled, or if you consider enabling it:
  #   networking.firewall.enable = true;
  #   networking.firewall.allowPing = true;
  #   services.samba.openFirewall = true;

  networking.firewall = {
    enable = true;
    allowPing = true;

    allowedTCPPorts = [
      5357      # wsdd
    ];

    allowedUDPPorts = [
      3702      # wsdd
    ];

  };

  environment.systemPackages = with pkgs; [
    samba # samba client tools (optional)
  ];

}
