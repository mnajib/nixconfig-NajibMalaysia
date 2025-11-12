#!/usr/bin/env bash

# Before migration
#osDrive1="ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"               # The zfs is on partition 2
#osDrive2="ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"                               # The zfs is on partition 2
#
# After migration
osDrive1="ata-HUA722010CLA330_43W7625_42C0400IBM_JPW9L0HZ0JD0ZC"                # The zfs is on partition 5
osDrive2="ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"                                # The zfs is on partition 5
osDrive3="ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"                             # The zfs is on partition 5
pool1_name="Riyadh"
pool2_name="Riyadh2"

# ------------------------------------------------------------------------------

source ./monad.sh

#
# Example usage:
#   drivePath "$osDrive3"
# will return:
#   "/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"
#
maybe_drivePath() {
  local drive_name="$1"
  local drive_path="/dev/disk/by-id/${drive_name}"
  echo "Attempting to return path of the drive: $drive_name"
  # Check whether the $drive_name in non-empty and the $drive_path exist
  if [[ -n "$drive_name" && -e "$drive_path" ]]; then
    echo "Just \"${drive_path}\""
  else
    echo "Error: drive path not found"
    echo "Nothing"
    return 1
  fi
}

#
# Example usage:
#   swapOn "/dev/disk/by-id/${osDrive3}-part4"
#
swapOn () {
  local path=$1
  #sudo swapon /dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T-part4
  #sudo swapon "/dev/disk/by-id/${osDrive3}-part4" # The swap is on partition 4
  sudo swapon "$path" # The swap is on partition 4
}

#
# Usage:
#   createPool <pool name> <drive id>
# Example usage:
#   createPool "Riyadh2" "/dev/disk/by-id/${osDrive3}-part5"
#
createPool () {
  local poolName=$1
  local path=$2
  zpool create -f "$poolName" "$path"
}

#
# Usage:
#   maybe_createPool <pool name> <drive id>
# Example usage:
#   maybe_createPool "$pool2_name" "$osDrive3"
#   maybe_createPool "Riyadh2" "ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"
# Result if successful:
#   Just "Riyadh2"
# Result if any step fails:
#   Error: drive path not found
#   Nothing
#
maybe_createPool() {
  local pool_name="$1"
  local drive_id="$2"

  echo "Creating pool '$pool_name' using drive ID '$drive_id'"

  # Resolve drive path safely
  local path_result
  path_result=$(maybe_drivePath "$drive_id") || return 1

  # Unwrap the path
  local path
  path=$(maybe_unwrap "$path_result") || return 1

  # Attempt pool creation
  if zpool create "$pool_name" "$path"; then
    echo "Just \"$pool_name\""
  else
    echo "Error: Failed to create pool '$pool_name' with device '$path'"
    echo "Nothing"
    return 1
  fi
}

#
# Example usage:
#   createDataset "Riyadh2/nixos-root" "legacy"
#   createDataset "Riyadh2/nixos-rootuser" "legacy"
#   createDataset "Riyadh2/nixos-home" "legacy"
#
createDataset () {
  local dataset=$1
  zfs create -o mountpoint=legacy "${dataset}"
}

listDatasets () {
  zfs list
}

destroyDataset () {}

destroyPool () {
  local pool="$1"
  zpool export "$pool"
  zpool destroy "$pool"
}

maybe_export_pool() {
  local pool="$1"
  echo "Attempting to export pool: $pool"
  if zpool export "$pool"; then
    echo "Just \"$pool\""
  else
    echo "Error: Failed to export pool $pool" >&2
    echo "Nothing"
    return 1
  fi
}

maybe_destroy_pool() {
  local pool="$1"
  echo "Attempting to destroy pool: $pool"
  if zpool destroy "$pool"; then
    echo "Just \"$pool\""
  else
    echo "Error: Failed to destroy pool $pool" >&2
    echo "Nothing"
    return 1
  fi
}

teardown_pool() {
  local pool="$1"
  maybe_bind "$(maybe "$pool")" maybe_export_pool | \
  maybe_bind "$(cat -)" maybe_destroy_pool
}

# Set mountpoint of a dataset
#
# Example usage:
#   setMountpoint dataset mountpoint
#   setMountpoint dataset none
#   setMountpoint dataset legacy
#
setMountpoint () {
  local dataset=$1
  local mountpoint=$2
  zfs set mountpoint=${mountpoint} ${dataset}
}

#
# Example usage:
#   createSnapshotOfDataset "Riyadh/nixos-root" "on-2025-09-22-for-migration"
#   createSnapshotOfDataset "Riyadh/nixos-root-user" "on-2025-09-22-for-migration"
#   createSnapshotOfDataset "Riyadh/nixos-home" "on-2025-09-22-for-migration"
#
createSnapshotOfDataset () {
  local dataset
  local snapshotNamePostfix
  zfs snapshot "${dataset}@snap-${snapshotNamePostfix}"
}

#
# Example usage:
#   listSnapshotOfDataset
#   listSnapshotOfDataset Riyadh/nixos-root
#
listSnapshotOfDataset () {
  local dataset=$1
  zfs list -t snapshot -r "${dataset}"
}

copyDataset() {
  local datasetFrom=$1
  local datasetTo=$2
  sudo zfs send "$datasetFrom" | sudo zfs receive -F "$datasetTo"
}

#
# Phase 1: Create temporary bootable pool on /dev/sdd4 (Riyadh2)
# Phase 2: Copy data from old Riyadh (striped) to Riyadh2
# Rebuild nixos to new drive with Riyadh2. Boot into this NixOS.
# Phase 3: Destroy old Riyadh, rebuild as mirror on /dev/sdb2 + /dev/sdf2
# Phase 4: Replicate data back from Riyadh2 to new mirrored Riyadh
# Phase 5: Ensure bootloader and EFI binaries are installed on both drives for resilience
#
main () {
  echo "Doing it ..."

  #local swap_path="/dev/disk/by-id/${osDrive3}-part4"

  #----------------------------------------------------------------------------
  echo "Create Partitions using disko."
  #...

  #----------------------------------------------------------------------------
  echo "Creating pool with name $pool2_name."
  createPool "${pool2_name}" "/dev/disk/by-id/${osDrive3}-part5"

  echo "Creating datasets."
  createDataset "Riyadh2/nixos-root" "legacy"
  createDataset "Riyadh2/nixos-rootuser" "legacy"
  createDataset "Riyadh2/nixos-home" "legacy"

  #----------------------------------------------------------------------------
  echo "Creating backups."
  #...

  #----------------------------------------------------------------------------
  echo "Configure, build and switch to new system (on the new drive)"
  #echo "Swapon the $swap_path"
  #swapOn "$swap_path"
  #...

  #----------------------------------------------------------------------------
  echo "Starting teardown for pool $pool"
  teardown_pool "$pool"

  echo "Rebuild partitions on the two drives."
  #...

  echo "Join the two drives to the new drive."
  #...

  #----------------------------------------------------------------------------
  echo "Test to make sure each one of the three drives can boot on itself alone."
  #...

  #----------------------------------------------------------------------------
  echo "Done."
}

main "$@"

# Dispatch logic
#if declare -f "$1" > /dev/null; then
#  func="$1"
#  shift
#  "$func" "$@"
#else
#  echo "Function '$1' not found."
#  exit 1
#fi
