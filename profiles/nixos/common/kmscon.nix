{ pkgs, config, ... }:
{
  imports = [
    #./steam.nix
    #./proton-GE.nix
  ];

  environment.systemPackages = with pkgs; [
    #kmscon
  ];

  services.kmscon = {
    enable = true;
    #package = pkgs.kmscon;
    fonts = [
      { name = "Source Code Pro"; package = pkgs.source-code-pro; }
    ];
    extraOptions = "--term xterm-256color";
    extraConfig = "font-size=12";
    hwRender = true;
    useXkbConfig = true;
  };
}
