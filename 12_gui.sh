source config.sh
source helper.sh


# Everyday GUI tools
pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-bitstream-vera ttf-ubuntu-font-family \
  zathura-pdf-mupdf mupdf-gl \
  tesseract-data-eng tesseract-data-osd \
  pavucontrol ario mpv yt-dlp aria2 atomicparsley \
  python-mutagen python-pycryptodome python-pycryptodomex \
  python-websockets python-brotli python-brotlicffi \
  python-xattr python-pyxattr python-secretstorage

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
    ghostty
  add_dotfiles ".config/ghostty" ".config/gtk-4.0"
fi

add_dotfiles ".config/mpv" ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf"

# setup user audio base configs
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pipewire:"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pulse:"
fi

add_export "GTK_THEME" "Adwaita:dark"
