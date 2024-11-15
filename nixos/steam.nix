{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    mangohud
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  #gamemoderun %command%
  #mongohud %command%
  #gamescope %command%
}

