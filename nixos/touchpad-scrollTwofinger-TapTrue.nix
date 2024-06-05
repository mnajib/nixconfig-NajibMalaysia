{
	#services.xserver.libinput.enable = true;
	services.libinput.enable = true;

	#services.xserver.libinput.disableWhileTyping = true;
	#services.xserver.libinput.touchpad.disableWhileTyping = true;
	services.libinput.touchpad.disableWhileTyping = true;

	#services.xserver.libinput.scrollMethod = "twofinger";
	#services.xserver.libinput.touchpad.scrollMethod = "twofinger";
	services.libinput.touchpad.scrollMethod = "twofinger";

	#services.xserver.libinput.tapping = true;
	#services.xserver.libinput.touchpad.tapping = true;
	services.libinput.touchpad.tapping = true;
}
