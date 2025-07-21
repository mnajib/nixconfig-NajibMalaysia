{
  config,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.geekbench
  ];
}
