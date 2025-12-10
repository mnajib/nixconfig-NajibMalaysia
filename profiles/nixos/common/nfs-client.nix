{
  config,
  pkgs,
  lib,
  ...
}:

{

  imports = [
    ./nfs-client-automount.nix
  ];

  fileSystems."/mnt/nfsshare2".options = lib.mkForce [
    #"nfsvers=3"
    #"nfsvers=4.2"

    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
    #"x-systemd.automount"
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

  # mkdir -p /mnt/home/najib
  fileSystems."/mnt/home/najib".options = lib.mkForce [
      #"nfsvers=3"
      #"nfsvers=4.2"

      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
      #"x-systemd.automount"
      "noauto"

      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
  ];

  # mkdir -p /mnt/home/julia
  fileSystems."/mnt/home/julia".options = lib.mkForce [
    #"nfsvers=3"
    #"nfsvers=4.2"

    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
    #"x-systemd.automount"
    "noauto"

    "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
    "noatime"
  ];

  # mkdir -p /mnt/home/naqib
  fileSystems."/mnt/home/naqib".options = lib.mkForce [
    #"nfsvers=3"
    #"nfsvers=4.2"

    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
    #"x-systemd.automount"
    "noauto"

    "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
    "noatime"
  ];

  # mkdir -p /mnt/home/nurnasuha
  fileSystems."/mnt/home/nurnasuha".options = lib.mkForce [
    #"nfsvers=3"
    #"nfsvers=4.2"

    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
    #"x-systemd.automount"
    "noauto"

    "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
    "noatime"
  ];

  # mkdir -p /mnt/home/naim
  fileSystems."/mnt/home/naim".options = lib.mkForce [
    #"nfsvers=3"
    #"nfsvers=4.2"

    # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times):gc
    #"x-systemd.automount"
    "noauto"

    "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
    "noatime"
  ];

}
