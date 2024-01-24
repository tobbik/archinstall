source config.sh

pacman -S --needed --noconfirm \
  linux-firmware xf86-video-intel xf86-video-vesa vulkan-intel \
  libva-mesa-driver mesa-vdpau intel-ucode
