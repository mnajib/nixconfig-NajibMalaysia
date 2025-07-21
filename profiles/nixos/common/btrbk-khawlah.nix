# vim: ts=4 sw=4 nowrap number:
#
# #btrbk.nix --> /etc/btrbk/btrbk.conf
# #OR
# btrbk.nix --> /etc/btrbk.conf
#

#{ config, pkgs, ...}:
{
	#sources ? import ./nix/sources.nix,
	#pkgs ? import sources.nixpkgs {},
	pkgs,

	config,
	...
}:
let
    # mkdir /mnt/btr_pool
    # mount -o subvolid=5,noatime /dev/mapper/vg2-lvroot2 /mnt/btr_pool1
    # btrfs subvolume list /mnt/btr_pool1
    # mkdir /mnt/btr_pool1/btr_snapshots
    btrfsVolume1 = "/mnt/btr_pool1";
    btrfsVolume2 = "/mnt/btr_pool2";
in {

	fileSystems.${btrfsVolume1} = {
        device = "/dev/disk/by-uuid/33b059ad-860f-4ebd-a44b-e0544ac30b82";
		fsType = "btrfs";
		options = [
			"subvolid=5" "compress=zstd" "noatime" "autodefrag"
			"rw" "ssd"
		];
        };

	#fileSystems.${btrfsVolume2} = {
        #device = "/dev/mapper/vg2-lvroot2";
	#	fsType = "btrfs";
	#	options = [
	#		"subvolid=5" "compress=zstd" "noatime" "autodefrag"
	#		"rw" "ssd"
	#	];
        #};

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

		volume						${btrfsVolume1}				# <------ btrfs subvolume to be backup?
			subvolume				juliani         			# <------ btrfs subvolume to be backup?
				snapshot_dir			btr_snapshots   			# <------ where to put snapshots
				#target send-receive 		ssh://tv/mnt/btr_backup/mahirah		# <------ Where to put backups
				#ssh_identity			/root/.ssh/btrbk/id_ed25519		#
				#target send-receive 		${btrfsVolume2}/btr_backups/keira	# <------ Where to put backups

			subvolume				root					#
				snapshot_dir			btr_snapshots     			# <------ where to put snapshots
				#target send-receive 		ssh://tv/mnt/btr_backup/mahirah		#
				#ssh_identity			/root/.ssh/btrbk/id_ed25519		#
				#target send-receive 		${btrfsVolume2}/btr_backups/keira	# <------ Where to put backups
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
