{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    qgis
    grass

  ];
}

