# package installation
pacman -S --needed --noconfirm \
  $BOOTMNGR archlinux-keyring netctl sudo openssh \
  abs git postgresql sqlite wireshark-cli mongodb screen

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wpa_actiond wireless_tools net-tools

# everything else for XFCE4 and development support
pacman -S --needed --noconfirm \
  xfce4 xfce4-goodies xorg-server xorg-server-utils xorg-apps xorg-xinit xterm \
  rxvt-unicode rxvt-unicode-terminfo rsync abs htop \
  whois nmap wireshark-gtk wget curl traceroute iperf \
  p7zip zip unzip unrar rox \
  chromium firefox ttf-dejavu ttf-hack gftp file-roller epdfview \
  mesa gtkmm

