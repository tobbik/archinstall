source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wireshark-qt qt6-multimedia-ffmpeg \
  openconnect openvpn
