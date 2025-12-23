{
  pkgs,
  inputs,
  outputs,
  lib,
  config,
  ...
}:
{
  #imports = [
  #  inputs.nix-doom-emacs.hmModule
  #];

  home.packages = with pkgs; [
    pass
    keepassxc

    ente-auth
    ente-cli
  ];

  #programs.doom-emacs = {
  #  enable = true;
  #  doomPrivateDir = ./src/doom.d;
  #};

  #programs.emacs = {
  #  enable = true;
  #  extraPackages = epkgs: [
  #    epkgs.nix-mode
  #    epkgs.magit
  #    epkgs.emms
  #    epkgs.zerodark-theme
  #    epkgs.doom
  #  ];
  #};

  #services.emacs = {
  #  enable = true;
  #  #packages =
  #  client = {
  #    enable = true;
  #  };
  #};
}
