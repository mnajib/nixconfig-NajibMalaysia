{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    sqlite
    sqlite-utils
    sqlitebrowser
  ];
}
