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
    device = "customdesktop:/nfsshare2";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"

      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.automount" "noauto"

      # Disconnects after 10 minutes (i.e. 600 seconds)
      "x-systemd.idle-timeout=600"

      # XXX:
      "noatime"
    ];
  };

  # mkdir -p /mnt/home/najib
  fileSystems."/mnt/home/najib" = {
    device = "customdesktop:/najib";
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
    device = "customdesktop:/julia";
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
    device = "customdesktop:/naqib";
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
    device = "customdesktop:/nurnasuha";
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
    device = "customdesktop:/naim";
    fsType = "nfs";
    options = [
      #"nfsvers=3"
      #"nfsvers=4.2"
      "x-systemd.automount" "noauto"      # Lazy-mounting: By default, all shares will be mounted right when your machine starts - apart from being simply unwanted sometimes, this may also cause issues when your computer doesn't have a stable network connection or uses WiFi; you can fix this by telling systemd to mount your shares the first time they are accessed (instead of keeping them mounted at all times): 
      "x-systemd.idle-timeout=600"        # Disconnects after 10 minutes (i.e. 600 seconds)
      "noatime"
    ];
  };

}
