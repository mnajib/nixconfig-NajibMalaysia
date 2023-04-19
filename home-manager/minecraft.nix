{
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.minecraft

    pkgs.prismlauncher
    #pkgs.prismlauncher-qt5
  ];
}
