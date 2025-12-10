{
  pkgs,
  ...
}:
{
  users.users.a = {
    uid = 1000;
    initialPassword = "password";
    description = "a";
    isNormalUser = true;
    createHome = true;
    home = "/home/a";
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
