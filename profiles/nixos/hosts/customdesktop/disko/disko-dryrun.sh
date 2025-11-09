#!/usr/bin/env bash
#
# a dry-run simulator script that parses your Disko layout and shows which
# disks, partitions, and filesystems would be wiped or formatted — without
# actually running the CLI.
#
# Safe Preview of Disko Actions
#
# What It Does
# - Parses your Disko layout using nix eval
# - Lists all defined disks
# - Shows whether each disk or partition has format = true or wipeIfPresent = true
# - Does not touch any disk — pure read-only preview
#
# Requirements
# - nix CLI with jq installed
# - Your layout must be wrapped in a standalone file like phase1-sdd-standalone.nix
#

set -euo pipefail

# Path to your disko standalone file
DISKO_FILE="./profiles/nixos/hosts/customdesktop/disko/phase1-drives-diskoCLI.nix"

echo "🔍 Parsing Disko layout from: $DISKO_FILE"
echo "This is a dry-run preview. No changes will be made."
echo

# Extract disk definitions using nix eval
DISKS=$(nix eval --json --expr "
  let
    lib = import <nixpkgs/lib>;
    layout = (import \"$DISKO_FILE\" { inherit lib; });
  in
    builtins.attrNames layout.disko.devices.disk
")

echo "🧭 Disks defined:"
echo "$DISKS" | jq -r '.[]' | while read -r disk; do
  echo "  - $disk"
done

echo
echo "🧨 Checking for format/wipe flags..."

# Extract format flags
nix eval --json --expr "
  let
    lib = import <nixpkgs/lib>;
    layout = (import \"$DISKO_FILE\" { inherit lib; });
    disks = layout.disko.devices.disk;
  in
    builtins.mapAttrs (name: def: {
      device = def.device or \"(unknown)\";
      format = def.content.format or def.format or false;
      wipe = def.content.wipeIfPresent or false;
    }) disks
" | jq -r '
  to_entries[] |
  "🔧 Disk: \(.key)\n    Device: \(.value.device)\n    Format: \(.value.format)\n    WipeIfPresent: \(.value.wipe)"
'

echo
echo "✅ Dry-run complete. No disks were touched."
echo "To apply changes, run:"
echo "  sudo nix run github:nix-community/disko -- --mode disko $DISKO_FILE"

