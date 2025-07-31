

#najib@r61> find /sys/devices/platform/i8042 -name name | xargs grep -Fl TrackPoint | sed 's/\/input\/input[0-9]*\/name$//'
#/sys/devices/platform/i8042/serio1/serio2
#najib@r61> cat /sys/devices/platform/i8042/serio1/serio2/sensitivity
#128
#najib@r61> cat /sys/devices/platform/i8042/serio1/serio2/speed
#97
#najib@r61>

echo 220 | sudo tee /sys/devices/platform/i8042/serio1/serio2/sensitivity # try 100
echo 100 | sudo tee /sys/devices/platform/i8042/serio1/serio2/speed # try 100

# set permenantly in /etc/nixos/configuration.nix
#hardware.trackpoint.sensitivity = 100 # default 97
#hardware.trackpoint.speed = 100 # default 128
