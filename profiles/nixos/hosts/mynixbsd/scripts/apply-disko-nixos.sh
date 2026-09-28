#!/usr/bin/env bash
# File: profile/nixos/hosts/mynixbsd/scripts/apply-disko-nixos.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"
DISKO_CONFIG="$FLAKE_DIR/profile/nixos/hosts/mynixhost/disko-nixos.nix"

echo "=== Running Disko for Current Disk Layout ==="
echo "Target Configuration: $DISKO_CONFIG"
echo "WARNING: This command will partition and format /dev/sda!"
read -p "Are you sure you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Operation cancelled."
    exit 1
fi

nix run github:nix-community/disko -- --mode disko "$DISKO_CONFIG"
