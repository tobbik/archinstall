source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  linux-firmware linux-headers \
  xf86-video-vesa libva-mesa-driver mesa-vdpau \
  xf86-video-intel vulkan-intel intel-ucode
