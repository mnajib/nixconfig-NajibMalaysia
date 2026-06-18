# overlays/nix-minecraft.nix
{ inputs }: final: prev: {
  # Access legacyPackages instead of packages
  inherit (inputs.nix-minecraft.legacyPackages.${prev.system})
    neoforgeServers
    fabricServers
    paperServers
    vanillaServers
    quiltServers
    purpurServers
    velocityServers
    minecraftServers;
    
  inherit (inputs.nix-minecraft.packages.${prev.system})
    fetchPackwizModpack
    fetchModrinthModpack;
}   
