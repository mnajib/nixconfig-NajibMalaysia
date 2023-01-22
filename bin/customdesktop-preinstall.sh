#mount /dev/mapper/crypt-sda2 /mnt
#btrfs subvol list /mnt
#btrfs subvol create /mnt/nixos
#btrfs subvol create /mnt/root
#btrfs subvol create /mnt/home
#btrfs subvol create /mnt/nix
#btrfs subvol create /mnt/swap
#umount /mnt

#mount -o compress=zstd,subvol=nixos /dev/mapper/crypt-sda2 /mnt
#mkdir /mnt/root
#mkdir /mnt/home
#mkdir /mnt/nix
#mkdir /mnt/swap
#umount /mnt/

mount -o compress=zstd,subvol=nixos /dev/mapper/crypt-sda2 /mnt
mount -o compress=zstd,subvol=home /dev/mapper/crypt-sda2 /mnt/home
mount -o compress=zstd,subvol=root /dev/mapper/crypt-sda2 /mnt/root
mount -o compress=zstd,subvol=nix,noatime /dev/mapper/crypt-sda2 /mnt/nix

mount -o subvol=swap,noatime /dev/mapper/crypt-sda2 /mnt/swap
#truncate -s 0 /mnt/swap/swapfile
#chattr +C /mnt/swap/swapfile
#btrfs property set /mnt/swap/swapfile compression none
#dd if=/dev/zero if=/mnt/swap/swapfile bs=1M count=24576 status=progress
#chmod 0600 /mnt/swap/swapfile
#mkswap /mnt/swap/swapfile
swapon /mnt/swap/swapfile
#swapon -s

#mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
