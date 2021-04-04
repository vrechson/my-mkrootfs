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
vgcreate vg0 /dev/mapper/cryptlvm
lvcreate -L 16G vg0 -n swap
lvcreate -L 64G vg0 -n root
lvcreate -l 100%FREE vg0 -n home
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home
mkswap /dev/vg0/swap

swapon /dev/vg0/swap

echo 'Finished'