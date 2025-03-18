source config.sh

if pacman -Q vim ; then
  pacman -Rdd vim --noconfirm
fi

pacman -S ${PACMANFLAGS} \
  wireshark-qt qt6-multimedia-ffmpeg \
  neovim-qt neovide \
  graphicsmagick imagemagick ghostscript \
  geany geany-plugins scite \
  openconnect openvpn

add_alias "gvim" "neovide"
