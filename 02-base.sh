#!/usr/bin/env sh
set -o errexit
cd /mnt

# install base
pacstrap -GM . base base-devel linux linux-firmware lvm2

# genfstab
genfstab -U /mnt | tee -a ./etc/fstab

echo 'Finished'