#!/usr/bin/env bash

## Your prayer time variables
#SUBUH="05:54"
#ZOHOR="13:16"
#ASAR="16:30"
#MAGHRIB="19:24"
#ISYAK="20:38"

#CURRENT_TEXT="Maghrib $MAGHRIB"
#TOOLTIP_TEXT="Subuh: $SUBUH, Zohor: $ZOHOR, Asar: $ASAR, Maghrib: $MAGHRIB, Isyak: $ISYAK"

## Output valid JSON with proper quotes around the text and tooltip
##printf '{"text": "%s", "tooltip": "%s"}\n' "$CURRENT_TEXT" "$TOOLTIP_TEXT"
#printf '{"text": "%s", "tooltip": "%s"}\n' "Waktu Solat" "This is a test"

#-------------------------------------------------------------------------------

#!/usr/bin/env bash

#PRAYER_REMINDER_FILE="/tmp/${USER}-prayer_reminder_file"
PRAYER_REMINDER_FILE="/run/waktusolat/reminder.json"

if [ -f "$PRAYER_REMINDER_FILE" ]; then
    RAW_CONTENT=$(cat "$PRAYER_REMINDER_FILE")
else
    RAW_CONTENT="Waiting for prayer data..."
fi

echo "${RAW_CONTENT}"

## Convert xmobar tags to valid Pango markup safely
## Using [^,>]+ ensures we strictly match hex codes and nothing else
#PANGO_CONTENT=$(echo "$RAW_CONTENT" | sed -E \
#    -e 's/<fc=([^,>]+),([^>]+)>/<span foreground="\1" background="\2">/g' \
#    -e 's/<fc=([^,>]+)>/<span foreground="\1">/g' \
#    -e 's/<\/fc>/<\/span>/g')

## Escape the string for JSON safety using jq
#SAFE_TEXT=$(echo "$PANGO_CONTENT" | jq -aRs .)

# Output in Waybar JSON format
#printf '{"text": %s, "tooltip": "Prayer Times Schedule"}\n' "$SAFE_TEXT"
