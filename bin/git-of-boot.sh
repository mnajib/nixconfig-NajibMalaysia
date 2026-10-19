#!/usr/bin/env bash
# File: bin/git-of-boot.sh
set -euo pipefail

# --- SELF-DOCUMENTATION BLOCK ---
show_help() {
    cat << 'EOF'
================================================================================
 TOOL NAME: bin/git-of-boot.sh
================================================================================
1. WHAT IT IS:
   - Layman Term (Bahasa Melayu: Ringkasan Mudah):
     Sebuah alat yang menyenaraikan menu but sistem dan memadankannya dengan
     kod sumber Git yang sepadan.
     (A utility that maps your system boot entries directly to their corresponding
     Git source commits.)
   - Technical Definition (Bahasa Melayu: Penjelasan Teknikal):
     Parses systemd-boot configuration entries under /boot/loader/entries/,
     extracts the associated Nix store paths, and resolves the revision hashes
     from /nix/var/nix/profiles/system-*-link/etc/nixos-revision.

2. TARGET AUDIENCES & USE CASES:
   - For Casual Users / Pengguna Biasa:
     Quickly check which version of your configuration text generated a
     particular boot choice.
   - For NixOS Administrators / Pentadbir Sistem:
     Audit boot menu histories and track regression sources across system updates.
   - For DevOps Engineers / Jurutera DevOps:
     Trace deployment provenance from bootloader artifacts back to source control
     tags/commits.

3. HOW TO USE / CARA GUNA:
   $ bin/git-of-boot.sh
   $ bin/git-of-boot.sh --help

================================================================================
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
fi
# --- END OF DOCUMENTATION BLOCK ---

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
