source config.sh
source helper.sh

if [ x$(uname -m) == x"aarch64" ]; then
  pacman -S --needed --noconfirm archlinuxarm-keyring mkinitcpio
fi
if [ x$(uname -m) == x"x86_64" ]; then
  pacman -S --needed --noconfirm archlinux-keyring mkinitcpio vbetool 7zip
fi

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  wpa_supplicant wireless_tools net-tools openssh \
  dosfstools exfatprogs e2fsprogs ntfs-3g \
  rsync whois nmap wget curl traceroute iperf \
  htop btop bmon iotop-c powertop \
  zip unzip unrar man-pages man-db lsof \
  cpupower acpi tlp acpi_call \
  smartmontools nfs-utils cifs-utils \
  wol dmidecode rng-tools mc \
  pwgen mlocate linux-firmware \
  sudo tmux \
  efibootmgr efivar pacman-contrib

enable_service sshd
enable_service systemd-timesyncd
usermod -a -G locate ${USERNAME}

echo "Setup hardware random number generator"
sed -i 's:^.*\(RNGD_OPTS=\).*:\1"-o /dev/random -r /dev/hwrng":' /etc/conf.d/rngd
enable_service rngd

if ! grep -q 'SSH_AUTH_SOCK=' /home/${USERNAME}/.bash_profile; then
  echo "export SSH_AUTH_SOCK=\${XDG_RUNTIME_DIR}ssh-agent.socket" >> /home/${USERNAME}/.bash_profile
fi
enable_service ssh-agent.service ${USERNAME}

if [ ! -f /etc/sudoers.d/${USERNAME} ]; then
  # user sudo access
  echo "${USERNAME} ALL=(ALL:ALL) ALL" > /etc/sudoers.d/${USERNAME}
fi

if ! grep -q 'alias s=' /home/${USERNAME}/.bashrc ; then
  echo "alias s='sudo'"         >> /home/${USERNAME}/.bashrc
fi

# set a hardstatus for .screenrc
if ! grep -q 'hardstatus alwayslastline' /home/${USERNAME}/.screenrc; then
  echo "hardstatus alwayslastline '%{= G}%-Lw%{= R}[%n*%f %t]%{= G}%+Lw%='" >> \
    /home/${USERNAME}/.screenrc
  echo -e "\nterm screen-256color" >> /home/${USERNAME}/.screenrc
fi
