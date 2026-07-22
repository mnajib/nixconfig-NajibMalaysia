# profiles/nixos/common/configuration.DESKTOP_LITE.nix

{
  config,
  pkgs,
  lib,
  ...
}:
{

  imports = [
    ./configuration.BASE.nix

    ./packages/desktop.nix
    ./packages/browsers.nix
    ./packages/editors.nix
    ./packages/filemanagers.nix
    ./packages/fonts.nix
    ./packages/calculators.nix
    ./packages/office_LITE.nix
    ./packages/csv-tools.nix
    ./packages/drivers.nix
    ./packages/communication.nix
  ];

  programs.java.enable = true;
  programs.dconf.enable = true;         # for gnome?
  hardware.acpilight.enable = true;

  services.urxvtd.enable = true;          # To use urxvtd, run "urxvtc".

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplip ]; # [ pkgs.hplipWithPlugin ];

}
