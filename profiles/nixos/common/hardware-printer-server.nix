{ pkgs, config, ... }:
{
	services.printing.enable = true;
	
	services.printing.gutenprint = false;
	services.printing.drivers = with pkgs; [ gutenprint hplip splix ];
	
	services.printing.browsing = true;
	services.printing.defaultShared = true; # false
	services.printing.listenAddresses = [ "*:631" ];
	services.printing.allowFrom = [ "all" ];
	services.avahi.publish.enable = true;
	services.avahi.publish.userServices = true;
	services.avahi.enable = true;
	#services.avahi.nssmdns = true;

	networking.firewall.allowedUDPPorts = [ 631 ];
	networking.firewall.allowedTCPPorts = [ 631 ];
}
