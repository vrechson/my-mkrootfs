#!/usr/bin/env sh
set -o errexit
cd /mnt

# HOOKS
sed -i'' "s/base/base udev/g" ./etc/mkinitcpio.conf
sed -i'' "s/autodetect/autodetect keyboard keymap consolefont/g" ./etc/mkinitcpio.conf
sed -i'' "s/block/block encrypt lvm2/g" ./etc/mkinitcpio.conf

echo 'Finished'