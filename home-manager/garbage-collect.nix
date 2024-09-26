{
  config,
  ...
}:
{
  nix.gc = {
    automatic = true;         # Enable automatic garbage collection for Home Manager
    frequency = "weekly";         # Set it to run weekly

    # Options given to nix-collect-garbage when the garbage collector is run automatically.
    options = "--delete-older-than 30d";  # Limit Home Manager generations

    #persistent = true;  # default is true
  };
}
