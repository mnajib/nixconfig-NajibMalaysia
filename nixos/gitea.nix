{
  nixpkgs,
  config,
  ...
}:
{
  services.gitea = {
    enable = true;
    rootUrl = "http://mahirah:3000/";
  };
}
