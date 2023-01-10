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
}
