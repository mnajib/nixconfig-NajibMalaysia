#!/usr/bin/env bash

# Define the location of the boot entries (usually for systemd-boot)
BOOT_ENTRIES="/boot/loader/entries"

echo "--- Mapping Boot Menu to Git Commits ---"
printf "%-15s | %-10s | %-40s\n" "Generation" "Date" "Git Revision (Short)"
echo "--------------------------------------------------------------------------------"

for entry in $(ls -v $BOOT_ENTRIES/nixos-generation-*.conf); do
    # Extract the generation number from the filename
    GEN_NUM=$(basename "$entry" | sed 's/nixos-generation-\(.*\)\.conf/\1/')
    
    # Get the date of that generation
    GEN_DATE=$(stat -c %y "$entry" | cut -d' ' -f1)
    
    # Find the Nix Store path inside the boot entry
    STORE_PATH=$(grep "linux" "$entry" | awk '{print $2}' | sed 's|/boot-path-placeholder||' | cut -d'/' -f1-4)
    
    # Try to find the revision hash inside that store path
    # We look for /etc/nixos-revision inside the specific system build
    REV_FILE="/nix/var/nix/profiles/system-$GEN_NUM-link/etc/nixos-revision"
    
    if [ -f "$REV_FILE" ]; then
        REV_HASH=$(cat "$REV_FILE")
        # Get the first 7 characters for a short hash
        SHORT_HASH=${REV_HASH:0:7}
        printf "%-15s | %-10s | %-40s\n" "Gen $GEN_NUM" "$GEN_DATE" "$SHORT_HASH"
    else
        printf "%-15s | %-10s | %-40s\n" "Gen $GEN_NUM" "$GEN_DATE" "No revision found"
    fi
done
