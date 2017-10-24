# package installation
pacman -S --needed --noconfirm \
  $BOOTMNGR archlinux-keyring netctl openssh

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wpa_actiond wireless_tools net-tools

# packers, helpers etc ...
pacman -S --needed --noconfirm \
  rsync whois nmap wireshark-cli wget curl traceroute iperf \
  htop p7zip zip unzip unrar cifs-utils \
  powertop acpi tlp acpi_call tp_smapi smartmontools \
  wol openntpd \
  pavucontrol alsamixer pulseudio pulseudio-alsa aumix pamixer alsa-tools alsa-utils \
  vsftpd

systemctl enable sshd
