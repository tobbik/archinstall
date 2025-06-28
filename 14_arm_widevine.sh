source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  squashfs-tools

# the widevine package originates from
# https://codeberg.org/mogwai/widevine
#
# in order to keep Netflix happy, override the useragent inside Mozilla like this:
#  - call "about:config"
#  - find or create as 'string' "general.useragent.override"
#  - set to: "Mozilla/5.0 (X11; CrOS aarch64 15329.44.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36"

AUR_PACKAGES=(
  widevine
)

install_aur_packages "${AUR_PACKAGES[@]}"
