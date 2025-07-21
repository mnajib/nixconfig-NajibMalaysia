# WARNING: if you want to install this driver for the Veikk, make sure to either run it as root (to avoid issues with udev rules)
# or (to get udev rule loaded) to add it in `services.udev.packages. For now, all models seems to use the same file, but in case of doubt double check here
# https://www.veikk.com/support/download.html
# Make sure to run a single instance.
{ stdenv, lib, fetchurl, dpkg, libusb, autoPatchelfHook, libGL, glib, fontconfig, libXi, libX11, dbus, makeWrapper, xkeyboard_config }:
stdenv.mkDerivation rec {
  name = "-${version}";
  version = "";

  # This is like 20M, so it can take some time
  src = fetchurl {
    url = "https://www.veikk.com/upload/file/20211217/vktablet-1.0.3-2-x86_64.deb";
    sha256 = "sha256-UcjWqVcnCPhfaHGFWJc/LmQspSpeU8rfy3U5VJ55sRg=";
  };

  buildInputs = [ dpkg libusb autoPatchelfHook libGL stdenv.cc.cc.lib glib libX11 libXi dbus fontconfig makeWrapper xkeyboard_config];

  unpackPhase = ''
    echo "Unpacking";
    dpkg -x "$src" .
  '';

  installPhase = ''
    mkdir -p $out
    mv usr/lib $out/opt # contains the main executable
    mv usr/share $out/share # Contains the desktop file
    mv lib $out/lib # Contains udev rules
    substituteInPlace $out/share/applications/vktablet.desktop \
      --replace "Exec=/usr/lib/vktablet/vktablet" "Exec=$out/opt/vktablet/vktablet" \
      --replace "Icon=/usr/lib/vktablet/vktablet.png" "Icon=$out/opt/vktablet/vktablet.png"
    makeWrapper $out/opt/vktablet/vktablet $out/bin/vktablet \
      --set QT_XKB_CONFIG_ROOT ${xkeyboard_config}/share/X11/xkb
  '';
  
  meta = {
    description = "Official drivers for Veikk tablets (provides pen configuration, pressure map, key mapping, screen mapping...)";
    homepage = https://www.veikk.com/support/download.html;
    license = lib.licenses.unfree; # Supposed to be open source (GPL), but source can't be found online even when requested by users.
    maintainers = [ lib.maintainers.tobiasBora ];
    platforms = lib.platforms.linux;
  };
}
