{
  home.gc.automatic = true;         # Enable automatic garbage collection for Home Manager
  home.gc.dates = "weekly";         # Set it to run weekly
  home.gc.options = "--delete-older-than 30d";  # Limit Home Manager generations
}
