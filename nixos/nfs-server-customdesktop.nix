{
  # Mount gluster volume
  #fileSystems."/mnt/gluster" = {
  #  device = "mahirah:/sekolah";
  #  fsType = "fuse.glusterfs";
  #  options = [
  #    "x-systemd.automount"
  #    "noauto"
  #  ];
  #};

  # Kumpul directory untuk NFS service di /export
  #fileSystems."/export/sekolahgluster" = {
  #  device = "/mnt/gluster";
  #  options = [
  #    "bind"
  #    #"nfsvers=3"
  #    "x-systemd.automount"
  #    "noauto"
  #    #"x-systemd.idle-timeout=600" # # disconnects after 10 minutes (i.e. 600 seconds)
  #  ];
  #};

  # Kumpul directory untuk NFS service di /export
  fileSystems."/export/sekolahdocdir" = {
    device = "/home/najib/Documents/2021-01-21 Sekolah 2021";
    options = [
      "bind"
      #"nfsvers=3"
      "x-systemd.automount"
      "noauto"
      #"x-systemd.idle-timeout=600" # # disconnects after 10 minutes (i.e. 600 seconds)
    ];
  };

  fileSystems."/export/documents" = {
    device = "/home/najib/Documents";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  # NFS Server
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export      *(rw,fsid=0,no_subtree_check,fsid=0)
    #/export/sekolahgluster  *(rw,nohide,insecure,no_subtree_check,fsid=1)
    /export/sekolahdocdir  *(rw,nohide,insecure,no_subtree_check)
    /export/documents  *(rw,nohide,insecure,no_subtree_check)
  '';
}
