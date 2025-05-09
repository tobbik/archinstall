source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  linux-headers linux-firmware \
  xf86-video-intel vulkan-intel intel-ucode
