{ config, 
  #fetchurl, 
  ... 
}:
#let blocklist = fetchurl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
#in 
{
	networking.hosts = {

		# NOTE:
		# -----
		# DHCP range: 192.168.1.2/24 to 192.168.1.254/24						# Will be used for static IP
		# DHCP range: 192.168.1.100/24 to 192.168.1.199/24						# Served by TM router
		# DHCP range: 192.168.1.200/24 to 192.168.1.254/24						# Served by dnsmasq maryam

		"192.168.1.1" 	= [ "gw" ];												# dlink1, ubi
		"192.168.1.154"	= [ "raudah" ];											# Thinkpad-T400
		"192.168.1.4"	= [ "sakinah"];											# Thinkpad-X220 nurnasuha
		"192.168.1.174"	= [ "zahrah" ];											# Thinkpad-T410 (with nvdia graphic) naim
		"192.168.1.60"	= [ "decotamu" ];										# deco1, tplink1
		"192.168.1.105"	= [ "decobilik" ];										# deco2, tplink2
		"192.168.1.106"	= [ "dlinkkayu" ];										# dlinkkayuap, dlink2, kayu
		"192.168.1.10"	= [ "khadijah" ];										# Dell Precision 8400, delllaptop, najib
		"192.168.1.166"	= [ "khawlah" ];										# Thinkpad-X230
		"192.168.1.170"	= [ "redminote7" ];										# phonejulia
		"192.168.1.191"	= [ "delldesktop" ];									# Dell ... (My 1'st Dell Desktop)
		"192.168.1.245"	= [ "asmak" ];											# Thinkpad-T430 naqib
		"192.168.1.72"	= [ "mahirah" ];										# Thinkpad-T400, printsvr, scanner, filesvr
		"192.168.1.101"	= [ "keira" ];											# Thinkpad-T410, laptopjulia
		#"192.168.1."	= [ "manggis" ];										# Thinkpad x220, laptopjulia2, portable.
																				# Disabled here because our current dhcp (on wifi/gw/router/fw) limitation static ip to only small number of hosts.
		"192.168.1.171"	= [ "redmi9" ];											# phonenajib
		"192.168.1.22"	= [ "printer" ];										# printsvr, wirelessprinter, hplaserjet
		"192.168.1.21"	= [ "customdesktop" ];									# Custom desktop. My 2'nd GigaByte motherboard. gigabytez77, desktopz77
		#"192.168.1.20"	= [ "customdesktop2" ];									# My 1'st GigaByte motherboard.
																				# Not in service anymore Some chips on this board now getting too hot. gigabyteh61, desktoph61
		"192.168.1.2"	= [ "maryam" ];											# Thinkpad T61/R61 ?
		# aishah																# Thinkpad T61/R61 ?
		# husna																	#
	};

	#networking.hostFiles = [ blocklist ];
}
