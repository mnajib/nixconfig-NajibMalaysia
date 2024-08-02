{
  pkgs,
  #config,
  ...
}:
{
  environment.systemPackages = [
    pkgs.grapejuice
  ];
}
