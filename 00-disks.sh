#!/usr/bin/env sh
set -o errexit

# create EFI partition
mkfs.vfat -F32 /dev/sdb1

# create boot -- only if it is using grub
# mkfs.ext2 /dev/sdb2

# create rootfs
cryptsetup luksFormat /dev/sdb2
cryptsetup open /dev/sdb2 cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg /dev/mapper/cryptlvm
lvcreate -L 16G vg -n swap
lvcreate -L 64G vg -n root
lvcreate -l 100%FREE vg -n home
mkfs.ext4 /dev/vg/root
mkfs.ext4 /dev/vg/home
mkswap /dev/vg/swap

swapon /dev/vg/swap

echo 'Finished'