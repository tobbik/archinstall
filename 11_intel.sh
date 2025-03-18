source config.sh

pacman -S ${PACMANFLAGS} \
  linux-firmware linux-headers \
  xf86-video-vesa libva-mesa-driver mesa-vdpau \
  xf86-video-intel vulkan-intel intel-ucode
