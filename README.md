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
nix flake metadata
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
#
#nix build --target-host target-host --build-host build-host --flake /path/to/flake#user@target-host
#scp -r result user@target-host:/path/to/built-result
#ssh user@target-host 'home-manager switch --flake /path/to/built-result#user@target-host'

sudo nixos-rebuild dry-build  --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
#sudo nixos-rebuild build      --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild build --flake .#zahrah --target-host naim@zahrah --use-remote-sudo
#
# XXX: tested, worked only halfway
# From manggis;
nixos-rebuild build --flake .#manggis --build-host naqib@sakinah.localdomain --use-remote-sudo
#sudo su
#NIX_SSHOPTS="-o RequestTTY=force" nixos-rebuild boot --flake .#manggis --build-host naqib@sakinah.localdomain
#
sudo nixos-rebuild boot       --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild test       --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
sudo nixos-rebuild switch     --flake .#zahrah    --target-host naim@zahrah     --build-host localhost    --use-remote-sudo
#
# This below command successfully run on khadijah, build on asmak, install on zahrah.
# Requirement: impliment ssh key and sudo-able of the user
#sudo nixos-rebuild build --flake .#zahrah --target-host naim@zahrah --build-host najib@asmak --use-remote-sudo
nixos-rebuild build --flake .#zahrah --target-host naim@zahrah --build-host najib@asmak --use-remote-sudo
#nixos-rebuild boot --flake .#zahrah --target-host naim@zahrah --build-host najib@asmak --use-remote-sudo
#mosh naim@zahrah 'sudo nixos-rebuild boot --flake ~/src/nixconfig-NajibMalaysia#zahrah'

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
# To remove all NixOS generations older than 30 days. You can adjust the time window, e.g., 90d for 90 days.
  sudo nix-collect-garbage --delete-older-than 30d
  sudo nix-collect-garbage --delete-old

#------------------------------------------------------------------------------
To show derivations:
#  nix derivation show

To perform garbage collect for user's environment:
  nix store gc
Thin removes / clears-up the Nix store for the current user (useful if you're using Nix in multi-user mode).

To perform garbage collect for system-wide:
  sudo nix store gc
This removes all unused paths from the Nix store.

#------------------------------------------------------------------------------
To show generations:
  home-manager generations

To remove generation:
  home-manager remove-generations 2
  home-manager remove-generations 3
# To removes (clean up) Home Manager generations that older than 30 days.
  home-manager expire-generations "-30 days"

#------------------------------------------------------------------------------
Delete old profiles

If you have old Nix profiles (related to package installations for users or environments), they can consume space over time. Profiles are kept in ~/.nix-profile or /nix/var/nix/profiles.

To list profiles:
  nix profile list

To remove older profiles:
  nix profile remove <profile-name>


#------------------------------------------------------------------------------
Prune Flake-Related Cache

When using flakes, the flake cache can accumulate over time. To clean it up, run:
  nix flake archive --gc
This garbage-collects flake archives (compressed snapshots of repositories) that are no longer needed.

XXX: Not working


#------------------------------------------------------------------------------
Clear the Nix Log Files

Nix maintains build logs in /nix/var/log/nix/drvs. If you're sure you don't need these logs, they can be removed to save space:
  sudo rm -rf /nix/var/log/nix/drvs/*



#------------------------------------------------------------------------------

sudo nix store optimise

#------------------------------------------------------------------------------


```


### TODO

- [ ] Replace '*.txt*' to '*.md*' where appopriate.
- [ ] Make '*nixos-rebuild*' also build '*home-manager*'.
