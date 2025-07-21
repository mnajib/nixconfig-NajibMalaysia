#
# btrbk.nix --> /etc/btrbk/btrbk.conf
# OR
# btrbk.nix --> /etc/btrbk.conf
#

{ config, pkgs, ...}:
let
    # mkdir /mnt/btr_pool
    # mount -o subvolid=5,noatime /dev/mapper/vg1-lvroot1 /mnt/btr_pool
    # btrfs subvolume list /mnt/btr_pool
    # mkdir /mnt/btr_pool/btrbk_snapshots
    btrfsVolume = "/mnt/btr_pool";
in {

    # Do mount the subvolid=5 to /mnt/btr_pool    
    fileSystems.${btrfsVolume} = {
    #fileSystems."/mnt/btr_pool" = {
        device = "/dev/mapper/vg1-lvroot1";
	fsType = "btrfs";
	options = [ "subvolid=5" "compress=zstd" "noatime" "autodefrag" ];
    };

    environment.etc."btrbk.conf".text = ''
        timestamp_format                long # short, long, long-iso
	#transaction_log            	/var/log/btrbk.log
	#lockfile                   	/run/lock/btrbk.lock

	# Rujukan: https://wiki.gentoo.org/wiki/Btrbk
	snapshot_preserve          	24h 7d 0w 0m 0y
	snapshot_preserve_min      	latest
	target_preserve            	0h 14d 6w 4m 1y
	target_preserve_min        	latest
	archive_preserve           	0h 1d 1w 1m 1y
	archive_preserve_min       	latest

	#snapshot_preserve_min           72h			# 6 days
	#snapshot_preserve               72h 30d 6m		# Keep hourly snapshots around for 72h, daily ones for 30d and monthly ones for 6m.
	#target_preserve_min		72h			# no
	#target_preserve			72h 30d 6m		#

	volume				${btrfsVolume}		# <------ btrfs subvolume to be backup?
	    subvolume			home                   	# <------ btrfs subvolume to be backup?
	    	snapshot_dir		btrbk_snapshots     	# <------ where to put snapshots
	    	# XXX: Temporary disable remote backup as harddisk on remote host failure.
		#target send-receive 	ssh://tv/mnt/btr_backup/mahirah
	   	#ssh_identity		/root/.ssh/btrbk/id_ed25519
	    subvolume			root
	    	snapshot_dir		btrbk_snapshots     	# <------ where to put snapshots
	    	# XXX: Temporary disable remote backup as harddisk on remote host failure.
	    	#target send-receive 	ssh://tv/mnt/btr_backup/mahirah
	    	#ssh_identity		/root/.ssh/btrbk/id_ed25519
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
