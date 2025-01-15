{
  pkgs,
  ...
}:
{

  # NOTE:
  #   ...

  home.packges = with pkgs; [
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

  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      #epkgs.nix-mode
      #epkgs.magit
      #epkgs.emms
      #epkgs.zerodark-theme

      epkgs.doom
    ];
  };

  services.emacs = {
    enable = true;
    #packages =
    client = {
      enable = true;
    };
  };
}
