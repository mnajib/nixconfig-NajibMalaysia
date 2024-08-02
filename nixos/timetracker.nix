{ pkgs, config, ... }:{
  #environment.systemPackages = with pkgs; [
  #  ktimetracker
  #];
  environment.systemPackages = with pkgs; [
    # gui
    ktimetracker
    gnome.pomodoro

    # tui
    timewarrior
    timetrap
    timetagger_cli
    tasktimer
  ];
}
