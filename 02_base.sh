source config.sh

# package installation
pacman -S --needed --noconfirm \
  $BOOTMNGR archlinux-keyring pacman-contrib netctl openssh

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wireless_tools net-tools

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  rsync whois nmap wireshark-cli wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils man-pages man-db \
  powertop acpi tlp acpi_call tp_smapi smartmontools \
  wol openntpd \
  pavucontrol pulseaudio pulseaudio-alsa pamixer alsa-tools alsa-utils \
  vsftpd vbetool

systemctl enable sshd
