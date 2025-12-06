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

      idna
      iagl
      trakt
      trakt-module
      arrow
      keymap
      future
      svtplay
      signals
      pvr-hts
      pvr-hdhomerun
      pvr-iptvsimple
      chardet
      certifi
      vfs-sftp
      vfs-libarchive
      myconnpy
      libretro
      libretro-mgba
      libretro-snes9x
      libretro-genplus
      kodi-six
      kodi-platform
      joystick
      #jellyfin
      dateutil
      websocket
      pdfreader
      osmc-skin
      orftvthek
      invidious
      xbmcswift2
      simplejson
      defusedxml
      arteplussept
      archive_tool
      steam-library
      steam-launcher
      steam-controller
      typing_extensions
      visualization-waveform
      #controller-topology-project
    ]) )
  ];

  users = { users = { kodi = { isNormalUser = true; }; }; };
}
