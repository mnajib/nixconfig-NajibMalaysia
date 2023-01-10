{ config, pkgs, lib, ... }:
{
    environment.systemPackages = with pkgs; [
        ( kodi.withPackages (kodiPkgs: with kodiPkgs; [
	    youtube
	    netflix
	    inputstream-adaptive
	    inputstreamhelper
	    inputstream-ffmpegdirect
	    inputstream-rtmp
	    urllib3
	    routing
	    requests-cache
	    requests
	    kodi
	    a4ksubtitles
	    ]) )
    ];

    users = { users = { kodi = { isNormalUser = true; }; }; };
}
