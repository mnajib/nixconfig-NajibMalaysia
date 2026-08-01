#!/usr/bin/env bash
cp flake.lock tmp/flake.lock.bak-$(date +%Y%m%d)

# Delete flake.lock
#rm flake.lock
# Regenerate the entire lock, flake.lock
#nix flake lock
# Check
#git diff flake.lock | less
