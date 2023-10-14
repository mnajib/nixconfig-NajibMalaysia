# NOTE:
# Once flatpak is installed, we need to add the flathub repo:
#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

{
  pkgs,
  #config,
  #lib,
  ...
}:{
  environment.systemPackages = [
    #pkgs.appimage-run-tests
    pkgs.appimage-run
    pkgs.appimagekit
  ];
}
