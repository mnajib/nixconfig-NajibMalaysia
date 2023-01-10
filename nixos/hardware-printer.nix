{ pkgs, config, ... }:
{
	# Enable CUPS to print docoments.
	services.printing.enable = true;
	services.printing.browsing = true;
	services.printing.defaultShared = false;
	services.printing.drivers = with pkgs; [ gutenprint hplip splix ];
	services.avahi.enable = false;
	services.avahi.nssmdns = false;
}
