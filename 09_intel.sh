source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  linux-headers \
  xf86-video-intel vulkan-intel intel-ucode
