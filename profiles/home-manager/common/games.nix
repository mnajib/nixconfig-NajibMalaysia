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
    colobot # a real-time strategy game, where you can program your bots
  ];

}
