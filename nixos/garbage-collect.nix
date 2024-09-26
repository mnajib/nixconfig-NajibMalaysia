{
  nix.gc.automatic = true;          # Enable automatic garbage collection
  nix.gc.dates = "weekly";          # Set GC to run weekly
  nix.gc.options = "--delete-older-than 30d";  # Keep only generations younger than 30 days
}
