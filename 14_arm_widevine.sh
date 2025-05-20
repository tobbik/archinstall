source config.sh
source helper.sh

AUR_PACKAGES=(
  widevine-aarch64
)

install_aur_packages "${AUR_PACKAGES[@]}"
