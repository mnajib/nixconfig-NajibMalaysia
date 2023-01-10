{
	#fileSystems."/mnt/sekolahgluster" = {
	#	device = "mahirah:/sekolahgluster";
	#	fsType = "nfs";
	#	options = [
	#		#"nfsvers=3"
	#		"x-systemd.automount"
	#		"noauto"
	#		"x-systemd.idle-timeout=600" # disconnects after 10 minutes (i.e. 600 seconds)
	#	];
	#};

	fileSystems."/mnt/sekolahdocdir" = {
		device = "mahirah:/sekolahdocdir";
		fsType = "nfs";
		options = [
			##"nfsvers=3"
			#"x-systemd.automount"
			"noauto"
			"x-systemd.idle-timeout=600" # disconnects after 10 minutes (i.e. 600 seconds)
		];
	};

	fileSystems."/mnt/documents" = {
		device = "mahirah:/documents";
		fsType = "nfs";
		options = [
			#"x-systemd.automount"
			"noauto"
			"x-systemd.idle-timeout=600"
		];
	};
}
