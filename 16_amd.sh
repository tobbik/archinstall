source config.sh

pacman -S --needed --noconfirm \
  linux-firmware xf86-video-amdgpu xf86-video-vesa vulkan-radeon amdvlk \
  libva-mesa-driver mesa-vdpau amd-ucode linux-headers
