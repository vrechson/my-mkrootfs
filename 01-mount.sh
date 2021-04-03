#!/usr/bin/env sh
set -o errexit

# mount in /mnt
cd /mnt

sudo mkdir ./boot

mount /dev/vg0/root /mnt
mkdir /mnt/home
mount /dev/vg0p/home /mnt/home

# mount boot
sudo mount /dev/sdb1 ./boot

echo 'Finished'