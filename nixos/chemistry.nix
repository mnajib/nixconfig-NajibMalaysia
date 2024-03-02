{ pkgs, config, ... }: {

  #imports = [
  #  ./jupiternotebook.nix
  #];

  environment.systemPackages = with pkgs; [
    chemtool
    jmol
    #avogadro  # avogadro has been removed, because it depended on qt4
  ];
}
