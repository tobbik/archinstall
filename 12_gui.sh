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
pacman -S --needed --noconfirm \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-bitstream-vera ttf-ubuntu-font-family \
  zathura-pdf-mupdf mupdf-gl \
  tesseract-data-eng tesseract-data-osd \
  alsa-tools alsa-utils alsa-plugins pamixer \
  ${AUDIOPACKAGES} pavucontrol \
  mpd ario mpv

# setup user audio
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  cp -avr /usr/share/pipewire /home/${USERNAME}/.config/
fi
if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  cp -avr /etc/pulse /home/${USERNAME}/.config/
fi

add_dotfiles ".config/mpd" ".config/mpv"
mkdir -p /home/${USERNAME}/.config/mpd/playlists

enable_service pipewire-pulse.service ${USERNAME}
enable_service wireplumber.service ${USERNAME}
enable_service mpd.service ${USERNAME}

