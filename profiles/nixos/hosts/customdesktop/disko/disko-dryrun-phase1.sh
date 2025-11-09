#!/usr/bin/env bash
set -euo pipefail

FILE="./profiles/nixos/hosts/customdesktop/disko/phase1-sdd-standalone.nix"

echo "⚠️  About to run Disko on: $FILE"
echo "This will format and repartition the disk. Continue?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) break;;
    No ) echo "Aborted."; exit 1;;
  esac
done

sudo nix run github:nix-community/disko -- --mode disko "$FILE"

