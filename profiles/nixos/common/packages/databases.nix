{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    postgresql
    dbeaver-bin
    beekeeper-studio
    pgadmin4-desktopmode
    dbgate
  ];
}

