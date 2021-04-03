#!/usr/bin/env sh
set -o errexit
cd /mnt

# install base
pacstrap -GM . base

# genfstab
genfstab -U /mnt | tee -a ./etc/fstab

echo 'Finished'