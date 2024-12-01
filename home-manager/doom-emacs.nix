{
  pkgs,
  ...
}:
{

  # NOTE:
  #  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  #  ~/.config/emacs/bin/doom install

  imports = [
    ./git.nix
  ];

  home.packages = with pkgs; [
    #emacs
    cmake
    libtool
    ispell
    #gitAndTools.gitFull #git
    ripgrep

    coreutils
    fd
    clang
  ];

  programs.emacs = {
    enable = true;
    #extraPackages = epkgs: [
    #  epkgs.nix-mode
    #  epkgs.magit
    #  epkgs.emms
    #  epkgs.zerodark-theme
    #
    #  epkgs.doom
    #];
  };

  services.emacs = {
    enable = true;
    #packages =
    client = {
      enable = true;
    };
  };
}
