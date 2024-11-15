#
# NOTE:
#
#   sudo journalctl -u samba-smbd.service -f
#

{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils

    lxqt.lxqt-policykit                 # provides a default authentication client for policykit
  ];

  services.samba = {
    enable = true;
    openFirewall = true;

    #extraConfig = ''
    #  workgroup = WORKGROUP
    #  security = user
    #  #guest account = najib
    #  guest account = nobody
    #  map to guest = bad user
    #'';
    settings = {
      global = {
        "invalid users" = [
          "root"
        ];
        "passwd program" = "/run/wrappers/bin/passwd %u";

        workgroup = "WORKGROUP";
        security = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      #public = {
        #browseable = "yes";
        #comment = "Public samba share.";
        #"guest ok" = "yes";
        #path = "/srv/public";
        #"read only" = "yes";
      #};
    }; # End services.samba.settings

  }; # End services.samba

  services.gvfs = {
    enable = true;
    #package = lib.mkForce pkgs.gnome3.gvfs;
  };

  #fileSystems."/mnt/public" = {
  #  device = "//customdesktop/public";
  #  fsType = "cifs";

  #  # vim /etc/nixos/smb-secrets
  #  # username=nobody
  #  # domain=WORKGROUP
  #  # password=password123
  #  #options = let
  #  #    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #  #  in [
  #  #    "${automount_opts},credentials=/etc/nixos/smb-secrets"
  #  #  ];
  #  #
  #  options = [
  #    "x-systemd.automount"
  #    "noauto"
  #    "x-systemd.idle-timeout=60"
  #    "x-systemd.device-timeout=5s"
  #    "x-systemd.mount-timeout=5s"
  #  ];
  #};

  #fileSystems."/mnt/private" = {
  #  device = "//customdesktop/private";
  #  fsType = "cifs";
  #
  #  # vim /etc/nixos/smb-secrets
  #  # username=najib
  #  # domain=WORKGROUP
  #  # password=password123
  #  options = let
  #      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #    in [
  #      "${automount_opts},credentials=/etc/nixos/smb-secrets"
  #    ];
  #};

  fileSystems."/mnt/cifsshare" = {
    device = "//customdesktop/data";
    fsType = "cifs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

}
