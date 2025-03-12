source config.sh

# needs to replace stock mesa for GPU accelleration
yes | pacman -S --needed \
  mesa-panfork-git mali-valhall-g610-firmware

