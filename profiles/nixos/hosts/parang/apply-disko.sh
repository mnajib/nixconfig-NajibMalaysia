#!/usr/bin/env bash

# Ensure we are running with flakes enabled
export NIX_CONFIG="experimental-features = nix-command flakes"

echo "Starting disko partitioning on /dev/nvme0n1..."

# Run disko
nix run github:nix-community/disko -- --mode disko ./disko-config.nix

echo "Partitioning complete. Drives are mounted at /mnt."
