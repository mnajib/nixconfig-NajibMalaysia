{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sqlite
    sqlite-utils

    sqlite-jdbc

    unixODBC
    unixODBCDrivers.sqlite

    sqlitebrowser
    sqlitestudio
    sqlite-web

    sqlite-analyzer

    sqitchSqlite
  ];
}
