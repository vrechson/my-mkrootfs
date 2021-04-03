#!/usr/bin/env sh
set -o errexit

# create boot
mkfs.vfat -F32 /dev/sdb1

# create rootfs
cryptsetup luksFormat /dev/sdb2
cryptsetup open /dev/sdb2 cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg0 /dev/mapper/cryptlvm
lvcreate -L 8G vg0 -n swap
lvcreate -L 64G vg0 -n root
lvcreate -l 100%FREE vg0 -n home
mkfs.ext4 /dev/vg0/root
mkfs.ext4 /dev/vg0/home
mkswap /dev/vg0/swap

swapon /dev/vg0/swap

echo 'Finished'