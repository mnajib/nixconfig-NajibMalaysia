# nixconfig-NajibMalaysia

```
===============================================================
 My NixOS + Home Manager Configurations
===============================================================

This repository contains my NixOS system and Home Manager user
configurations, managed with flakes. The repo separates:

- modules     → reusable building blocks
- profiles    → my curated defaults
- hosts/users → concrete machines and people

💡 Think of it like Lego:
- Modules are the bricks
- Profiles are the box sets you build from those bricks
- Hosts/Users are the final models on the shelf (your actual systems)

It is a work-in-progress, but parts may be useful to others
exploring NixOS repo organization.

---------------------------------------------------------------
 Repository Structure (Visual Overview)
---------------------------------------------------------------

.
├── flake.nix
├── flake.lock
├── shell.nix
├── .gitignore
├── .envrc
├── README.md
├── modules/                            # Reusable building blocks
│   ├── default.nix
│   ├── nixos/
│   │   └── seaweedfs/
│   ├── home-manager/
│   │   └── repo-bootstrap/
│   └── iso/
├── profiles/                           # Opinionated defaults
│   ├── nixos/
│   │   ├── common/                     # shared defaults across machines
│   │   └── hosts/                      # host-specific configs
│   │       └── nyxora
│   │           ├── configuration.nix
│   │           └── hardware-configuration.nix
│   └── home-manager/
│       ├── common/                     # shared defaults across users
│       └── users/                      # per-user configs
│           └── najib                   # user name
│               └── nyxora              # host name
│                   └── default.nix     # per user@host
├── overlays/                           # Custom nixpkgs overlays
├── packages/                           # Extra packages not in nixpkgs
├── generators/                         # ISO definitions (gnome, hyprland, plasma)
├── bin/                                # Helper scripts (remote builds, ZFS, etc.)
├── docs/                               # Notes, workflows, learning materials
├── bak/                                # Old experiments
└── tmp/                                # Scratch space

---------------------------------------------------------------
 Conceptual Flow
---------------------------------------------------------------

            ┌───────────────┐
            │   modules/     │   → reusable, generic pieces
            └───────┬───────┘
                    │
            ┌───────▼───────┐
            │   profiles/    │   → curated defaults (system/user)
            └───────┬───────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼───────┐       ┌───────▼───────┐
│ profiles/nixos │       │ profiles/home  │
│   /hosts/      │       │  -manager/     │
│ (machines)     │       │ (users)        │
└───────────────┘       └───────────────┘

---------------------------------------------------------------
 Legend
---------------------------------------------------------------

Layer                               Purpose
---------------------------------------------------------------
modules/                            Small, reusable building blocks (generic)
profiles/                           My curated defaults built from modules
profiles/nixos/hosts/               Machine-specific configs (hardware, services)
profiles/home-manager/users/        User-specific configs (per person, per host)

---------------------------------------------------------------
 Why This Structure?
---------------------------------------------------------------

 Pros
 ----
 - Clear separation of generic modules vs my defaults (profiles).
 - Scales to many hosts and users.
 - Easy to share individual modules without exposing my whole setup.
 - Hosts and users stay clean: only hardware/identity-specific bits.

 Cons
 ----
 - Some duplication between modules/ and profiles/common/.
 - Still evolving: some files are experiments or legacy.
 - Adding a new feature may require editing both a module and a profile.

---------------------------------------------------------------
 Current Experiments
---------------------------------------------------------------

I am still exploring other repo structures:
- Adding a roles/ layer (e.g. "server", "workstation").
- Trying modulix to auto-generate host configs from modules.
- Considering flake-parts/dendritic style (feature-driven modularity).
- and more others

---------------------------------------------------------------
 Status
---------------------------------------------------------------

⚠️ Work in progress.
- Some files are temporary or experimental.
- Old approaches are kept for history and learning references.

===============================================================

```

## My Notes

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
