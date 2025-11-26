{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    patool
    zip
    unzip
    atool
    unrar
    p7zip
    xarchiver
    file-roller
  ];
}

