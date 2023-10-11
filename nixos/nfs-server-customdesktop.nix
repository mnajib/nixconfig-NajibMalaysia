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
  #fileSystems."/export/sekolahdocdir" = {
  #  device = "/home/najib/Documents/2021-01-21 Sekolah 2021";
  #  options = [
  #    "bind"
  #    #"nfsvers=3"
  #    "x-systemd.automount"
  #    "noauto"
  #    #"x-systemd.idle-timeout=600" # # disconnects after 10 minutes (i.e. 600 seconds)
  #  ];
  #};

  #fileSystems."/export/documents" = {
  #  device = "/home/najib/Documents";
  #  options = [
  #    "bind"
  #    "x-systemd.automount"
  #    "noauto"
  #  ];
  #};

  fileSystems."/export/nfsshare2" = {
    device = "/home/nfs/share";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/batocera" = {
    device = "/home/nfs/batocera/userdata";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/najib" = {
    device = "/home/najib";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/julia" = {
    device = "/home/julia";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/naqib" = {
    device = "/home/naqib";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/nurnasuha" = {
    device = "/home/nurnasuha";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  fileSystems."/export/naim" = {
    device = "/home/naim";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
    ];
  };

  # NFS Server
  services.nfs.server = {
    enable = true;

    # Fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;

    #extraNfsdConfig = ''
    #'';

    #/export/sekolahgluster     *(rw,nohide,insecure,no_subtree_check,fsid=1)
    #/export/sekolahdocdir      *(rw,nohide,insecure,no_subtree_check)
    #/export/documents          *(rw,nohide,insecure,no_subtree_check)

    exports = ''
      /export                   *(rw,fsid=0,no_subtree_check,fsid=0)
      /export/nfsshare2         *(rw,nohide,insecure,no_subtree_check)
      /export/batocera          *(rw,nohide,insecure,no_subtree_check)
      /export/najib             *(rw,nohide,insecure,no_subtree_check)
      /export/julia             *(rw,nohide,insecure,no_subtree_check)
      /export/naqib             *(rw,nohide,insecure,no_subtree_check)
      /export/nurnasuha         *(rw,nohide,insecure,no_subtree_check)
      /export/naim              *(rw,nohide,insecure,no_subtree_check)
    '';
  };

  networking.firewall = {
    # for NFSv3; view with 'rpcinfo -p'
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
  };
}
