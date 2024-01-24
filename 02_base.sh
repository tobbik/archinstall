source config.sh

# package installation
pacman -S --needed --noconfirm \
  archlinux-keyring pacman-contrib mkinitcpio

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  wpa_supplicant wireless_tools net-tools iwd openssh \
  rsync whois nmap wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils man-pages man-db lsof \
  powertop acpi tlp acpi_call smartmontools nfs-utils \
  wol dmidecode rng-tools \
  pwgen mlocate linux-firmware

if [ $(uname -m) = 'x86_64' ]; then
  s pacman -S --noconfirm vbetool
fi

systemctl enable sshd
systemctl enable systemd-timesyncd

echo "Setup hardware random number generator"
sed -i 's:^\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
systemctl enable rngd


mkdir /etc/iwd  &&  cat > /etc/iwd/main.conf << EOIWDCONF
[General]
EnableNetworkConfiguration=True

[Network]
EnableIPv6=True
NameResolvingService=systemd

EOIWDCONF
