source config.sh
source helper.sh

pacman -S ${PACMANFLAGS} \
  bluez-tools bluez-utils

enable_service bluetooth.service
