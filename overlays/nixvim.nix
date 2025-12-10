# overlays/nixvim.nix
{
  inputs, # Receive all inputs
  ...
}:
final: prev: {
  nixvim = inputs.nixvim.packages.${prev.system}.default;
}
