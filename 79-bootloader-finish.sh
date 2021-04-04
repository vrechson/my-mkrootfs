#!/usr/bin/env sh
set -o errexit
cd /mnt

# Bootloader & its hook
arch-chroot . /usr/bin/bash <<EOF
#!/usr/bin/env sh
set -o errexit

mkinitcpio -Pv
bootctl --path=/boot/ install

echo 'default arch' | sudo tee /boot/loader/loader.conf > /dev/null
echo 'timeout 3' | sudo tee -a /boot/loader/loader.conf > /dev/null
echo 'editor 0' | sudo tee -a /boot/loader/loader.conf > /dev/null

echo 'title Arch Linux' | sudo tee /boot/loader/entries/arch.conf > /dev/null
echo 'linux /vmlinuz-linux' | sudo tee -a /boot/loader/entries/arch.conf > /dev/null
echo 'initrd /initramfs-linux.img' | sudo tee -a /boot/loader/entries/arch.conf > /dev/null
echo "options cryptdevice=UUID=$(sudo blkid /dev/sda2 -s UUID | cut -d '"' -f 2):cryptlvm root=/dev/volume/root quiet rw" | sudo tee -a /boot/loader/entries/arch.conf > /dev/null
EOF

echo 'Finished'