source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wireshark-qt qt6-multimedia-ffmpeg \
  neovim-qt neovide \
  graphicsmagick imagemagick ghostscript \
  geany geany-plugins scite \
  openconnect openvpn \
  xcb-util xcb-util-cursor

add_alias "gvim" "neovide"
add_dotfiles ".config/neovide"


AUR_PACKAGES=(
  visual-studio-code-bin
)

aur_install_packages "${AUR_PACKAGES[@]}"

