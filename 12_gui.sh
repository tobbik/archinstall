source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  file-roller pcmanfm \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-jetbrains-mono-nerd adobe-source-code-pro-fonts \
  ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-ubuntu-mono-nerd \
  awesome-terminal-fonts otf-font-awesome \
  zathura-pdf-mupdf mupdf-gl mupdf-tools \
  tesseract-data-eng tesseract-data-osd \
  hunspell-en_ca hunspell-en_us hunspell-de \
  cups baobab neovide pavucontrol ario \
  libcamera-tools guvcview \
  qrencode vte4 gtk4 fltk xorg-server-xvfb blueprint-compiler appstream-glib

add_dotfiles ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf" ".config/neovide"

prefer_dark_theme

AUR_PACKAGES=(
  iwgtk
  xdiskusage
  overskride
  ttf-ms-fonts
)

install_aur_packages "${AUR_PACKAGES[@]}"

