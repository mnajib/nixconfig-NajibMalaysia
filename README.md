# nixconfig-NajibMalaysia


## My NixOS + Home Manager Configurations

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


## Repository Structure Overview

```
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
```

```
            +--------+--------+
            |     modules/    |      → reusable, generic pieces
            +--------+--------+
                     |
                     V
            +--------+--------+
            |     profiles/   |      → curated defaults (system/user)
            +--------+--------+
                     |
                     V
            +--------+---------------------------+
            |                                    |
            V                                    V
+-----------+-------------+       +--------------+------------------+
| profiles/nixos/hosts/   |       | profiles/home-manager/users/    |
│      (machines)         │       |           (users)               |
+-------------------------+       +---------------------------------+
```

```
Layer                               Purpose
---------------------------------------------------------------
modules/                            Small, reusable building blocks (generic)
profiles/                           My curated defaults built from modules
profiles/nixos/hosts/               Machine-specific configs (hardware, services)
profiles/home-manager/users/        User-specific configs (per person, per host)
```

Why This Structure?

Pros:
 - Clear separation of generic modules vs my defaults (profiles).
 - Scales to many hosts and users.
 - Easy to share individual modules without exposing my whole setup.
 - Hosts and users stay clean: only hardware/identity-specific bits.

Cons:
 - Some duplication between modules/ and profiles/common/.
 - Still evolving: some files are experiments or legacy.
 - Adding a new feature may require editing both a module and a profile.


## Home-Manager for user-level Management

_-- My user-level configuration follows a hybrid strategy. I use Nix to declaratively manage core packages and stable configs, while using Git to imperatively manage complex, evolving configs like my Neovim setup and scripts repository. This gives me reproducible base system with the flexibility for daily development. --_

_Use Nix to clone the repositories (initial setup) and Git to manage all subsequent changes and commits._

This configuration tries to blend the declarative approach with some practical flexibility.

I've created a custom Home Manager module (programs.repo-bootstrap) that tries to automatically set up my essential Git repositories when I first log into a new system. I think this helps me get a working environment quickly after a fresh install. But I also wanted to keep the ability to edit files directly when I need to experiment quickly.

I'm definitely still learning, so some of my assumptions here might not be completely accurate, but this is what seems to be working for me so far!

```
+---------------------------------------------------+
|              NixOS Rebuild / Home Manager Switch  |
|                 (nixos-rebuild switch --flake .)  |
+---------------------------------------------------+
                            |
                            v
+---------------------------------------------------+
|           Home Manager Activation Scripts         |
|     (Runs in sequence after system activation)    |
+---------------------------------------------------+
                            |
                            v
+---------------------------------------------------+
|             repo-bootstrap Activation             |
+---------------------------------------------------+
| 1. Reads repo config from Nix declaration         |
| 2. For each enabled repository:                   |
|    +-----------------------------------------+    |
|    | - Checks if local repo path exists      |    |
|    | - If not: clones from primary remote    |    |
|    | - Configures all defined remotes        |    |
|    | - Optionally runs git fetch             |    |
|    | - Creates symlinks if configured        |    |
|    +-----------------------------------------+    |
+---------------------------------------------------+
                            |
                            v
+-------------------+     +-------------------+     +-------------------+
|   Local Git Repo  |     |   Local Git Repo  |     |   Local Git Repo  |
| ~/Projects/repo1/ |     | ~/Projects/repo2/ |     |       ...         |
+-------------------+     +-------------------+     +-------------------+
          |                         |                         |
          v                         v                         v
+-------------------+     +-------------------+     +-------------------+
|   Home Symlinks   |     |   Home Symlinks   |     |   Home Symlinks   |
|    ~/.config/     |     |    ~/bin/         |     |       ...         |
+-------------------+     +-------------------+     +-------------------+
                            |
                            v
+---------------------------------------------------+
|           User Environment Ready!                 |
|   - Repositories available for direct editing     |
|   - Symlinks provide convenient access            |
|   - Git tracks all your changes naturally         |
+---------------------------------------------------+
```


To summarize how it works;

- Declarative Setup: You define your repositories and their properties in your Nix configuration (.nix files)
- Automatic Bootstrap: When you rebuild your system, the module automatically creates/clones the repositories
- Persistent Editing: After the initial setup, you can work with the repositories normally using Git and any text editor
- Non-Destructive: Your changes and commits are preserved across rebuilds - Nix only manages the initial setup

The key idea I'm trying to achieve is that _Nix handles the boring setup work, but then gets out of the way so I can work like I normally would with Git_ and my editor.


## Current Experiments

I am still exploring other repo structures:
- Adding a roles/ layer (e.g. "server", "workstation").
- modulix? to auto-generate host configs from modules.
- flake-parts/dendritic style (feature-driven modularity)?
- color scheme
- secret keys management
- and more others

## Status

⚠️ Work in progress.
- Some files are temporary or experimental.
- Old approaches are kept for history and learning references.


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
