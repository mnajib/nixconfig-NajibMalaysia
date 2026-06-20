# ./profiles/nixos/common/nh.nix

#
# XXX: this config is not tested
#

{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    #nh
    nix-output-monitor # (nom)
    nvd
  ];

  programs.nh = {
    enable = true;

    # sets NH_OS_FLAKE variable
    #flake = "${config.home.homeDirectory}/src/nixconfig-NajibMalaysia";
    flake = "${config.home.homeDirectory}/Projects/nixconfig-NajibMalaysia";

    clean = {
      enable = true;

      # How often cleanup is performed. Passed to systemd.time.
      # The format is described in systemd.time(7)
      dates = "weekly";

      # Options given to nh clean when the service is run automatically.
      # See nh clean all --help for more information.
      extraArgs = "--keep-since 4d --keep 3";
    };

  };
}
