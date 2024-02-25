{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

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
