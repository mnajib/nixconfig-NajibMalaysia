#!/run/current-system/sw/bin/env bash

#p=$1
p="/mnt/sekolahdocdir"

find ${p} -type d -print0 | xargs -0 chmod 775
find ${p} -type f -print0 | xargs -0 chmod 664
