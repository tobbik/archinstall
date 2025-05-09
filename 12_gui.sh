source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  file-roller pcmanfm-gtk3 \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-jetbrains-mono-nerd adobe-source-code-pro-fonts \
  ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-ubuntu-mono-nerd \
  awesome-terminal-fonts ttf-font-awesome \
  zathura-pdf-mupdf mupdf-gl mupdf-tools \
  tesseract-data-eng tesseract-data-osd \
  pavucontrol ario \
  qrencode vte4 gtk4

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    ghostty
  add_dotfiles ".config/ghostty" ".config/gtk-4.0"
fi

add_dotfiles ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf"

add_export "GTK_THEME" "Adwaita:dark"

AUR_PACKAGES=(
  iwgtk
  neovim-gtk-git           # non-git currently broken
)

install_aur_packages "${AUR_PACKAGES[@]}"
