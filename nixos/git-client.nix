# XXX: NOT READY TO BE USE !!!

{
  pkgs,
  ...
}:{
  # Install Git and configure SSH
  environment.systemPackages = with pkgs; [
    git
    openssh
  ];

  # Configure SSH keys for user
  users.users.username = {
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [ "/path/to/public/key.pub" ];
  };
}
