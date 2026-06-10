#!/usr/bin/env bash

# Stop executing if any command fails
set -euo pipefail

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

echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${BOLD}   NIXOS SYSTEM GENERATIONS STATUS${RESET}"
echo -e "${BOLD}=========================================================================================${RESET}"
# Fixed-width plain text header definitions
printf "${BOLD}%-12s   %-12s   %-19s   %s${RESET}\n" "GENERATION" "STATUS" "DATE CREATED" "STORE PATH HASH"
echo -e "${DIM}-----------------------------------------------------------------------------------------${RESET}"

# Loop through profiles cleanly
for profile in /nix/var/nix/profiles/system-*-link; do
    [ -e "$profile" ] || continue

    GEN_NUM=$(basename "$profile" | grep -o -E '[0-9]+')
    GEN="system-$GEN_NUM"
    TARGET_PATH=$(readlink -f "$profile")
    HASH=$(basename "$TARGET_PATH" | cut -d'-' -f1)

    # Get creation time from the symlink metadata
    DATE=$(date -d "@$(stat -c %Y "$profile")" "+%Y-%m-%d %H:%M")

    # Compute active vs staged rows using crisp color boundaries
    if [ "$TARGET_PATH" = "$ACTIVE_GEN_PATH" ]; then
        STATUS_TEXT="[ ACTIVE ]"
        # Wrap the columns in highlighted colors for the active row
        printf "${GREEN}%-12s   %-12s   %-19s   %.32s...${RESET}\n" "$GEN" "$STATUS_TEXT" "$DATE" "$HASH"
    else
        STATUS_TEXT="[  --  ]"
        # Dim out standard staged configurations so the active one stands out instantly
        printf "${DIM}%-12s   %-12s   %-19s   %.32s...${RESET}\n" "$GEN" "$STATUS_TEXT" "$DATE" "$HASH"
    fi
done

# 2. Check for ad-hoc generation running live
if [ "$ACTIVE_GEN_PATH" != "$CURRENT_ENV_PATH" ]; then
    echo ""
    echo -e "${YELLOW}  WARNING: Your active environment ($CURRENT_ENV_PATH)${RESET}"
    echo -e "${YELLOW}           is an ad-hoc build generation not linked in your profile list!${RESET}"
fi

echo ""
echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${BOLD}   MATCHING GRUB BOOT SELECTION ENTRIES${RESET}"
echo -e "${BOLD}=========================================================================================${RESET}"
echo -e "${DIM}Below are the literal menu selections found inside your /boot/grub/grub.cfg:${RESET}"
echo -e "${DIM}-----------------------------------------------------------------------------------------${RESET}"

# Parse GRUB choices securely
awk -F"[\"']" '/^[[:space:]]*menuentry / {print $2}' /boot/grub/grub.cfg | while read -r TITLE; do
    [ -z "$TITLE" ] && continue

    if [ "$TITLE" = "NixOS" ]; then
        LABEL="[ DEFAULT ]"
        COLOR="$GREEN"
    elif [[ "$TITLE" != *"Configuration"* ]]; then
        LABEL="[ TOOL    ]"
        COLOR="$CYAN"
    else
        GEN_NUM=$(echo "$TITLE" | grep -o -E "Configuration [0-9]+")
        LABEL="[ $GEN_NUM ]"
        COLOR="$DIM"
    fi

    # %-22s handles the padded spacing label perfectly before the color reset sequence takes effect
    printf " ${COLOR}%-22s -> %s${RESET}\n" "$LABEL" "$TITLE"
done
echo -e "${BOLD}=========================================================================================${RESET}"
