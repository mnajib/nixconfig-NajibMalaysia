{ pkgs, ... }:
{

  home.packages = with pkgs; [
    #protonup
    protonup-ng
  ];

  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };

  #in CLI
  #  protonup
  #
  #  protonup -d "~/.steam/root/compatibilitytools.d/"

}
