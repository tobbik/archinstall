source config.sh
source helper.sh

pacman -S --needed --noconfirm \
  bluez-tools bluez-utils

enable_service( bluetooth.service )
