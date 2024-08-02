# nixconfig-NajibMalaysia

## Refferences

### About Nixos
- [Misterio77's nix-config template for starter](https://github.com/Misterio77/nix-starter-configs)
- [Misterio77's personal nix-config](https://github.com/Misterio77/nix-config)
- https://nixos.wiki/wiki/Comparison_of_NixOS_setups
- https://nixos.wiki/wiki/Configuration_Collection
- https://github.com/sjcobb2022/nixos-config

### About mime and file association
- https://wiki.archlinux.org/title/Default_applications#Resource_openers
- ...

# Please run 'nixos-generate-config --show-hardware-config' and copy the output into hardware-configuration.nix

```
mkdir -p ~/src
cd ~/src
git clone ssh://najib@customdesktop/home/najib/GitRepos/nixconfig-NajibMalaysia.git

cd ~/src/nixconfig-NajibMalaysia
#cd /etc/nixos-NajibMalaysia
git checkout origin/nixos-unstable
git branch nixos-unstable

nix flake check
nix flake info
nix flake show
nix flake update

nix develop
nix develop --extra-experimental-features 'nix-command flakes'

sudo nixos-rebuild dry-build --flake .
sudo nixos-rebuild dry-build --flake .#khawlah
sudo nixos-rebuild build --flake .#khawlah
sudo nixos-rebuild build --flake .#khawlah --option eval-cache false --show-trace
sudo nixos-rebuild boot --flake .#khawlah
sudo nixos-rebuild switch --flake .#khawlah

home-manager news --flake .
home-manager build --flake .
home-manager build --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah
home-manager switch --flake .#najib@khawlah -b backup

sudo nixos-rebuild dry-build  --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
#sudo nixos-rebuild build      --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild build --flake .#zahrah --target-host naim@zahrah --use-remote-sudo
sudo nixos-rebuild boot       --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild test       --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild switch     --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo

# XXX:
nix shell nixpkgs#pulsar

#------------------------------------------------------------------------------
To show generations:
  nix-env --list-generations
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

To delete generations number 23 42 43:
  nix-env --delete-generations 23 42 43
  sudo nix-env --delete-generations 42 43 --profile /nix/var/nix/profiles/system
To delete all other generations, but keep 5 last generations:
  nix-env --delete-generations +5
To delete old generations:
  sudo nix-env --delete-generations old

To run garbage collection:
  nix-store --gc

#------------------------------------------------------------------------------
To show derivations:
  nix derivation show

To perform garbage collect:
  nix store gc
#------------------------------------------------------------------------------
To show generations:
  home-manager generations
To remove generation:
  home-manager remove-generations 2
  home-manager remove-generations 3
#------------------------------------------------------------------------------
```


### TODO

- [ ] Replace '*.txt*' to '*.md*' where appopriate.
- [ ] Make '*nixos-rebuild*' also build '*home-manager*'.
