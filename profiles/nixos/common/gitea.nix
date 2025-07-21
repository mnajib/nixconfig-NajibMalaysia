#
# NOTES:
#   systemctl
#   systemctl status gitea.service
#   netstat -tulpen | grep '3000'
#

{
  nixpkgs,
  config,
  ...
}:
{
  # XXX: Mount /mnt/data/gitea to /svr/gitea
  #...

  services.gitea = {
    enable = true;
    settings = {
      #server.DOMAIN = "mahirah";
      server.DOMAIN = "${config.networking.hostName}";
      server.HTTP_PORT = 3000;
      #server.ROOT_URL = "http://mahirah:3000/";
      #server.ROOT_URL = "http://192.168.1.72:3000/";
    };
    #stateDir = "/var/lib/gitea";                                              # default
    stateDir = "/mnt/data/gitea";                                              # this is also in zfs, and frequently snapshot; but not in shared-nfs
    customDir = "${config.services.gitea.stateDir}/custom";                   # default
    repositoryRoot = "${config.services.gitea.stateDir}/repositories";        # default
    #lfs.contentDir = ...
    #dump.backupDir = ...

    #database = {
    #  type = "sqlite3"; # Using sqlite for simplicity, can be changed to mysql/postgres
    #  path = "${config.services.gitea.stateDir}/gitea.db"; # Path for the database
    #};

    # Ensure that Gitea has the correct permissions on its directories
    #systemd.services.gitea.serviceConfig.ExecStartPre = ''
    #  mkdir -p /var/lib/gitea
    #  chown -R gitea:git /var/lib/gitea
    #'';

    #options = [
    #  "x-systemd.after-mnt-data.automount"
    #];
  };

  systemd.services.gitea = {
    after = [
      "mnt-data.automount"
    ];
  };

  networking.firewall.allowedTCPPorts = [
    3000 # gitea
  ];
}
