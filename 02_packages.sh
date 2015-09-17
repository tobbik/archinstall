# package installation
pacman -S --needed --noconfirm \
  $BOOTMNGR archlinux-keyring netctl sudo openssh \
  abs git postgresql sqlite wireshark-cli mongodb screen

# network
pacman -S --needed --noconfirm \
  dialog wpa_supplicant wpa_actiond wireless_tools net-tools

pacman -S --needed --noconfirm \
  xfce4 xfce4-goodies xorg-server xorg-server-utils xorg-apps xorg-xinit xterm \
  rxvt-unicode rxvt-unicode-terminfo rsync abs htop \
  clang clang-analyzer make tig gdb valgrind pkg-config \
  docker arch-install-scripts lxc haveged bridge-utils linux-headers \
  whois nmap wireshark-gtk wget curl traceroute iperf \
  nginx fcgiwrap \
  lua lua-socket luajit ipython python3 figlet nodejs \
  p7zip zip unzip unrar rox \
  gvim geany geany-plugins scite \
  chromium firefox ttf-dejavu gftp file-roller epdfview \
  xf86-video-vmware xf86-input-vmmouse mesa open-vm-tools gtkmm

