{	
	users.users.najib = {
		description = "Muhammad Najib Bin Ibrahim";
		uid = 1001;
		isNormalUser = true;
		#initialPassword = "password";
		createHome = true;
		home = "/home/najib";
		extraGroups = [ "wheel" "networkmanager" "istana46" "audio" "video" "cdrom"  "adbusers" "vboxusers" "scanner" "lp" "systemd-journal" "najib" "julia" "naqib" "nurnasuha" "naim" "input" "bluetooth"
			    #"fuse"
			    "dialout"
			    ];
		#shell = pkgs.zsh;
	};
}
