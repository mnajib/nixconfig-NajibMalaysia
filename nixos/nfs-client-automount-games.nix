{

  # batocera userdata
  # mkdir -p /mnt/batocera/userdata
  fileSystems."/mnt/batocera/userdata" = {
    device = "customdesktop:/batocera";
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

  #fileSystems."/mnt/games" = {
  #  device = "customdesktop:/games";
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

}
