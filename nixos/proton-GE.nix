{ pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    protonup
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
  };

  #in CLI
  #  protonup

}
