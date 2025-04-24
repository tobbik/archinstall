source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  hunspell-en_ca hunspell-en_us hunspell-de \
  tesseract-data-eng mupdf-tools cups \
  qt5-webengine qt5-remoteobjects \
  patchelf \
  fltk \
  xcb-util xcb-util-cursor

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    signal-desktop
  add_dotfiles ".local/share/applications/signal-desktop.desktop"
fi

AUR_PACKAGES=(
  xdiskusage
)

# ... no ARM packages :-(
if [ x$(uname -m) = x"x86_64" ]; then
AUR_PACKAGES+=(
  masterpdfeditor
  zoom
  slack-desktop
)
fi

install_aur_packages "${AUR_PACKAGES[@]}"
