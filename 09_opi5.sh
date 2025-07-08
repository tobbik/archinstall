source config.sh

# on the opi5 kernel and headers are installed upfront to
# provide wlan drivers and the installation can run on WiFi

# needs to replace stock mesa for GPU accelleration
yes | pacman -S --needed ${PACMANEXTRAFLAGS} \
  linux-firmware usb2host \
  7Ji/mesa-panfork-git 7Ji/mali-valhall-g610-firmware
