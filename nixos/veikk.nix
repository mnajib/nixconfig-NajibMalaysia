
#
# import ./veikk.nix from configuration.nix
# this should provide a vktablet executable and entry in the application menu (.desktop). A widget will appear in the systray.
#

{ config, pkgs, ... } :
let veikk_driver = (pkgs.callPackage ./veikk_driver.nix {});
in
{
  environment.systemPackages = [ veikk_driver ];
  # Add udev rules... otherwise you will need root to install the driver.
  services.udev.packages = [ veikk_driver ];
}
