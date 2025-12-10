{
  pkgs,
  config,
  ...
}:
{
  home.packages = with pkgs; [
    #nh
  ];

  programs.nh = {
    enable = true;
    #flake = "~/src/nixconfig";
    #flake = "${config.home.homeDirectory}/src/nixconfig";
    flake = "${config.home.homeDirectory}/src/nixconfig-NajibMalaysia";
  };
}
