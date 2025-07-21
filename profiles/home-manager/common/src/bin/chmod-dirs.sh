#!/run/current-system/sw/bin/env bash

#p="$1"

#find /mnt/sekolahdocdir -type d -print0 | xargs -0 chmod 775
find ${1} -type d -print0 | xargs -0 chmod 775
