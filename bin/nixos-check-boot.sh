#!/usr/bin/env bash
# File: bin/nixos-check-boot.sh

set -euo pipefail

# --- SELF-DOCUMENTATION BLOCK ---
show_help() {
    cat << EOF
================================================================================
 TOOL NAME: nixos-check-boot.sh
================================================================================
1. WHAT IT IS:
   - Layman Term: A health checker that tells you if your NixOS system
     is fully running on the latest built software or if it is stuck on an
     older version.
   - Technical Definition: Compares the store paths of /run/booted-system
     against /run/current-system and /nix/var/nix/profiles/system to detect
     pending reboots.

2. HOW TO USE IT:
   Run the tool directly from your repository root or PATH:
   $ bin/nixos-check-boot.sh

3. USER GUIDES:
   - For Casual Users: Quickly see if you need to restart your computer after
     running a system update.
   - For System Administrators: Inspect exact store path hashes and generation
     sync states across multi-host NixOS environments.

================================================================================
EOF
}

# Check for help flags
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
fi
# --- END OF DOCUMENTATION BLOCK ---


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
