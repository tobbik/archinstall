# package installation
pacman -S --needed --noconfirm \
  $BOOTMNGR archlinux-keyring netctl openssh

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wpa_actiond wireless_tools net-tools

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  rsync abs whois nmap wireshark-gtk wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils

systemctl enable sshd
