source config.sh

pacman -S --needed --noconfirm \
  bluez-tools bluez-utils

systemctl enable bluetooth.service
