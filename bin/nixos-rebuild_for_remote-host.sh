#!/usr/bin/env bash

#najib@delldesktop ~/s/nixconfig-NajibMalaysia (nixos-23.05)>
nixos-rebuild boot --fast --flake .#keira --target-host julia@keira --use-remote-sudo

nixos-rebuild boot --flake .#khadijah --build-host najib@asmak

