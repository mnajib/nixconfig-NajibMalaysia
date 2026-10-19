#!/usr/bin/env bash
# File: bin/nixos-check-boot-generation.sh
set -euo pipefail

# --- SELF-DOCUMENTATION BLOCK ---
show_help() {
    cat << 'EOF'
================================================================================
 TOOL NAME: bin/nixos-check-boot-generation.sh
================================================================================
1. WHAT IT IS:
   - Layman Term (Bahasa Melayu: Ringkasan Mudah):
     Papan pemuka generasi sistem NixOS yang memaparkan senarai binaan aktif
     dan menu but sistemd-boot.
     (A NixOS system generation dashboard displaying active build states and
     systemd-boot menu entries.)
   - Technical Definition (Bahasa Melayu: Penjelasan Teknikal):
     Inspects system profiles in /nix/var/nix/profiles/system-*-link, highlights
     active store hashes using ANSI colors, and parses /boot/loader/entries/ configurations.

2. TARGET AUDIENCES & USE CASES:
   - For Casual Users / Pengguna Biasa:
     View current system status and check which generation is currently default.
   - For NixOS Administrators / Pentadbir Sistem:
     Verify generation numbering, store paths, and identify dangling ad-hoc builds.
   - For Infrastructure Operators / Pengendali Infrastruktur:
     Confirm bootloader target entries during multi-host flake deployments.

3. HOW TO USE / CARA GUNA:
   $ sudo bin/nixos-check-boot-generation.sh
   $ bin/nixos-check-boot-generation.sh --help

================================================================================
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    show_help
    exit 0
fi
# --- END OF DOCUMENTATION BLOCK ---

# Stop executing if any command fails
# Define universally supported ANSI text styles
RESET="\e[0m"
BOLD="\e[1m"
DIM="\e[2m"

# Color definitions
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"

# 1. Fetch live system profiles
ACTIVE_GEN_PATH=$(readlink -f /nix/var/nix/profiles/system)
CURRENT_ENV_PATH=$(readlink -f /run/current-system)
DEFAULT_PROFILE=$(readlink -f /nix/var/nix/profiles/system)

echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${BOLD}   NIXOS SYSTEM GENERATIONS STATUS${RESET}"
echo -e "${BOLD}=========================================================================================${RESET}"
printf "${BOLD}%-12s   %-12s   %-19s   %s${RESET}\n" "GENERATION" "STATUS" "DATE CREATED" "STORE PATH HASH"
echo -e "${DIM}-----------------------------------------------------------------------------------------${RESET}"

for profile in /nix/var/nix/profiles/system-*-link; do
    [ -e "$profile" ] || continue

    GEN_NUM=$(basename "$profile" | grep -o -E '[0-9]+')
    GEN="system-$GEN_NUM"
    TARGET_PATH=$(readlink -f "$profile")
    HASH=$(basename "$TARGET_PATH" | cut -d'-' -f1)

    DATE=$(date -d "@$(stat -c %Y "$profile")" "+%Y-%m-%d %H:%M")

    if [ "$TARGET_PATH" = "$ACTIVE_GEN_PATH" ]; then
        STATUS_TEXT="[ ACTIVE ]"
        printf "${GREEN}%-12s   %-12s   %-19s   %.32s...${RESET}\n" "$GEN" "$STATUS_TEXT" "$DATE" "$HASH"
    else
        STATUS_TEXT="[  --  ]"
        printf "${DIM}%-12s   %-12s   %-19s   %.32s...${RESET}\n" "$GEN" "$STATUS_TEXT" "$DATE" "$HASH"
    fi
done

if [ "$ACTIVE_GEN_PATH" != "$CURRENT_ENV_PATH" ]; then
    echo ""
    echo -e "${YELLOW}  WARNING: Your active environment ($CURRENT_ENV_PATH)${RESET}"
    echo -e "${YELLOW}           is an ad-hoc build generation not linked in your profile list!${RESET}"
fi

echo ""
echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${BOLD}   MATCHING SYSTEMD-BOOT SELECTION ENTRIES${RESET}"
echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${DIM}Below are the menu selections found inside your /boot/loader/entries/:${RESET}"
echo -e "${DIM}-----------------------------------------------------------------------------------------${RESET}"

BOOT_ENTRIES="/boot/loader/entries"
if [ -d "$BOOT_ENTRIES" ]; then
    for entry in $(ls -v "$BOOT_ENTRIES"/nixos-generation-*.conf 2>/dev/null); do
        GEN_NUM=$(basename "$entry" | sed 's/nixos-generation-\(.*\)\.conf/\1/')
        TITLE=$(grep "^title" "$entry" | cut -d' ' -f2-)

        if [[ "$entry" -ef /boot/loader/entries/nixos-default.conf ]]; then
            LABEL="[ DEFAULT ]"
            COLOR="$GREEN"
        else
            LABEL="[ Gen $GEN_NUM ]"
            COLOR="$DIM"
        fi

        printf " ${COLOR}%-22s -> %s${RESET}\n" "$LABEL" "$TITLE"
    done
else
    echo -e "${YELLOW}Directory $BOOT_ENTRIES not found or not mounted.${RESET}"
fi

echo -e "${DIM}-----------------------------------------------------------------------------------------${RESET}"
for profile in /nix/var/nix/profiles/system-*-link; do
    TARGET=$(readlink -f "$profile")
    if [ "$TARGET" = "$DEFAULT_PROFILE" ]; then
        echo "DEFAULT BOOT GENERATION: $(basename "$profile")"
    fi
done
echo -e "${BOLD}=========================================================================================${RESET}"
