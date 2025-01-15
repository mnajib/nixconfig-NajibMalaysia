{ pkgs, config, ... }:
{

  #programs.neovide = {
  #  enable = true;
  #  settings = {};
  #};

  home.packages = with pkgs; [
    neovide
  ];
}
