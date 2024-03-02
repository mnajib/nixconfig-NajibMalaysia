{ pkgs, ... }: {
  home.packages = with pkgs; [
    chemtool
    jmol
    avogadro
  ];
}
