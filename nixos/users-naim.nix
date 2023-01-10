{
    users.users.naim= {
        description = "Muhammad Na'im Bin Muhammad Najib";
        uid = 1005;
        isNormalUser = true;
        #initialPassword = "password";
        createHome = true;
        home = "/home/naim";
        extraGroups = [
		"networkmanager" "audio" "video" "cdrom" "scanner" "lp" "systemd-journal"
		"istana46" "naim"
		"dialout"
	];
    };
}
