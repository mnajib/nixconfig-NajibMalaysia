{ pkgs, lib, ... }:
{
  users.users.najib = lib.mkForce {
    description = "Muhammad Najib Bin Ibrahim";
    uid = 1001;
    isNormalUser = true;
    #initialPassword = "password";
    createHome = true;
    home = "/home/najib";
    #homeMode = "700"; # chmod, umask
    extraGroups = [
      "wheel"
      "networkmanager"
      "istana46"
      "audio"
      "video"
      "cdrom"
      "adbusers"
      "vboxusers"
      "scanner"
      "lp"
      "systemd-journal"
      "najib" "julia" "naqib" "nurnasuha" "naim"
      "input"
      "bluetooth"
      #"fuse"
      "dialout"
      "kvm"
    ];

    #shell = pkgs.zsh; # path/location of the shell program
    #useDefaultShell = false; # if true, the user's shell will be set to 'users.defaultUserShell'

    #packages = with pkgs; [
    #  firefox nnn ranger git tmux neovim htop direnv
    #  #emacs
    #];
  };
}
