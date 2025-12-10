{
  pkgs,
  ...
}:
{
  users.users.abdullah = {
    description = "abdullah";
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    createHome = true;
    home = "/home/abdullah";
    extraGroups = [
      "networkmanager" "audio" "video" "cdrom" "scanner" "lp" "systemd-journal"
      "istana46" "users"
      "dialout"
      "wheel"
    ];
    packages = with pkgs; [
      firefox
      tmux
      neovim
      htop
      git
    ];
  };
}
