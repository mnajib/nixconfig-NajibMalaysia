#!/usr/bin/env bash

# 1. Get the current running system path
CURRENT_SYS=$(readlink -f /run/current-system)
CURRENT_GEN=$(ls -l /nix/var/nix/profiles/system | grep "$(basename $CURRENT_SYS)" | awk '{print $9}' | cut -d'-' -f2)

# 2. Get the latest system generation (the broken one)
LATEST_GEN=$(nix-env --list-generations --profile /nix/var/nix/profiles/system | tail -n 1 | awk '{print $1}')
LATEST_SYS=$(readlink -f /nix/var/nix/profiles/system-"$LATEST_GEN"-link)

# 3. Extract Git revisions
CURRENT_REV=$(cat "$CURRENT_SYS/etc/nixos-revision" 2>/dev/null)
LATEST_REV=$(cat "$LATEST_SYS/etc/nixos-revision" 2>/dev/null)

echo "--- System Status ---"
echo "Current Booted Generation: $CURRENT_GEN (Revision: ${CURRENT_REV:-Unknown})"
echo "Latest (Broken) Generation: $LATEST_GEN (Revision: ${LATEST_REV:-Unknown})"
echo "---------------------"

if [ "$CURRENT_REV" == "$LATEST_REV" ]; then
    echo "Warning: Both generations point to the same commit. The change might not be committed yet."
elif [ -n "$CURRENT_REV" ] && [ -n "$LATEST_REV" ]; then
    echo "Showing changes between Working ($CURRENT_REV) and Broken ($LATEST_REV):"
    echo ""
    git diff "$CURRENT_REV" "$LATEST_REV"
else
    echo "Could not find git revisions in the system paths. Are you using Flakes?"
fi
