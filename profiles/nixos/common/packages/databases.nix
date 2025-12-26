{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    postgresql
    dbeaver-bin
    pgadmin4-desktopmode
    dbgate
  ];
}

