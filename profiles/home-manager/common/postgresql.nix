{
  inputs,
  outputs,
  #lib,
  config,
  pkgs,
  ...
}:
#let
#in
{
  #imports = [
  #];

  home.packages = with pkgs; [
    postgresql
    #pgadmin4
    pgadmin4-desktopmode
    dbgate
  ];

}
