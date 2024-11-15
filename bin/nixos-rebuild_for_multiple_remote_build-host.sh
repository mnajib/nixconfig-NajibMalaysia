#!/usr/bin/env bash

#build_hosts=("host1" "host2" "host3")
#target_host="your_target_host"

function script_name() {
  echo "${0##*/}"
}

function usage() {
  #echo "Usage: $0 <target_host> <build_host1> <build_host2> ..."
  echo "Usage: $(script_name) <target_host> <build_host1> <build_host2> ..."
}

function build_on_host() {
  local build_host="$1"
  local target_host="$2"

  nixos-rebuild build --flake .#your-system-config --target-host "$target_host" --build-host "$build_host" &
}

# Check for required arguments
if [ $# -lt 2 ]; then
  usage
  exit 1
fi

target_host="$1"
shift

for build_host in "$@"; do
  build_on_host "$build_host" "$target_host"
done

wait  # Wait for all background jobs to finish
