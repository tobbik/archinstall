source config.sh
source helper.sh

if [ x$(uname -m) = x"aarch64" ]; then
  pacman -S --needed --noconfirm archlinuxarm-keyring mkinitcpio
fi
if [ x$(uname -m) = x"x86_64" ]; then
  pacman -S --needed --noconfirm archlinux-keyring mkinitcpio
fi

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  wpa_supplicant wireless_tools net-tools openssh \
  dosfstools exfatprogs e2fsprogs ntfs-3g \
  rsync whois nmap wget curl traceroute iperf \
  htop btop p7zip zip unzip unrar man-pages man-db lsof \
  cpupower powertop acpi tlp acpi_call \
  smartmontools nfs-utils cifs-utils \
  wol dmidecode rng-tools mc bmon \
  pwgen mlocate linux-firmware \
  sudo screen tmux \
  efibootmgr efivar pacman-contrib

if [ x$(uname -m) = x"x86_64" ]; then
  pacman -S --needed --noconfirm vbetool
fi

enable_service sshd
enable_service systemd-timesyncd

echo "Setup hardware random number generator"
sed -i 's:^.*\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
enable_service rngd

