#!/usr/bin/env bash
set -euo pipefail # This ensures the script aborts on any unhandled error, undefined variable, or pipeline failure.

POOL="Riyadh2"
MPOINT="/mnt2"
#DRIVE="/dev/disk/by-id/ata-WDC_WD10SPCX-75KHST0_WXU1AA60XS04"
DRIVE="/dev/disk/by-id/ata-WDC_WD10EZEX-60WN4A2_WD-WCC6Y4ZJA16T"

# Set DRYRUN=true to print commands without executing
DRYRUN="${DRYRUN:-false}"

run_cmd() {
  if [ "$DRYRUN" = "true" ]; then
    echo "DRYRUN: $*"
  else
    eval "$@"
  fi
}

#
# Usage:
#   make_dir "/mnt2/home"
#
make_dir() {
  local DIR="$1"

  #sudo mkdir -p "${DIR}"

  if ! sudo mkdir -p "${DIR}"; then
    echo "❌ Error: Failed to create directory '${DIR}'" >&2
    return 1
  fi

  # Optional: verify the directory exists after creation
  #if [ ! -d "${DIR}" ]; then
  #  echo "❌ Error: '${DIR}' does not exist after mkdir" >&2
  #  return 1
  #fi

  #echo "✅ Created directory '${DIR}'"
  #return 0
  echo "✅ Directory ensured: '${DIR}'"
}

#
# Usage:
#   mount_dataset "/Riyadh2/home" "/mnt2/home"
#
mount_dataset() {
  local DATASET="$1"
  local MOUNTPOINT="$2"

  if [ -z "${DATASET}" ] || [ -z "${MOUNTPOINT}" ]; then
    echo "❌ Error: mount_dataset requires dataset and mountpoint" >&2
    return 1
  fi

  make_dir "${MOUNTPOINT}"

  if mountpoint -q "${MOUNTPOINT}"; then
    local CURRENT
    CURRENT=$(findmnt -n -o SOURCE --target "${MOUNTPOINT}")
    if [ "${CURRENT}" = "${DATASET}" ]; then
      echo "ℹ️ Info: '${MOUNTPOINT}' already has '${DATASET}' mounted, skipping"
      return 0
    else
      echo "⚠️ Warning: '${MOUNTPOINT}' has '${CURRENT}' mounted, not '${DATASET}'" >&2
      return 1
    fi
  fi

  if ! run_cmd "sudo mount -t zfs '${DATASET}' '${MOUNTPOINT}'"; then
    echo "❌ Error: Failed to mount '${DATASET}' at '${MOUNTPOINT}'" >&2
    return 1
  fi

  echo "✅ Mounted '${DATASET}' at '${MOUNTPOINT}'"
}

mount_partition() {
  local PART="$1"
  local TARGET="$2"

  if [ -z "${PART}" ] || [ -z "${TARGET}" ]; then
    echo "❌ Error: mount_partition requires partition and target" >&2
    return 1
  fi

  if [ ! -b "${PART}" ]; then
    echo "❌ Error: Partition '${PART}' not found" >&2
    return 1
  fi

  make_dir "${TARGET}"

  if mountpoint -q "${TARGET}"; then
    echo "ℹ️ Info: '${TARGET}' already mounted, skipping '${PART}'"
    return 0
  fi

  if ! run_cmd "sudo mount '${PART}' '${TARGET}'"; then
    echo "❌ Error: Failed to mount '${PART}' at '${TARGET}'" >&2
    return 1
  fi

  echo "✅ Mounted '${PART}' at '${TARGET}'"
}

# -------------------------------------------------------------------
# Function: set_all
# Mounts all required ZFS datasets and partitions in one go.
# - Creates base mountpoint and subdirectories
# - Mounts ZFS datasets with error checking
# - Mounts boot partitions with error checking
# - Leaves swap commented for optional activation
# -------------------------------------------------------------------
set_all() {
  # Ensure base mountpoint exists
  make_dir "${MPOINT}"

  # Mount the root "nixos" dataset at /mnt2
  mount_dataset "${POOL}/nixos" "${MPOINT}"
  sleep 1

  # Prepare subdirectories under /mnt2
  make_dir "${MPOINT}/root"
  make_dir "${MPOINT}/home"
  make_dir "${MPOINT}/nix"
  sleep 1

  # Mount additional datasets
  mount_dataset "${POOL}/rootuser" "${MPOINT}/root"
  mount_dataset "${POOL}/home" "${MPOINT}/home"
  mount_dataset "${POOL}/nix" "${MPOINT}/nix"

  # Mount /boot partition
  make_dir "${MPOINT}/boot"
  sleep 1
  mount_partition "${DRIVE}-part2" "${MPOINT}/boot"

  # Mount EFI partition
  make_dir "${MPOINT}/boot/efi"
  sleep 1
  mount_partition "${DRIVE}-part3" "${MPOINT}/boot/efi"

  # Enable swap
  #sudo swapon "${DRIVE}-part4"
}

# -------------------------------------------------------------------
# Function: reset_all
# Unmounts all datasets and partitions in reverse order.
# - Swapoff first (if enabled)
# - Unmount EFI, boot, then ZFS datasets
# - Ensures clean teardown
# -------------------------------------------------------------------
reset_all() {
  # disable swap
  #sudo swapoff "${DRIVE}-part4"

  # Unmount EFI partition
  sudo umount "${MPOINT}/boot/efi" || echo "⚠️ Warning: EFI not mounted"

  # Unmount boot partition
  sudo umount "${MPOINT}/boot" || echo "⚠️ Warning: boot not mounted"

  # Unmount ZFS datasets (reverse order)
  sudo umount "${MPOINT}/nix" || echo "⚠️ Warning: nix not mounted"
  sudo umount "${MPOINT}/home" || echo "⚠️ Warning: home not mounted"
  sudo umount "${MPOINT}/root" || echo "⚠️ Warning: root not mounted"
  sudo umount "${MPOINT}" || echo "⚠️ Warning: nixos not mounted"
}

# -------------------------------------------------------------------
# Function: status_all
# Displays the current mount status of all datasets and partitions.
# - Uses findmnt to check each mountpoint
# - Prints dataset/partition identity if mounted
# - Provides clear feedback for onboarding
# -------------------------------------------------------------------
status_all() {
  echo "=== Mount Status ==="

  # Check ZFS datasets
  for target in "${MPOINT}" \
                "${MPOINT}/root" \
                "${MPOINT}/home" \
                "${MPOINT}/nix"; do
    if mountpoint -q "${target}"; then
      local src
      src=$(findmnt -n -o SOURCE --target "${target}")
      echo "✅ ${target} mounted from ${src}"
    else
      echo "❌ ${target} not mounted"
    fi
  done

  # Check boot partitions
  for target in "${MPOINT}/boot" "${MPOINT}/boot/efi"; do
    if mountpoint -q "${target}"; then
      local src
      src=$(findmnt -n -o SOURCE --target "${target}")
      echo "✅ ${target} mounted from ${src}"
    else
      echo "❌ ${target} not mounted"
    fi
  done

  # Optional: check swap
  #if swapon --show | grep -q "${DRIVE}-part4"; then
  #  echo "✅ Swap enabled on ${DRIVE}-part4"
  #else
  #  echo "❌ Swap not enabled"
  #fi

  echo "===================="
}

# -------------------------------------------------------------------
# Function: usage
# Prints help message and exits.
# -------------------------------------------------------------------
usage() {
  cat <<EOF
Usage: $0 {set|reset|status} [options]

Commands:
  set       Mount all ZFS datasets and boot partitions
  reset     Unmount all datasets and partitions (reverse order)
  status    Show current mount status

Options:
  DRYRUN=true   Preview commands without executing them
  POOL=<name>   Override ZFS pool name (default: ${POOL})
  MPOINT=<dir>  Override base mountpoint (default: ${MPOINT})
  DRIVE=<path>  Override disk device ID (default: ${DRIVE})

Examples:
  $0 set
  DRYRUN=true $0 status
  POOL=MyPool MPOINT=/mnt3 $0 reset

EOF
  exit 1
}

#set_all
#reset_all

if [ $# -lt 1 ]; then
  echo "❌ Error: Missing command argument" >&2
  usage
fi

case "$1" in
  set)
    set_all
    ;;
  reset)
    reset_all
    ;;
  status)
    status_all
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "❌ Error: Unknown command '$1'" >&2
    usage
    ;;
esac
