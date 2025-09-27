{
  inputs,
  outputs,
  #lib,
  config,
  pkgs,
  ...
}:
#let
#in
{
  #imports = [
  #];

  home.packages = with pkgs; [
    gimp3-with-plugins
    flameshot # A powerful yet simple to use screenshot software

    # Web browser
    #firefox
    librewolf
  ];

}
