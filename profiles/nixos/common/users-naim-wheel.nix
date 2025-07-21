# NOTE:
# Flathub is the best place to get Flatpak apps.
# To enable it, run:
# flatpat remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

{
  pkgs,
  ...
}:
{
  users.users.naim= {
    description = "Muhammad Na'im Bin Muhammad Najib";
    uid = 1005;
    isNormalUser = true;
    #initialPassword = "password";
    createHome = true;
    home = "/home/naim";
    extraGroups = [
      "networkmanager" "audio" "video" "cdrom" "scanner" "lp" "systemd-journal" "bluetooth"
      "istana46" "naim"
      "dialout"
      "wheel"
      "input" "uinput" # kmonad keyboard
    ];

    #packages = with pkgs; [
    #  flatpak
    #  gnome.gnome-software
    #];
  };
}
