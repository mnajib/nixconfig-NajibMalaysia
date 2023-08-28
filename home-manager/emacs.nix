{
  pkgs,
  ...
}:
{
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: [
      epkgs.nix-mode
      epkgs.magit
      epkgs.emms
      epkgs.zerodark-theme
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
