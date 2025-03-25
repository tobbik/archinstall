source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-dejavu-nerd ttf-jetbrains-mono-nerd \
  ttf-ubuntu-font-family ttf-ubuntu-nerd ttf-ubuntu-mono-nerd \
  awesome-terminal-fonts ttf-font-awesome \
  zathura-pdf-mupdf mupdf-gl \
  tesseract-data-eng tesseract-data-osd \
  pavucontrol ario

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    ghostty
  add_dotfiles ".config/ghostty" ".config/gtk-4.0"
fi

add_dotfiles ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf"

add_export "GTK_THEME" "Adwaita:dark"
