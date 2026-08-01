# nixpkgs.nix
# A nixpkgs instance that is grabbed from the pinned nixpkgs commit in the lock file
# This is useful to avoid using channels when using legacy nix commands
let
  #lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
  ##lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs-release.locked;

  flakeLock = builtins.fromJSON (builtins.readFile ./flake.lock);
  rootInputs = flakeLock.nodes.root.inputs;

  # root.inputs.nixpkgs is either:
  #   ["some-other-name"]   -- a `follows` alias -> take the target name
  #   "nixpkgs_N"           -- a direct fetch -> that's already the real node name
  nixpkgsKey =
    if builtins.isList rootInputs.nixpkgs
    then builtins.head rootInputs.nixpkgs
    else rootInputs.nixpkgs;

  lock = flakeLock.nodes.${nixpkgsKey}.locked;
in
  import (fetchTarball {
    url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
    sha256 = lock.narHash;
  })


#
#------------------------------------------------------------------------------
# NOTE
#------------------------------------------------------------------------------
#
# Run Test 1:
#   jq '.nodes | has("nixpkgs")' flake.lock
# If that prints false (which I'd bet on, given your follows setup), then any
# attempt to actually use the bootstrap path — nix-shell on a fresh
# flakes-disabled machine, or nix-build -A on pkgs/default.nix — fails right
# when it matters most: exactly the moment you're trying to bootstrap a new box
# and don't yet have a working flake-aware nix to fall back on.
#
# Run Test 1:
#   nix-instantiate --eval -E 'import ./nixpkgs.nix {}' 2>&1 | head -20
# If you get a Nix attrset dump (or at least no attribute missing error)
#
# To verify the nixpkgs.nix ↔ flake match
#   nix-instantiate --eval -E '(import ./nixpkgs.nix {}).lib.version'
#   nix eval .#nixosConfigurations.khawlah.pkgs.lib.version
#
# To test build
#   nixos-rebuild build --flake .#khawlah
#
#------------------------------------------------------------------------------
#
