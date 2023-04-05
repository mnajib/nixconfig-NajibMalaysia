{
  config,
  ...
}:
{
  nix.gc = {
    automatic = true;
    #dates = "weekly";                                                          # default "03:15"
    dates = "Mon *-*-* 03:00:00";
    #randomizedDelaySec = "45min";                                              # default "0"
    #persistent = false;                                                        # default true
    #options = "--delete-older-than 30d --max-freed $((64 * 1024**3))";         # default ""
    #options = "--delete-older-than 30d";                                       # default ""
    options = "--delete-older-than 35d";                                        # default ""
  };
}
