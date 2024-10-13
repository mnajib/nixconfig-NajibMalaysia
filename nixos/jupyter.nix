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

  networking.firewall = {
    allowedTCPPorts = [
      8888 # jupyter-lab, jupyter-notebook
    ];
  };
}
