# Profiles Generations

We have profiles for systems and profiles for users.
Each profiles have its own generations.

## System Profile Generations

Generations of System Profile is produced when we run
```
sudo nixos-rebuild switch --flake .#hostname
```

The system profile is stored at:
```
/nix/var/nix/profiles/system
```

To list current system generations (generations of the system profile):
```
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```




## User Profile Generations

