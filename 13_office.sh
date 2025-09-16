source config.sh
source helper.sh

EXTRAPACKAGES=""
if [ $(uname -m) = 'x86_64' ]; then
  EXTRAPACKAGES="signal-desktop"
  install -D --mode=644 --owner=${USERNAME} --group=users /usr/share/applications/signal-desktop.desktop \
    "${USERHOME}/.local/share/applications/signal-desktop.desktop"
  sed -i "${USERHOME/}.local/share/applications/signal-desktop-wayland.desktop" \
      -e "s/^Name=Signal/\0 (Wayland)" \
      -e "s/^Exec=signal-desktop/\0 --use-tray-icon --enable-features=UseOzonePlatform --ozone-platform=wayland/"
fi

# Advanced office tools
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  qt5-webengine qt5-remoteobjects \
  patchelf xcb-util xcb-util-cursor scour \
  ${EXTRAPACKAGES}

# ... no ARM packages :-(
if [ x$(uname -m) == x"x86_64" ]; then
  AUR_PACKAGES+=(
    masterpdfeditor
    zoom
    slack-desktop-wayland
  )
  install_aur_packages "${AUR_PACKAGES[@]}"
fi

