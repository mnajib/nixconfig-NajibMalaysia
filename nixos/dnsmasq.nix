# NOTE
#
# sudo systemctl restart dnsmasq
# cat /var/lib/misc/dnsmasq.leases
# sudo journalctl -u dnsmasq.service
#

{
	services.dnsmasq = {
		enable = true;
		resolveLocalQueries = true; # resolv localhost/127.0.0.1 queries
		servers = [
			#"/.localdomain/127.0.0.1"
			#"/fooxample.com/192.168.0.1"
			"1.1.1.1"
			"1.0.0.1"
			#"8.8.8.8" # Google
			#"8.8.4.4" # Google
			#"208.67.220.220" # OpenDNS
		];
		extraConfig = ''
			#interface=enp0s25
			#interface=wls3
			#listen-address=127.0.0.1
			#listen-address=192.168.1.17
			bind-interfaces
			port=53

			#dhcp-range=192.168.123.200,192.168.123.250,24h
			#dhcp-range=en0s25,192.168.123.100,192.168.123.150,24h
			#dhcp-range=wls3,192.168.1.100,192.168.1.199,24h # Currently assign by out tm router
			#dhcp-range=wls3,192.168.1.200,192.168.1.250,24h
			dhcp-range=wls3,192.168.1.200,192.168.1.250,2m # XXX: 2 minutes; for testing

			# Static IPs
			#dhcp-host=ab:cd:ef:12:34:56,example-host,192.168.1.10,infinite
			dhcp-host=9c:30:5b:d6:b8:f4,printer,192.168.1.22,infinite
			dhcp-host=00:21:86:9f:d9:91,mahirah,192.168.1.72,infinite
			dhcp-host=e8:48:b8:cd:68:68,decotamu,192.168.1.60,infinite
			dhcp-host=00:13:e8:d1:5b:dd,maryam,192.168.1.2,infinite

			# Prevent packets with malformed domain names and packets
			# with private IP addresses from leaving your network.
			domain-needed 	# Blocks incomplete requests from leaving your
							# network, such as google instead of google.com
			bogus-priv		# Prevents non-routable private addresses from
							# being forwarded out of your network.

			# Limits name services exclusively to Dnsmasq, and it
			# will not use /etc/resolv.conf or any other system
			# name service files.
			no-resolv

			#
			expand-hosts
			#domain=mehxample.com
			#domain=localdomain
			domain=local

			# Restrict just local domains while allowing external
			# lookups for other domains. These are answered only
			# from /etc/hosts or DHCP.
			#local=/mehxample.com/
			#local=/fooxample.com/
			local=/local/		# Ensures that queries for your private
								# domain are only answered by Dnsmasq,
								# from /etc/hosts or DHCP.

			# If Dnsmasq will be the only DHCP server in your network
			#dhcp-authoritative
		'';
	};

	services.resolved.domains = [
		#"localdomain"
		"local"
	];

	#environment.etc."dnsmasq.conf".text = ''
	#	server=1.1.1.1
	#	server=1.0.0.1
	#	server=8.8.8.8
	#	server=4.4.4.4
	#'';
}
