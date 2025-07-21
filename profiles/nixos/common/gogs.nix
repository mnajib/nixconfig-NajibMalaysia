{
  nixpkgs,
  config,
  ...
}:
{
  services.gogs = {
    enable = true;
  };
}
