{
    users.users.naqib = {
        description = "Muhammad Naqib Bin Muhammad Najib";
        uid = 1003;
        isNormalUser = true;
        #initialPassword = "password";
        createHome = true;
        home = "/home/naqib";
        extraGroups = [
		"networkmanager" "audio" "video" "cdrom" "scanner" "lp" "systemd-journal"
		"istana46" "naqib"
		"dialout"
	];
    };
    users.users.nurnasuha= {
        description = "Nur Nasuha Binti Muhammad Najib";
        uid = 1004;
        isNormalUser = true;
        #initialPassword = "password";
        createHome = true;
        home = "/home/nurnasuha";
        extraGroups = [
		"networkmanager" "audio" "video" "cdrom" "scanner" "lp" "systemd-journal"
		"istana46" "nurnasuha"
		"dialout"
	];
    };
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
