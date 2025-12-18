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

  echo "✅ Created directory '${DIR}'"
  return 0
}

#
# Usage:
#   make_dirs
#
make_dirs() {
  make_dir "${MPOINT}"
  make_dir "${MPOINT}/nixos"
  make_dir "${MPOINT}/root"
  make_dir "${MPOINT}/home"
  make_dir "${MPOINT}/nix"
}

#
# Usage:
#   mount_drive "/Riyadh2/home" "/mnt2/home"
#
mount_drive_old() {
  local DATASET="$1"
  local MOUNTPOINT="$2"

  #sudo mount -t zfs "${DATASET}" "${MOUNTPOINT}"

  # Validate arguments
  if [ -z "${DATASET}" ] || [ -z "${MOUNTPOINT}" ]; then
    echo "❌ Error: mount_drive requires both dataset and mountpoint" >&2
    return 1
  fi

  # Ensure mountpoint exists
  #if [ ! -d "${MOUNTPOINT}" ]; then
  #  echo "⚠️ Warning: Mountpoint '${MOUNTPOINT}' does not exist, creating..."
  #  if ! sudo mkdir -p "${MOUNTPOINT}"; then
  #    echo "❌ Error: Failed to create mountpoint '${MOUNTPOINT}'" >&2
  #    return 1
  #  fi
  #fi
  #
  make_dir "${MOUNTPOINT}"

  # Check if already mounted
  if mountpoint -q "${MOUNTPOINT}"; then
    echo "ℹ️ Info: '${MOUNTPOINT}' is already mounted, skipping '${DATASET}'"
    return 0
  fi

  # Attempt mount
  if ! sudo mount -t zfs "${DATASET}" "${MOUNTPOINT}"; then
    echo "❌ Error: Failed to mount dataset '${DATASET}' at '${MOUNTPOINT}'" >&2
    return 1
  fi

  # Verify mount succeeded
  if ! mountpoint -q "${MOUNTPOINT}"; then
    echo "❌ Error: '${MOUNTPOINT}' is not a valid mountpoint after mount" >&2
    return 1
  fi

  echo "✅ Mounted '${DATASET}' at '${MOUNTPOINT}'"
  return 0
}
#
mount_drive() {
  local DATASET="$1"
  local MOUNTPOINT="$2"

  if [ -z "${DATASET}" ] || [ -z "${MOUNTPOINT}" ]; then
    echo "❌ Error: mount_drive requires dataset and mountpoint" >&2
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

mount_drives() {
  mount_drive "${POOL}/nixos" "${MPOINT}"
  sleep 1
  mount_drive "${POOL}/rootuser" "${MPOINT}/root"
  sleep 1
  mount_drive "${POOL}/home" "${MPOINT}/home"
  sleep 1
  mount_drive "${POOL}/nix" "${MPOINT}/nix"
  sleep 1
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

# mount all
set_all() {
  make_dir "${MPOINT}"
  mount_drive "${POOL}/nixos" "${MPOINT}"
  sleep 1

  make_dir "${MPOINT}/root"
  make_dir "${MPOINT}/home"
  make_dir "${MPOINT}/nix"
  sleep 1
  mount_drive "${POOL}/rootuser" "${MPOINT}/root"
  mount_drive "${POOL}/home" "${MPOINT}/home"
  mount_drive "${POOL}/nix" "${MPOINT}/nix"

  make_dir "${MPOINT}/boot"
  sleep 1
  #sudo mount /dev/sde2 /boot
  #sudo mount "${DRIVE}-part2" /boot
  mount_partition "${DRIVE}-part2" "${MPOINT}/boot"

  make_dir "${MPOINT}/boot/efi"
  sleep 1
  #sudo mount /dev/sde3 /boot/efi
  #sudo mount "${DRIVE}-part3" /boot/efi
  mount_partition "${DRIVE}-part3" "${MPOINT}/efi"

  #sudo swapon /dev/sde4
}

# Unmount all
reset_all() {
  #swapoff /dev/sde4

  sudo umount /boot/efi
  sudo umount /

  #...
}

#make_dirs
#mount_drives

#set_all
#reset_all
