{ pkgs, ... }: {
  home.packages = with pkgs; [
    chemtool # (2D) draw chemical structures
    jmol # Java 3D viewer for chemical structures
    avogadro2 # (3D) Molecule editor and visualizer

    marvin # not opensource
  ];
}
