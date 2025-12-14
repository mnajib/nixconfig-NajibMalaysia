# XXX: NOT READY TO BE USE !!!
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
  # sudo groupadd gitgroup
  # sudo usermod -aG gitgroup username
  # sudo chown -R :gitgroup /path/to/git/repo
  # sudo chmod -R g+sw /path/to/git/repo
  # umask 002
  # git init --bare /path/to/git/repo
  # /path/to/git/repo.git/hooks/post-receive:
  #   #!/bin/bash
  #   chmod -R g+sw /path/to/git/repo
  # chmod +x /path/to/git/repo.git/hooks/post-receive

  # Enable the git daemon for serving repositories over HTTP
  services.gitDaemon = {
    enable = true;
    basePath = "/srv/git"; # Path to your git repositories
    exportAll = true;
    enableSSH = true; # Enable SSH access for more secure pushes/pulls
  };

  # Enable SSH server for secure Git access over SSH
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    #permitRootLogin = lib.mkDefault "no";
    passwordAuthentication = false;
  };

  # Add users and assign them to the git group
  users.users.yourUser = {
    isNormalUser = true;
    extraGroups = [ "gitgroup" ];
    openssh.authorizedKeys.keyFiles = [ "/path/to/your/public/key.pub" ];
  };

  networking.firewall.allowedTCPPorts = [
    22 # ssh
  ];
}
