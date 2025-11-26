{ pkgs, ... }:
{
  environment.unixODBCDrivers = with pkgs.unixODBCDrivers; [
    sqlite
    psql
    mariadb
    #mysql
    msodbcsql18
    #msodbcsql17
    #redshift
  ];

  environment.systemPackages = with pkgs; [
    firmware-updater
    firmware-manager
    fwts
    gnome-firmware
    linux-firmware
    fwup
    fwupd
    fwupd-efi
  ];
}

