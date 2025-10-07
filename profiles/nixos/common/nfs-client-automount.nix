{
  config,
  pkgs,
  ...
}:
{
  #fileSystems."/mnt/sekolahgluster" = {
  #  device = "mahirah:/sekolahgluster";
  #  fsType = "nfs";
  #  options = [
  #    #"nfsvers=3"
  #    x-systemd.automount"
  #    #"noauto"
  #    "x-systemd.idle-timeout=600" # disconnects after 10 minutes (i.e. 600 seconds)
  #  ];
  #};

  #fileSystems."/mnt/sekolahdocdir" = {
  #  device = "mahirah:/sekolahdocdir";
  #  fsType = "nfs";
  #  options = [
  #    #"nfsvers=3"
  #    #"nfsvers=4.2"
  #
  #    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
  #    "x-systemd.automount" "noauto"
  #
  #    # Auto-disconnecting: Disconnects after 10 minutes (i.e. 600 seconds)
  #    "x-systemd.idle-timeout=600"
  #
  #    # XXX:
  #    "noatime"
  #  ];
  #};

  #fileSystems."/mnt/documents" = {
  #  device = "mahirah:/documents";
  #  fsType = "nfs";
  #  options = [
  #    #"nfsvers=3"
  #    #"nfsvers=4.2"
  #
  #    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
  #    "x-systemd.automount" "noauto"
  #
  #    # Disconnects after 10 minutes (i.e. 600 seconds)
  #    "x-systemd.idle-timeout=600"
  #
  #    # XXX:
  #    "noatime"
  #  ];
  #};

  fileSystems."/mnt/nfsshare2" = {
    #device = "customdesktop:/nfsshare2";
    device = "customdesktop.localdomain:/nfsshare2";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"

      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.automount"
      "noauto"

      # Disconnects after 10 minutes (i.e. 600 seconds)
      "x-systemd.idle-timeout=600"

      # XXX:
      "noatime"

      "_netdev"
      "soft"
      "timeo=30"
      "retrans=3"
      "intr"
      "vers=4.2"
    ];
  };

  # mkdir -p /mnt/home/najib
  fileSystems."/mnt/home/najib" = {
    device = "customdesktop.localdomain:/najib";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

  # mkdir -p /mnt/home/julia
  fileSystems."/mnt/home/julia" = {
    device = "customdesktop.localdomain:/julia";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

  # mkdir -p /mnt/home/naqib
  fileSystems."/mnt/home/naqib" = {
    device = "customdesktop.localdomain:/naqib";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

  # mkdir -p /mnt/home/nurnasuha
  fileSystems."/mnt/home/nurnasuha" = {
    device = "customdesktop.localdomain:/nurnasuha";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

  # mkdir -p /mnt/home/naim
  fileSystems."/mnt/home/naim" = {
    device = "customdesktop.localdomain:/naim";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

  # Ensure mountpoint directory exists ---
  systemd.tmpfiles.rules = [
    "d /mnt/nfsshare2 0755 root root -"
  ];

  # Optional: health-check + remount timer
  systemd.services.nfs-remount = {
    description = "Check and remount NFS share if unreachable";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "check-nfs" ''
        #!/usr/bin/env bash
        set -eu

        MOUNTPOINT="/mnt/nfsshare2"

        # Ensure mountpoint exists
        if [ ! -d "$MOUNTPOINT" ]; then
          echo "[$(date)] Creating mountpoint: $MOUNTPOINT"
          mkdir -p "$MOUNTPOINT"
        fi

        # Check if NFS is mounted
        if ! mountpoint -q "$MOUNTPOINT"; then
          echo "[$(date)] Not mounted. Trying to mount..."
          mount "$MOUNTPOINT"
          exit 0
        fi

        # Check if accessible
        if ! timeout 5 ls "$MOUNTPOINT" &>/dev/null; then
          echo "[$(date)] Mount unreachable. Remounting..."
          umount -f "$MOUNTPOINT" || umount -l "$MOUNTPOINT"
          mount "$MOUNTPOINT"
        else
          echo "[$(date)] NFS OK"
        fi
      '';
    };
  };

  # Timer to run the above check periodically
  systemd.timers.nfs-remount = {
    description = "Periodic NFS remount check";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2m";
      OnUnitActiveSec = "5m";
      AccuracySec = "30s";
    };
  };

}
