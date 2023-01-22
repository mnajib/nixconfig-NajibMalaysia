{ pkgs, config, ... }:
{
  home.packages = [
    pkgs.atop
    pkgs.gnome.gnome-disk-utility
    pkgs.fortune
    pkgs.mgba
    pkgs.zeal               		# Offline API documentation browser for software developers
    pkgs.broot              		# something like tree command
    pkgs.xorg.xdpyinfo
    pkgs.xorg.xwininfo
    pkgs.mc
    pkgs.ncdu               		# Disc space usage analyzer
    pkgs.diskonaut          		# Disk space usage analyzer
    pkgs.bc
    pkgs.rlwrap             		# A readline wrapper
    pkgs.unzip
    pkgs.wget
    pkgs.gnupg
    pkgs.translate-shell    		# CLI translator using Google Translate, Bing Translator, ...
    pkgs.whois
    pkgs.youtube-dl
    pkgs.coreutils
    pkgs.dzen2              		# A general purpose messaging, notification and menuing program for X11
    pkgs.vis
    pkgs.handlr
    pkgs.ranger
    pkgs.broot
    pkgs.termonad
    pkgs.tmux
    pkgs.mosh
    pkgs.pavucontrol
    pkgs.libreoffice
    pkgs.xournal
    pkgs.xournalpp
    pkgs.inkscape 			#pkgs.unstable.inkscape
    pkgs.imagemagick
    pkgs.pandoc
    pkgs.texlive.combined.scheme-tetex
    pkgs.ardour 			#pkgs.unstable.ardour
    pkgs.simplescreenrecorder
    pkgs.obs-studio
    pkgs.firefox
    pkgs.brave 				#pkgs.unstable.brave 	# web browser
    pkgs.tuir 				#pkgs.rtv     # Browse Reddit from terminal
    pkgs.qtox
    pkgs.zoom-us
    pkgs.pass               		# CLI password manager
    pkgs.vlc
    pkgs.shutter            		# Screenshots
    pkgs.zathura            		# Document viewer
    pkgs.dropbox 			#pkgs.unstable.dropbox
    pkgs.wpa_supplicant_gui
    pkgs.qucs               		# Integrated circuit simulator
    pkgs.ngspice            		# The Next Generation Spice (Electronic Circuit Simulator)
    pkgs.fritzing
  ];
}
