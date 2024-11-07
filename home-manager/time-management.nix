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

    # CLI
    tomato-c
    #haskellPackages.Monadoro
    #haskellPackages.pomodoro
    pom
    #pomodoro
    #openpomodoro-cli
    porsmo
  ];
}
