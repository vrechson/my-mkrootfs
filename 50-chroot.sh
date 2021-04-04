#!/usr/bin/env sh
set -o errexit
cd /mnt

arch-chroot . /usr/bin/bash <<EOF
#!/usr/bin/env sh
set -o errexit

locale-gen
hwclock --systohc
timedatectl set-ntp true

sudo pacman-key --init
sudo pacman-key --populate archlinux

# Black Arch
#curl -O 'https://blackarch.org/strap.sh'
#echo d062038042c5f141755ea39dbd615e6ff9e23121 strap.sh | sha1sum -c
#chmod +x strap.sh && ./strap.sh
#rm strap.sh

#groupmod -g 10 wheel
#groupmod -g 100 users
#useradd -Uu 1000 -m vrechson
#usermod -aG users,wheel vrechson

curl 'https://repo.jkanetwork.com/repo/chaotic-aur/x86_64/chaotic-mirrorlist-20210329-1-any.pkg.tar.zst' -o /tmp/mirrorlist.pkg.tar.zst
curl 'https://repo.jkanetwork.com/repo/chaotic-aur/x86_64/chaotic-keyring-20210330-1-any.pkg.tar.zst' -o /tmp/keyring.pkg.tar.zst
pacman -U --noconfirm --needed /tmp/keyring.pkg.tar.zst /tmp/mirrorlist.pkg.tar.zst

# Chaotic Aur
sed -i'' "s/#\[chaotic-aur\]/\[chaotic-aur\]/g" ./etc/pacman.conf
sed -i'' "s/\#Include = \/etc\/pacman.d\/chaotic-mirrorlist/Include = \/etc\/pacman.d\/chaotic-mirrorlist/g" ./etc/pacman.conf

pacman -Sy --noconfirm --needed powerpill

powerpill -Su --noconfirm --needed --overwrite /boot/\\* \
	base-devel multilib-devel arch-install-scripts git man{,-pages} \
	sudo paru networkmanager pipewire amd-ucode \
	linux-firmware linux-tkg-bmq-zen2{,-headers} dbus-broker \
	\
	efibootmgr \
	ntfs-3g dosfstools mtools exfat-utils un{rar,zip} p7zip \
	android-udev-git sshfs usbutils \
	\
	dash fish mosh rsync aria2 tmux dashbinsh \
	pango neovim-drop-in openssh htop traceroute wget \
	android-sdk-platform-tools dnsmasq hostapd inetutils network-manager-applet \
	networkmanager-openvpn nm-eduroam-ufscar ca-certificates-icp_br dhcpcd keybase-gui \
	\
	{,lib32-}mesa {,lib32-}libva{,-mesa-driver} {,lib32-}vulkan-{icd-loader,radeon} \
	\
	bluez{,-plugins,-utils} \
	pipewire-{alsa,pulse,jack} libpipewire02 \
	\
	xorg xorg-server \
	gnome gnome-tweaks gnome-shell-extensions \
	wl-clipboard-x11 qt5-wayland xdg-desktop-portal{,-wlr-git} \
	i3 i3-battery-popup-git i3lock-color i3lock-fancy-multimonitor-git libusb \
	conky rofi arandr autorandr dunst lynis xautolock zenity samhain python-pywal \
	\
	alacritty nomacs pcmanfm-qt qbittorrent telegram-desktop xarchiver \
	firefox firefox-developer-edition firefox-nightly \
	google-chrome google-chrome-dev chromium \
	mpv audacious{,-plugins} spotify youtube-dl-git \
	pavucontrol flameshot baobab discord feh gimp github-cli \
	neofetch slack wps-office obs\
	\
	{,lib32-}faudio steam steam-native-runtime \
	wine{_gecko,-mono,-tkg-staging-fsync-git} winetricks-git dxvk-mingw-git \
	xf86-input-libinput proton-tkg-git {,lib32-}mangohud vkbasalt gamemode \
	\
	keybase kbfs qemu vinagre scrcpy-git \
	editorconfig-core-c python-pynvim \
	podman podman-compose-git docker docker-compose-bin crun trash-cli \
	\
	gdb yarn python-pip code composer dbeaver genymotion php \
	go jre-openjdk jre-openjdk-headless \
	jre10-openjdk jre10-openjdk-headless \
	jre11-openjdk jre11-openjdk-headless jre8-openjdk jre8-openjdk-headless \
	maven jython \
	\
	gnu-free-fonts gnome-icon-theme \
	ttf-{fira-{code,mono,sans}} ttf-borg-sans-mono \
	ttf-{dejavu,droid,liberation,ubuntu-font-family,wps-fonts} \
	ttf-font-awesome-4 \
	adobe-source-han-sans-jp-fonts \
	\
	wireshark-git aircrack-ng bully dsniff hostapd-wpe pixiewps \
	ltrace strace macchanger massdns metasploit mitmproxy \
	burpsuite nmap httprobe nuclei ffuf amass dirsearch \
	smuggler wpscan ysoserial sqlmap zaproxy \
	aquatone gospider jwt-tool hashid netdiscover ngrok nikto \
	subbrute sublist3r spartan wfuzz sparty spiderfoot \
	dex2jar ghidra jadx mousejack objection capstone \
	aws-cli azure-cli seclists-git \
	\
	binwalk crunch elfutils exiv2 fcrackzip mtr radare2 \
	responder samdump2 shuffledns socat avrude cracklib hashcat jack john

chsh root -s /bin/fish
chsh vrechson -s /bin/fish

usermod -aG audio,kvm,wireshark,docker vrechson

bootctl --path=/boot install
EOF

arch-chroot . sh -c 'echo [ROOT] && passwd root && echo [VRECHSON] && passwd vrechson'

echo 'Finished'
