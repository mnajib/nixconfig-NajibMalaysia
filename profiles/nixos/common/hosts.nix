{
	networking.hosts = {
		# DHCP range: 192.168.123.10/24 to 192.168.123.100/24

		# gateway, router
		"192.168.123.1" 	= [ "gw"		"gw.l7.local" ];		# CC:B2:55:D7:4D:B9 (wireless), CC:B2:55:D6:4D:B9 (LAN)

		# mahirah, gitrepo, file-server, scanner, T400
		#"192.168.123.57" 	= [ "mahirah"		"mahirah.t400.local" ];         # 00:21:5D:98:9F:30 (wireless)
		#										# wired
		"192.168.123.157"	= [ "mahirah"		"mahirah.t400.local" ];		# alias

		# sakinah, Laptop Nur Nasuha, T61
		#"192.168.123.59" 	= [ "sakinah"		"sakinah.t400.local" ];		# 00:22:FA:BC:5A:6C (wireless)
		"192.168.123.159" 	= [ "sakinah"		"sakinah.t400.local" ];		# alias

		# ...?
		#"192.168.123.53" 	= [ "leila"		"leila.t60.local" ];            # 00:1C:BF:01:C8:33 (wireless)

		# zahrah, Laptop Na'im, R61
		#"192.168.123.55" 	= [ "zahrah"		"zahrah.r61.local" ];           # 00:1F:3C:73:53:C9 (wireless)
		"192.168.123.155" 	= [ "zahrah"		"zahrah.r61.local" ];           # alias

		# tv
		#"192.168.123.132" 	= [ "tv2"		"tv2.desktop.local" ];          # 50:E5:49:CF:F0:B1 (LAN) 192.168.123.151
		"192.168.123.151"	= [ "tv"		"tv.desktop.local"];		# alias
		#...										# usb wireless dongle

		# keira, T410
		#"192.168.123.58" 	= [ "keira"		"keira.t410.local" ];		# 00:23:14:24:A1:C4 (wireless)
		"192.168.123.158"	= [ "keira"		"keira.t410.local" ];		# alias

		# ...?
		#"192.168.123.60" 	= [ "maryam"		"maryam.t61.local" ];		# 00:13:E8:5E:7E:85 (wireless)

		# Phone Xiaomi RedmiNote7
		"192.168.123.170" 	= [ "redminote7"	"redminote7.redmi.local" ];	# ... (wireless)

		# Phone Xiaomi Redmi9
		"192.168.123.171" 	= [ "redmi9"		"redmi9.redmi.local" ];		# ... (wireless)

		# asmak, Laptop Naqib, T400
		#"192.168.123.54" 	= [ "asmak2"		"asmak2.t400.local" ];		# 00:1e:65:f0:09:ae (wireless)
		#"192.168.123.24"	= [ "asmak3"		"asmak3.t400.local"];		# wired ethernet
		"192.168.123.153"	= [ "asmak"		"asmak.t400.local"];		# alias

		# aisyah, T430s
		"192.168.123.152"	= [ "aisyah" 		"aisyah.t430s.local" ];		# alias
		#...										# ethernet, wired
		#"192.168.123.23"	= [ "aisyah2"		"aisyah2.t430s.local" ];	# wireless

		# khadijah, DELL Precision M4800
		"192.168.123.160"	= [ "khadijah"		"khadijah.m4800.local" ];	#

		#"34.102.176.172"	= [ "taming.io" "crazygames.com" "www.crazygames.com" ];

		# Thinkpad X220, RM575, USJ, 2021-10-24
		"192.168.123.161"	= [ "manggis" "manggis.x220.local" ];
	};
}
