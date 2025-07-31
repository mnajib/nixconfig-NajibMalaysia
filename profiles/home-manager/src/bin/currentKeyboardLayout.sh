#!/run/current-system/sw/bin/env bash

#xkbprint -color "${DISPLAY}" - | ps2pdf - > "${1}"
#xkbprint -color "${DISPLAY}" -lg 4 - | ps2pdf - > myCurrentKeyboardLayout.pdf
#xkbprint -color "${DISPLAY}" -lg 4 -ll 4 - | ps2pdf - > myCurrentKeyboardLayout.pdf

#layout=`setxkbmap -query | grep layout | tr -s ' ' | cut -d ' ' -f2`
#variant=`setxkbmap -query | grep variant | tr -s ' ' | cut -d ' ' -f2`
#gkbd-keyboard-display -l ${layout}$'\t'${variant}
#gkbd-keyboard-display -l my$'\t'
#gkbd-keyboard-display -l us\tdvorak
#gkbd-keyboard-display -g 1
#gkbd-keyboard-display -g 2
#gkbd-keyboard-display -g 3
gkbd-keyboard-display -g 4
