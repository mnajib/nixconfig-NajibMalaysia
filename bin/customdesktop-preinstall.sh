#!/usr/bin/env bash

cryptOpen () {
  cryptsetup open /dev/sdb2 crypt-d47246ca-80af-4cef-b098-29785152ce44
  cryptsetup open /dev/sda2 crypt-cff857d2-f8f9-42ef-8dfb-b412a2c3806f
  cryptsetup open /dev/sdc crpyt-c78abd8f-cb7c-4089-b40b-ab452eea6965
  cryptsetup open /dev/sdd crypt-34be00ce-ed0b-47d9-a7a3-1f2488ad1f63
}

cryptClose () {
  cryptsetup close crypt-d47246ca-80af-4cef-b098-29785152ce44
  cryptsetup close crypt-cff857d2-f8f9-42ef-8dfb-b412a2c3806f
  cryptsetup close crpyt-c78abd8f-cb7c-4089-b40b-ab452eea6965
  cryptsetup close crypt-34be00ce-ed0b-47d9-a7a3-1f2488ad1f63
}

createSubvolumes () {
  mount /dev/mapper/crypt-sda2 /mnt
  btrfs subvol list /mnt

  btrfs subvol create /mnt/nixos
  btrfs subvol create /mnt/root
  btrfs subvol create /mnt/home
  btrfs subvol create /mnt/nix
  btrfs subvol create /mnt/swap

  umount /mnt
}

prepareMountPoints () {
  mount -o compress=zstd,subvol=nixos /dev/mapper/crypt-sda2 /mnt

  mkdir /mnt/root
  mkdir /mnt/home
  mkdir /mnt/nix
  mkdir /mnt/swap

  umount /mnt/
}

mountSubvolumes () {
  # If subvolumes not yet created, do
  #   createSubvolumes

  # If mount points is not available/ready/created, do
  #   prepareMountPoints
  # Only need to run this once for the first time setup

  mount -o compress=zstd,subvol=nixos /dev/mapper/crypt-sda2 /mnt
  mount -o compress=zstd,subvol=home /dev/mapper/crypt-sda2 /mnt/home
  mount -o compress=zstd,subvol=root /dev/mapper/crypt-sda2 /mnt/root
  mount -o compress=zstd,subvol=nix,noatime /dev/mapper/crypt-sda2 /mnt/nix
}

unmountAll () {
  unmountBoots
  unmountSwaps
  unmountSubvolumes
  cryptClose
}

createSwapfile () {
  truncate -s 0 /mnt/swap/swapfile
  chattr +C /mnt/swap/swapfile
  btrfs property set /mnt/swap/swapfile compression none
  dd if=/dev/zero if=/mnt/swap/swapfile bs=1M count=24576 status=progress
  chmod 0600 /mnt/swap/swapfile
  mkswap /mnt/swap/swapfile
}

mountSwaps () {
  mount -o subvol=swap,noatime /dev/mapper/crypt-sda2 /mnt/swap

  # Create swapfile (only needed once)
  #createSwapfile

  swapon /mnt/swap/swapfile
  #swapon -s
}

mountBoots () {
  #mkdir /mnt/boot
  mount /dev/sda1 /mnt/boot
}

mountAll () {
  #createSubvolumes
  #prepareMountPoints
  mountSubvolumes
  mountSwaps
  mountBoots
}

main () {
  mountAll
  #unmountAll
}

main
