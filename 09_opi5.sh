source config.sh

# needs to replace stock mesa for GPU accelleration
yes | pacman -S --needed --disable-download-timeout \
  7Ji/linux-firmware-whence 7Ji/linux-firmware \
  7Ji/mesa-panfork-git 7Ji/mali-valhall-g610-firmware

