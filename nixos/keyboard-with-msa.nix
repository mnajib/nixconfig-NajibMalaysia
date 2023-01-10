{
	#services.xserver.layout = "us,us,msa,msa";
	#services.xserver.xkbVariant = "dvorak,,najib,macnajib";
	services.xserver.layout = "us,us,msa";
	services.xserver.xkbVariant = "dvorak,,najib";

	services.xserver.xkbOptions = "grp:shift_caps_toggle";

	services.xserver.extraLayouts.msa = {
		description = "Arabic-Jawi Najib";
		languages = [ "msa" ];
		keycodesFile = ./xkb/keycodes/msa;
		typesFile = ./xkb/types/msa;
		compatFile = ./xkb/compat/msa;
		symbolsFile = ./xkb/symbols/msa;
		#geometryFile = ./xkb/geometry/msa; # irrelevant
	};
}
