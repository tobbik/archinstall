source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  AUDIOPACKAGES="pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  AUDIOPACKAGES="pulseaudio pulseaudio-alsa \
    pulseaudio-bluetooth pulseaudio-jack"
fi

# Everyday GUI tools
pacman -S ${PACMANFLAGS} \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-bitstream-vera ttf-ubuntu-font-family \
  zathura-pdf-mupdf mupdf-gl \
  tesseract-data-eng tesseract-data-osd \
  alsa-tools alsa-utils alsa-plugins pamixer \
  ${AUDIOPACKAGES} pavucontrol \
  mpd ario mpv yt-dlp aria2 atomicparsley python-mutagen \
  python-pycryptodome python-pycryptodomex \
  python-websockets python-brotli python-brotlicffi \
  python-xattr python-pyxattr python-secretstorage

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S ${PACMANFLAGS} \
    ghostty
  add_dotfiles ".config/ghostty" ".config/gtk-4.0"
fi

add_dotfiles ".config/mpd" ".config/mpv" ".config/libfm" ".config/pcmanfm" ".config/chromium-flags.conf"
mkdir -p /home/${USERNAME}/.config/mpd/playlists

# setup user audio bas configs
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  cp -avr /usr/share/pipewire /home/${USERNAME}/.config/
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pipewire:"
  enable_service pipewire-pulse.service ${USERNAME}
  enable_service wireplumber.service ${USERNAME}
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  cp -avr /etc/pulse /home/${USERNAME}/.config/
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pulse:"
fi

enable_service mpd.service ${USERNAME}

add_export "GTK_THEME" "Adwaita:dark"
