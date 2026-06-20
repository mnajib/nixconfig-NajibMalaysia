#!/usr/bin/env bash

# Ensure we are running with flakes enabled
export NIX_CONFIG="experimental-features = nix-command flakes"

echo "Starting disko partitioning ..."

# Run disko
#cd profiles/nixos/hosts/parang
#nix run github:nix-community/disko -- --mode disko ./disko-config.nix
sudo nix run github:nix-community/disko -- --mode disko ./profiles/nixos/hosts/parang/disko-config.nix

echo "Partitioning complete. Drives are mounted at /mnt."
