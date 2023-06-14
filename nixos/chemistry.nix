{ pkgs, config, ... }: {

  #imports = [
  #  ./jupiternotebook.nix
  #];

  environment.systemPackages = with pkgs; [
    chemtool
    jmol
    avogadro
  ];
}
