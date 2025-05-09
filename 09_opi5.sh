source config.sh

# on the opi5 kernel and headers are installed upfront to
# provide wlan drivers and the installation can run on WiFi

# needs to replace stock mesa for GPU accelleration
pacman -S --needed ${PACMANEXTRAFLAGS} \
  7Ji/linux-firmware-whence 7Ji/linux-firmware \
  7Ji/mesa-panfork-git 7Ji/mali-valhall-g610-firmware

