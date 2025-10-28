{
  config,
  pkgs,
  lib,
  ...
}:

#let
#
#in
{

  environment.sessionVariables = rec {
    #XDG_DATA_HOME = "$HOME/var/lib";
    #XDG_CACHE_HOME = "$HOME/var/cache";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

}
