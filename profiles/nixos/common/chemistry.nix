{ pkgs, config, ... }: {

  #imports = [
  #  ./jupiternotebook.nix
  #];

  environment.systemPackages = with pkgs; [
    #chemtool # chemtool has been removed as it is unmaintained upstream and depends on GTK 2.
    jmol
    #avogadro  # avogadro has been removed, because it depended on qt4
  ];
}
