{
  config,
  pkgs,
  ...
}:
{
  services.gitolite = {
    enable = true;
  };
}
