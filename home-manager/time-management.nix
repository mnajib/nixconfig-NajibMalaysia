{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # GUI
    gnome-solanum
    gnome-pomodoro
    pomodoro-gtk
    #uair
    #
    ktimetracker

    # TUI/CLI
    tomato-c
    #haskellPackages.Monadoro
    #haskellPackages.pomodoro
    pom
    #pomodoro
    #openpomodoro-cli
    porsmo
    #
    timewarrior
    timetrap
    timetagger_cli
    tasktimer
  ];
}
