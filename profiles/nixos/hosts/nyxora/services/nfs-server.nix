#
# NOTE:
#
# showmount -e remote_nfs_server
# showmount -e localhost
#
# systemctl list-dependencies --fater timers.target
# systemctl list-dependencies --before sysstat-collect.timer
#
# netstat -tulpen
# rpcinfo -p
#

{config, pkgs, ... }:
let
  # Define the base path here so you only have to change it once later
  migrationPath = "/MyTank/shared/data/garden_migration";
in
{
  boot.kernelModules = [
    "nfsd"
    "lockd"
  ];

  #----------------------------------------------------------------------------
  # 1. Mount the primary ZFS dataset

  fileSystems."/mnt/data" = {
    device = "MyTank/shared/data/garden_migration"; # "Garden/home"; #"najibzfspool1/home";
    fsType = "zfs";
    options = [
      #"x-systemd.before=export-nfsshare2.automount" #???
      "nofail"
    ];
  };

  #----------------------------------------------------------------------------
  # 2. Bind Mounts for NFS Exports

  # Ensure the mount points are created by the system
  # Ensure the /export directory and subdirectories exist
  systemd.tmpfiles.rules = [
    "d /mnt/data 0755 root root -"
    "d /export 0755 root root -"
    "d /export/nfsshare2 0755 root root -"
    "d /export/batocera 0755 root root -"
    "d /export/nixforbatocera 0755 root root -"
    "d /export/najib 0755 root root -"
    "d /export/julia 0755 root root -"
    "d /export/naqib 0755 root root -"
    "d /export/nurnasuha 0755 root root -"
    "d /export/naim 0755 root root -"
  ];

  fileSystems."/export/nfsshare2" = {
    #device = "/home/nfs/share";
    device = "/mnt/data/nfs/share";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"noatime"
      #"nofail"
      #"xsystemd.after=mnt-data.automount"
      #"x-systemd.before=local-fs.target"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/batocera" = {
    #device = "/home/nfs/batocera/userdata";
    device = "/mnt/data/nfs/batocera/userdata";
    options = [
      "bind"
      #"x-systemd.automount"
      "noauto"
      "x-systemd.automount"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/nixforbatocera" = {
    #device = "/home/nfs/batocera/nix";
    device = "/mnt/data/nfs/batocera/nix";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/najib" = {
    #device = "/home/najib";
    device = "/mnt/data/najib";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/julia" = {
    #device = "/home/julia";
    device = "/mnt/data/julia";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/naqib" = {
    #device = "/home/naqib";
    device = "/mnt/data/naqib";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/nurnasuha" = {
    #device = "/home/nurnasuha";
    device = "/mnt/data/nurnasuha";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  fileSystems."/export/naim" = {
    #device = "/home/naim";
    device = "/mnt/data/naim";
    options = [
      "bind"
      "x-systemd.automount"
      "noauto"
      #"xsystemd.after=mnt-data.automount"
      "x-systemd.before=nfs-server.service"
    ];
  };

  #----------------------------------------------------------------------------

  # NFS Server
  services.nfs.server = {
    enable = true;

    # Fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;

    createMountPoints = true;

      #/export                   *(rw,fsid=0,no_subtree_check,fsid=0)
    exports = ''
      /export                   *(rw,fsid=0,no_subtree_check)
      /export/nfsshare2         *(rw,nohide,insecure,no_subtree_check)
      /export/batocera          *(rw,nohide,insecure,no_subtree_check)
      /export/najib             *(rw,nohide,insecure,no_subtree_check)
      /export/julia             *(rw,nohide,insecure,no_subtree_check)
      /export/naqib             *(rw,nohide,insecure,no_subtree_check)
      /export/nurnasuha         *(rw,nohide,insecure,no_subtree_check)
      /export/naim              *(rw,nohide,insecure,no_subtree_check)
    '';
  };

  #----------------------------------------------------------------------------

  networking.firewall = {
    # for NFSv3; view with 'rpcinfo -p'
    allowedTCPPorts = [
      111   # rpcbind (Portmapper). Maps RPC program numbers to their current port numbers. Essential for NFS.
      2049  # NFS. The primary port for file sharing (NFS Daemon).
      4000  # rpc.statd (Status Daemon). NFS Component: Handles server reboot notifications. (Custom port)
      4001  # rpc.lockd (Lock Daemon). Daemon) NFS Component: Handles file locking requests. (Custom port)
      4002  # rpc.mountd (Mount Daemon). NFS Component: Handles file system mounting requests. (Custom port). The default port is 20048.
      #20048 # NFS Mount Daemon (mountd)
    ];
    allowedUDPPorts = [
      111   # portmapper
      2049  # nfs
      4000  # status (rpc.statd)
      4001  # nlockmgr (rpc.lockd)
      4002  # mountd (rpc.mountd)
      #20048
    ];
  };

  #----------------------------------------------------------------------------

}
