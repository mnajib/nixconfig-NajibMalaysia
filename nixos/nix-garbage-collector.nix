{
  config,
  ...
}:
{
  nix.gc = {
    automatic = true;
    #dates = "weekly";                  # default "03:15"
    #randomizedDelaySec = "45min";      # default "0"
    persistent = false;                 # default true
    #options = "--delete-older-than 30d --max-freed $((64 * 1024**3))";# default ""
    options = "--delete-older-than 30d";# default ""
  };
}
