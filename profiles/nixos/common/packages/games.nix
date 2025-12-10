{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./../steam.nix
    ./../proton-GE.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-chess dosbox mgba

    heroic # games launcher, maybe similar to lutris? steam?
    bottles # easily run Windows software on Linux
  ];
}

