
cd ~/src/nixconfig-NajibMalaysia

nix flake check
nix flake info
nix flake show
nix flake update

nix develop

sudo nixos-rebuild dry-build --flake .
sudo nixos-rebuild dry-build --flake .#khawlah
sudo nixos-rebuild build --flake .#khawlah
sudo nixos-rebuild boot --flake .#khawlah
sudo nixos-rebuild switch --flake .#khawlah

home-manager news --flake .
home-manager build --flake .
home-manager build --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah -b backup

sudo nixos-rebuild dry-build --flake .#zahrah --target-host naim@zahrah --use-remote-sudo
sudo nixos-rebuild build --flake .#zahrah --target-host naim@zahrah --use-remote-sudo
sudo nixos-rebuild switch --flake .#zahrah --target-host naim@zahrah --use-remote-sudo

