# btrbk-pull.nix --> /etc/btrbk.conf
# 
# With this, only 30 daily and 6 monthly snapshots are pulled and kept
# via (manually run) command
#   sudo btrbk run
#
# To test / dry run
#   btrbk -c /root/btrbk.conf --dry-run --verbose run
#   btrbk -c /root/btrbk.conf -v -n run
#

{ config, pkgs, ... }:
let
	# Mount point where the destination subvolumes will be mounted
	#backupLocation = (import ../private.nix).paths.backup + "/server-var";
	backupLocation = "/mnt/btr_backup/mahirah"; #"/mnt/btr_pool"; # Need: mkdir -p /btrbk_backups/mahirah
in {
	# XXX: Do mount subvolid=5 to /mnt/btr_pool
	#fileSystems.${backupLocation} = {
	fileSystems."/mnt/btr_backup" = {
		device = "/dev/mapper/lvmvg1-lvmlvroot1";
		#device = "/dev/disk/by-uuid/37501eaa-13b2-44ac-a8d8-4e62b7803cd5";
		fsType = "btrfs";
		options = [ "subvolid=5" "compress=zstd" "noatime" "autodefrag" ];
	};

	environment.etc."btrbk.conf".text = ''
		timestamp_format		long

		#snapshot_preserve_min   2d
		#snapshot_preserve      14d
		#snapshot_create ondemand		# Create snapshots only if the backup disk is attached
		#snapshot_dir			btr_backups # btrbk_snapshots
		snapshot_preserve_min		all
		snapshot_create			ondemand # no

		target_preserve_min		72h # no
		target_preserve			72h 30d 6m

		volume				ssh://mahirah/mnt/btr_pool/
		#volume				ssh://mahirah/
			ssh_identity			/root/.ssh/btrbk/id_ed25519

			# List source subvolumes to be snapshot AND/OR backup
			#subvolume			btrbk_snapshots/home.* #btrbk_snapshots/home* # source subvolume1
			subvolume			home # source subvolume1
			#subvolume			"btrbk_snapshots/home*" # source subvolume2
			#subvolume			"btrbk_snapshots/home*" # source subvolume3

			target send-receive		/mnt/btr_backup/mahirah
	'';
	environment.systemPackages = [ pkgs.btrbk ];
}
