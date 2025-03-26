source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  linux-headers \
  xf86-video-amdgpu vulkan-radeon amdvlk amd-ucode
