# nixconfig-NajibMalaysia

```
mkdir -p ~/src
cd ~/src
git clone https://github.com/mnajib/nixconfig-NajibMalaysia.git

cd ~/src/nixconfig-NajibMalaysia
git checkout master

nix flake check
nix flake metadata
nix flake show
nix flake update
nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes

nix develop
nix develop --extra-experimental-features 'nix-command flakes'

sudo nixos-rebuild dry-build --flake .
sudo nixos-rebuild dry-build --flake .#khawlah
sudo nixos-rebuild build     --flake .#khawlah
sudo nixos-rebuild test      --flake .#khawlah
sudo nixos-rebuild boot      --flake .#khawlah
sudo nixos-rebuild switch    --flake .#khawlah

home-manager news   --flake .
home-manager build  --flake .
home-manager build  --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah -b backup
```
