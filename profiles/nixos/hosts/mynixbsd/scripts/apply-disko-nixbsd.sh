#!/usr/bin/env bash
# File: profile/nixos/hosts/mynixbsd/scripts/apply-disko-nixbsd.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLAKE_DIR="$(dirname "$SCRIPT_DIR")"
DISKO_CONFIG="$FLAKE_DIR/profile/nixos/hosts/mynixhost/disko-nixbsd.nix"

echo "=========================================================="
echo "      DISKO DRIVE REBUILD & FORMATTING SCRIPT             "
echo "=========================================================="
echo "Config File: $DISKO_CONFIG"
echo "CAUTION: ALL DATA ON TARGET DRIVE WILL BE DELETED PERMANENTLY!"
echo "=========================================================="

read -p "Type 'DESTROY' to confirm drive repartitioning: " CONFIRMATION

if [[ "$CONFIRMATION" != "DESTROY" ]]; then
    echo "Aborted. Confirmation text did not match."
    exit 1
fi

echo "Executing Disko..."
nix run github:nix-community/disko -- --mode disko "$DISKO_CONFIG"

echo "Partitioning and formatting complete. Target mounted at /mnt (if applicable)."
