#!/usr/bin/env sh
set -o errexit
cd /mnt

# makepkg
cat <<EOF | sed -i'' -e "/'protocol::agent'/,/# Other common tools:/{//!d};/'protocol::agent'/r /dev/stdin" ./etc/makepkg.conf > /dev/null
DLAGENTS=('ftp::/usr/bin/aria2c -UWget -s8 %u -o %o --max-connection-per-server=8 --min-split-size=1M'
          'http::/usr/bin/aria2c -UWget -s8 %u -o %o --max-connection-per-server=8 --min-split-size=1M'
          'https::/usr/bin/aria2c -UWget -s8 %u -o %o --max-connection-per-server=8 --min-split-size=1M'
          'rsync::/usr/bin/rsync -z %u %o'
          'scp::/usr/bin/scp -C %u %o')

EOF

# powepill
sed -i'' "
	s/\"--max-concurrent-downloads=[^\"]*\"/\"--max-concurrent-downloads=800\"/g;
	s/\"--max-connection-per-server=[^\"]*\"/\"--max-connection-per-server=16\"/g;
	s/\"--min-split-size=[^\"]*\"/\"--min-split-size=2M\"/g;
" ./etc/powerpill/powerpill.json

# services
systemctl --root=. enable dbus-broker
systemctl --root=. --global enable dbus-broker
systemctl --root=. enable NetworkManager
#systemctl --root=. enable sshd

# Why Lennart, why? (boost startup)
systemctl --root=. mask systemd-hostnamed

# create main user
echo '%wheel ALL=(ALL) ALL' | tee -a ./etc/sudoers > /dev/null

echo 'Finished'