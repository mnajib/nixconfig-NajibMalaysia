#!/run/current-system/sw/bin/bash

# grep, sed, awk, 

file="getCSV.txt"
file2="getCSV2.txt"

wget -O "${file}" 'http://www2.e-solat.gov.my/xml/today/?zon=SGR01' --quiet

grep '<description>' "${file}" > "${file2}"


