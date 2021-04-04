#!/usr/bin/env sh
set -o errexit

# mount in /mnt
mount /dev/vg/root /mnt
mkdir /mnt/home
mount /dev/vg/home /mnt/home

# mount boot
sudo mkdir -p /mnt/boot
mount /dev/sdb1 /mnt/boot
#mount /dev/sdb1 /mnt/boot/efi -- for grub setups

echo 'Finished'