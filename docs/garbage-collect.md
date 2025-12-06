# Profiles Generations

We have profiles for systems and profiles for users.
Each profiles have its own generations.

## System Profile Generations

Generations of System Profile is produced when we run
```
sudo nixos-rebuild switch --flake .#hostname
```

The current system profile is stored (symlink to current use generation) at:
```
/nix/var/nix/profiles/system
```

The generations of the system profile is store at:
```
/nix/var/nix/profiles/system-<profileNunber>-link
```

To list current system generations (generations of the system profile):
```
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```
or
```
ls -1d /nix/var/nix/profiles/system-*-link
```




## User (root user and other users) Profile Generations

### New style

Generations of root user profile is produced when (to install as ad-hoc) we run
```
sudo nix profile install .#hello
```

to list what installed in current generation of root user profile
```
sudo nix profile list
```

and to remove/uninstall it
```
sudo nix profile remove hello
```

Generations of other user profile is produced when (to install as ad-hoc) we run
```
nix profile install .#hello
```

to list what installed in current generation of user profile
```
nix profile list
```

and to remove/uninstall it
```
nix profile remove hello
```

Users profiles is stored in /nix/var/nix/profiles/per-user/*
To list user profiles:
```
ls -1d /nix/var/nix/profiles/per-user/*
```

Generations of each user profile is stored at /nix/var/nix/profiles/per-user/<username>/<generation-name>

```
ls -1d /nix/var/nix/profiles/per-user/user.profile/<generationname>
```


### Old style

```
ls -1d /nix/var/nix/profiles/per-user/user/profile/<generationname>
nix-env --install hello
nix-env --list --installed
nix-env --list-generations
nix-env --delete-generations
```
