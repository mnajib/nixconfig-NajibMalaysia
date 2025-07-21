{
  pkgs,
  #config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    emacs
    cmake
    libtool
    ispell
    git
    ripgrep

    coreutils
    fd
    clang
  ];
}
