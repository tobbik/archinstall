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
  hunspell-en_ca hunspell-en_us hunspell-de \
  cups \
  neovide \
  pavucontrol ario guvcview \
  qrencode vte4 gtk4 fltk xorg-server-xvfb blueprint-compiler

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    ghostty
  add_dotfiles ".config/ghostty" ".config/gtk-4.0"
fi

add_dotfiles ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf" ".config/neovide"

add_export "GTK_THEME" "Adwaita:dark"

AUR_PACKAGES=(
  iwgtk
  gnvim-git
  xdiskusage
  overskride
)

install_aur_packages "${AUR_PACKAGES[@]}"

install -D --mode=644 --owner=${USERNAME} --group=users \
  /usr/share/gnvim/runtime/lua/gnvim/init.lua \
  "${USERHOME}/.config/nvim/lua/gnvim/init.lua"
