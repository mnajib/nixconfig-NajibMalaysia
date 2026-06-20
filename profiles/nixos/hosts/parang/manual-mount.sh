#!/usr/bin/env bash

# 1. Buang LUKS container lama
sudo cryptsetup luksErase /dev/nvme0n1p3

# 2. Format LUKS baru
sudo cryptsetup luksFormat \
  --type luks2 \
  /dev/nvme0n1p3

# 3. Buka LUKS
sudo cryptsetup luksOpen /dev/nvme0n1p3 crypted

# 4. Format btrfs
sudo mkfs.btrfs -f /dev/mapper/crypted

# 5. Mount dan buat subvolumes
sudo mount /dev/mapper/crypted /mnt

sudo btrfs subvolume create /mnt/root
sudo btrfs subvolume create /mnt/home
sudo btrfs subvolume create /mnt/nix
sudo btrfs subvolume create /mnt/swap

sudo umount /mnt

# 6. Mount semula dengan options yang betul (ikut disko-config.nix)
sudo mount -t btrfs -o subvol=/root,compress=zstd,noatime /dev/mapper/crypted /mnt

sudo mkdir -p /mnt/{boot,home,nix,.swapvol}
sudo mkdir -p /mnt/boot/efi

sudo mount -t btrfs -o subvol=/home,compress=zstd,noatime /dev/mapper/crypted /mnt/home
sudo mount -t btrfs -o subvol=/nix,compress=zstd,noatime  /dev/mapper/crypted /mnt/nix
sudo mount -t btrfs -o subvol=/swap                       /dev/mapper/crypted /mnt/.swapvol

# 7. Mount /boot dan /boot/efi
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo mount /dev/nvme0n1p2 /mnt/boot/efi

# 8. Sahkan
mount | grep /mnt
