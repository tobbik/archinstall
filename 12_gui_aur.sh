source config.sh
source build_aur_pkg.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
  meson scdoc qrencode vte4 rust gtk4

PACKAGES=(
  iwgtk
  neovim-gtk-git           # non-git currently broken
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done


