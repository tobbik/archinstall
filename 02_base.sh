source config.sh

$KEYRING=archlinux-keyring
if [ x$(uname -m) = x"aarch64" ]; then
  KEYRING=archlinuxarm-keyring
fi

# package installation
pacman -S --needed --noconfirm \
  $KEYRING mkinitcpio

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  wpa_supplicant wireless_tools net-tools openssh \
  dosfstools exfatprogs e2fsprogs ntfs-3g \
  rsync whois nmap wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils man-pages man-db lsof \
  powertop acpi tlp acpi_call smartmontools nfs-utils \
  wol dmidecode rng-tools mc bmon \
  pwgen mlocate linux-firmware \
  sudo screen tmux \
  efibootmgr efivar pacman-contrib

if [ x$(uname -m) = x"x86_64" ]; then
  pacman -S --needed --noconfirm vbetool
fi

systemctl enable sshd
systemctl enable systemd-timesyncd

echo "Setup hardware random number generator"
sed -i 's:^\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
systemctl enable rngd

