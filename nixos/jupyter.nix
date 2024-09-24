{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.jupyter
    pkgs.ihaskell

    #pkgs.gophernotes
    #pkgs.iruby
    #pkgs.xeus-cling

    #vscode
  ];
}
