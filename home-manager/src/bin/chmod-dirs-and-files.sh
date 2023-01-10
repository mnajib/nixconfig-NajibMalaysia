#!/run/current-system/sw/bin/env bash

find "${1}" -type d -print0 | xargs -0 chmod 775
find "${1}" -type f -print0 | xargs -0 chmod 664
