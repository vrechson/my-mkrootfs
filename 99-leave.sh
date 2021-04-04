#!/usr/bin/env sh
set -o errexit
cd /mnt

# clear
yes | arch-chroot . pacman -Scc

# umount
umount -R /mnt


echo 'Finished'