source config.sh

pacman -S --needed --noconfirm \
  xf86-video-vesa xf86-input-vmmouse open-vm-tools \
  virtualbox-guest-utils virtualbox-guest-modules-arch

systemctl enable vboxservice.service
