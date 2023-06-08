{
  nixpkgs,
  config,
  ...
}:
{
  services.gitea = {
    enable = true;
    settings = {
      server.ROOT_URL = "http://mahirah:3000/";
      #server.ROOT_URL = "http://192.168.1.72:3000/";
    };
  };
}
