{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    steam
    steam-run
  ];
  programs.steam.enable = true;
}
