# vim: ts=4 sw=4 nowrap number:
#
# #btrbk.nix --> /etc/btrbk/btrbk.conf
# #OR
# btrbk.nix --> /etc/btrbk.conf
#
# btrbk list all
#

#{ config, pkgs, ...}:
{
    sources ? import ./nix/sources.nix,
    pkgs ? import sources.nixpkgs {},
    config,
    ...
}:
let
    # NOTE: Need to create directory manually
    # mkdir /mnt/btrbk_pool1
    # #mount -o subvolid=5,noatime /dev/mapper/vg1-lvroot1 /mnt/btrbk_pool1
    # btrfs subvolume list /mnt/btr_pool1
    # mkdir -p /mnt/btr_pool1/btrbk_snapshots
    btrfsVolume1 = "/mnt/btrbk_pool1";                                            # btrfs subvolume base-dir from where need to be backup
    btrfsVolume2 = "/mnt/btrbk_pool2";                                            # btrfs subvolume base-dir to where to put the backup
in {

    fileSystems.${btrfsVolume1} = {
        #device = "/dev/mapper/vg1-lvroot1";
        device = "/dev/disk/by-uuid/15762a77-c5ef-4eb0-9a5e-946646691a37";
        fsType = "btrfs";
        options = [
            "subvolid=5" "compress=zstd"
            #"noatime"
            "autodefrag"
            "rw" "ssd"
        ];
    };

    #fileSystems.${btrfsVolume2} = {
    #    device = "/dev/mapper/vg2-lvroot2";
    #    fsType = "btrfs";
    #    options = [
    #        "subvolid=5" "compress=zstd" "noatime" "autodefrag"
    #        "rw" "ssd"
    #    ];
    #};

    environment.etc."btrbk.conf".text = ''
    # timestamp as postfix in subvolume name for snapshots and backups that will be created.
    timestamp_format                    long                                    # short, long, long-iso

    #transaction_log                    /var/log/btrbk.log
    #lockfile                           /run/lock/btrbk.lock

    # Rujukan: https://wiki.gentoo.org/wiki/Btrbk
    #
    #snapshot_preserve                   24h 7d 0w 0m 0y
    #snapshot_preserve_min               latest
    snapshot_preserve                   24h 7d 4w 3m 0y
    snapshot_preserve_min               latest
    #
    #target_preserve                     0h 14d 6w 4m 1y
    #target_preserve_min                 latest
    target_preserve                     no
    target_preserve_min                 no
    #
    #archive_preserve                    0h 1d 1w 1m 1y
    #archive_preserve_min                latest
    archive_preserve                    no
    archive_preserve_min                no

    # 'absolute path' of btrfs (source subvolume (base-dir?) to be backup)
    volume                              ${btrfsVolume1}                         # /mnt/btr_pool1

      #------------------------------------------------------------------------
      # 'btrfs subvolume' to be backup


        # Where to put snapshots
        snapshot_dir                    btrbk_snapshots                           # /mnt/btr_pool1/btr_snapshots/<snapshot_name>.<timestamp>
        snapshot_name                   home                                    # /mnt/btr_pool1/btr_snapshots/home.<timestamp>

        # Where to put backups
        #target send-receive            ${btrfsVolume2}/btrbk_backups/keira       # /mnt/btr_pool2/btr_backup/keira/<subVolume>.<timestamp>

        # Where to put backups
        ##target send-receive           ssh://tv/mnt/btrbk_backups/mahirah
        ##ssh_identity                  /root/.ssh/btrbk/id_ed25519

      #------------------------------------------------------------------------
      subvolume                         rootuserhome                            # /mnt/btr_pool1/rootuserhome

        # Where to put snapshots
        snapshot_dir                    btrbk_snapshots                           # /mnt/btr_pool1/btr_snapshots/<subvolume_name_OR_snapshot_name>.<timestamp>
        snapshot_name                   rootuserhome                            # /mnt/btr_pool1/btr_snapshots/rootuserhome.<timestamp>

        #target send-receive            ${btrfsVolume2}/btrbk_backups/keira       # /mnt/btr_pool2/btr_backups/keira/<subVolume>.<timestamp>

        ##target send-receive           ssh://tv/mnt/btrbk_backup/mahirah
        ##ssh_identity                  /root/.ssh/btrbk/id_ed25519
      #------------------------------------------------------------------------
    '';

    systemd.services.btrbk = {
        serviceConfig.ExecStart = "${pkgs.btrbk}/bin/btrbk run";
    };

    systemd.timers.btrbk = {
        wantedBy = [ "basic.target" ];
        timerConfig.OnCalendar = "00/3:00";
    };

    system.activationScripts.btrbk = {
        deps = [];
        text = "${pkgs.btrbk}/bin/btrbk --override group=profile-activation run";
    };

    environment.systemPackages = [ pkgs.btrbk ];
}
