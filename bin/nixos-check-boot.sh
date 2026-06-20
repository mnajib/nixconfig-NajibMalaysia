#!/usr/bin/env bash
set -euo pipefail

BOOTED_SYS=$(readlink -f /run/booted-system)
CURRENT_SYS=$(readlink -f /run/current-system)
LATEST_SYS=$(readlink -f /nix/var/nix/profiles/system)

echo "=== NixOS Generation State ==="
echo "Booted:  $BOOTED_SYS"
echo "Current: $CURRENT_SYS"
echo "Latest:  $LATEST_SYS"
echo "------------------------------"

if [ "$BOOTED_SYS" = "$LATEST_SYS" ]; then
    echo "✅ Up to date. The host has been rebooted into the latest build."
elif [ "$CURRENT_SYS" = "$LATEST_SYS" ] && [ "$BOOTED_SYS" != "$LATEST_SYS" ]; then
    echo "⚠️  Live switched only. Active profile matches latest build, but kernel/base services require a reboot."
else
    echo "❌ Out of date. A new system build exists (generation 30+) but is neither active nor booted."
    echo "   Run 'sudo nixos-rebuild switch' or reboot to apply."
fi
