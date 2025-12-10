# profiles/nixos/hosts/sumayah/grafito.nix
{
  #imports = [ self.nixosModules.grafito ];

  services.grafito = {
    enable = true;
    uid = 950;
    gid = 950;
    port = 8080;
    host = "0.0.0.0";
    openFirewall = true;
  };
}

