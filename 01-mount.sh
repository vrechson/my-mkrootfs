#!/usr/bin/env sh
set -o errexit

# mount in /mnt
mkdir -p /mnt/boot

mount /dev/vg0/root /mnt
mkdir /mnt/home
mount /dev/vg0/home /mnt/home

# mount boot
mount /dev/sdb1 /mnt/boot
#mount /dev/sdb1 /mnt/boot/efi -- for grub setups

echo 'Finished'