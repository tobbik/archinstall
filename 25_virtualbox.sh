source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  xf86-video-vesa xf86-input-vmmouse open-vm-tools \
  virtualbox-guest-utils virtualbox-guest-modules-arch

enable_service vboxservice.service
