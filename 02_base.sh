source config.sh

# package installation
pacman -S --needed --noconfirm \
  archlinux-keyring pacman-contrib \
  openssh iptables rng-tools mkinitcpio

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wireless_tools net-tools iwd

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  rsync whois nmap wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils man-pages man-db lsof \
  powertop acpi tlp acpi_call smartmontools nfs-utils \
  wol dmidecode \
  alsa-tools alsa-utils alsa-plugins \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  vbetool hyperfine pwgen mlocate \
  linux-firmware

systemctl enable sshd

cat > /etc/iwd/main.conf << EOIWDCONF
[General]
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd

EOIWDCONF
