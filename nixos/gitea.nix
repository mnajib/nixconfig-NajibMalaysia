{
  nixpkgs,
  config,
  ...
}:
{
  services.gitea = {
    enable = true;
    settings = {
      #server.DOMAIN = "mahirah";
      server.DOMAIN = "${config.networking.hostName}";
      server.HTTP_PORT = 3000;
      #server.ROOT_URL = "http://mahirah:3000/";
      #server.ROOT_URL = "http://192.168.1.72:3000/";
    };
    stateDir = "/var/lib/gitea";                                              # default
    customDir = "${config.services.gitea.stateDir}/custom";                   # default
    repositoryRoot = "${config.services.gitea.stateDir}/repositories";        # default
    #lfs.contentDir = ...
    #dump.backupDir = ...
  };
}
