source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  neovim-qt qgit \
  geany geany-plugins scite \
  xcb-util xcb-util-cursor scour vte4

AUR_PACKAGES=(
  visual-studio-code-bin
  neovim-gtk-git           # non-git currently broken
)

install_aur_packages "${AUR_PACKAGES[@]}"

