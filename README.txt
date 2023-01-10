
cd ~/src/nixconfig-NajibMalaysia

nix flake show
nix flake update

nix develop

nixos-rebuild build --flake .#khawlah
sudo nixos-rebuild switch --flake .#khawlah

home-manager build --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah -b backup

