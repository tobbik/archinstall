source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wireshark-qt qt6-multimedia-ffmpeg \
  neovim-qt neovide \
  graphicsmagick imagemagick ghostscript \
  geany geany-plugins scite \
  openconnect openvpn

add_alias "gvim" "neovide"
add_dotfiles ".config/neovide"
