source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  jdk-openjdk

AUR_PACKAGES=(
  osmtools
  splitter
  mkgmap
)

install_aur_packages "${AUR_PACKAGES[@]}"
