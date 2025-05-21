source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wireshark-qt qt6-multimedia-ffmpeg ghostscript \
  neovim-qt neovide \
  geany geany-plugins scite \
  openconnect openvpn \
  xcb-util xcb-util-cursor scour

add_alias    "gvim" "neovide"
add_dotfiles ".config/neovide"

AUR_PACKAGES=(
  visual-studio-code-bin
)

install_aur_packages "${AUR_PACKAGES[@]}"

