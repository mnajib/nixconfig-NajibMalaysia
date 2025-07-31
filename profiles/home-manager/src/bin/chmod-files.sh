#!/run/current-system/sw/bin/env bash

p=$1

#find /mnt/sekolahdocdir -type f -print0 | xargs -0 chmod 664
find $1 -type f -print0 | xargs -0 chmod 664
