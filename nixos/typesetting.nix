{ pkgs, config, ... }:
{
  environment.systemPackages = [
    pkgs.lyx

    pkgs.tikzit
    pkgs.pandoc
    pkgs.tectonic

    pkgs.texlive.combined.scheme-full
    #pkgs.texlive.combined.scheme-basic

    pkgs.texmaker
    pkgs.texstudio
    pkgs.texworks

    #pkgs.sile

    pkgs.groff
  ];
}
