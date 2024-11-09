{ pkgs, lib }:

pkgs.nixvim.legacyPackages.${pkgs.system}.makeNixvimConfig {

  # Your nixvim configuration here
  options = {
    number = true;
    relativenumber = true;
  };

  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls.enable = true;  # Nix LSP
      pyright.enable = true;  # Python LSP
    };
  };

  # Add more nixvim configuration as needed
}
