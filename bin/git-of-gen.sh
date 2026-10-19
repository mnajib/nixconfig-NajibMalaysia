#!/usr/bin/env bash
# File: bin/git-of-gen.sh
set -euo pipefail

# --- SELF-DOCUMENTATION BLOCK ---
show_help() {
    cat << 'EOF'
================================================================================
 TOOL NAME: bin/git-of-gen.sh
================================================================================
1. WHAT IT IS:
   - Layman Term (Bahasa Melayu: Ringkasan Mudah):
     Alat pengesan perbezaan kod yang menunjukkan apa yang rosak atau berubah
     antara sistem semasa dengan binaan terakhir yang gagal.
     (A diff analyzer that shows what changed between your working system and
     the latest broken build.)
   - Technical Definition (Bahasa Melayu: Penjelasan Teknikal):
     Extracts git revision metadata from /run/current-system and the latest
     profile generation, running a git diff to display uncommitted or broken changes.

2. TARGET AUDIENCES & USE CASES:
   - For Casual Users / Pengguna Biasa:
     Instantly spot if a recent update broke your configuration before committing.
   - For NixOS Administrators / Pentadbir Sistem:
     Troubleshoot failed rollouts and compare active store profiles against
     unstable branches.
   - For Software Developers / Pembangun Perisian:
     Inspect workspace drift using automated Git revision extraction.

3. HOW TO USE / CARA GUNA:
   $ bin/git-of-gen.sh
   $ bin/git-of-gen.sh --help

================================================================================
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
fi
# --- END OF DOCUMENTATION BLOCK ---

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
