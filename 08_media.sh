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

# packers, helpers, sound etc ...
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  ${AUDIOPACKAGES} mpd mpv yt-dlp aria2 atomicparsley python-mutagen \
  alsa-tools alsa-utils alsa-plugins pamixer \
  python-pycryptodome python-pycryptodomex \
  python-websockets python-brotli python-brotlicffi \
  python-xattr python-pyxattr python-secretstorage

add_dotfiles ".config/mpd" ".config/mpv"
mkdir -p /home/${USERNAME}/.config/mpd/playlists

# setup user audio base configs
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  cp -avr /usr/share/pipewire /home/${USERNAME}/.config/
  enable_service pipewire-pulse.service ${USERNAME}
  enable_service wireplumber.service ${USERNAME}
  sed -i /home/${USERNAME}/.config/mpd/mpd.conf \
      -e "s:^# pipewire$:\0\naudio_output {\n  type    \"pipewire\"\n  name    \"PipeWire Sound Server\"\n}\n:"
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pipewire:"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  cp -avr /etc/pulse /home/${USERNAME}/.config/
  sed -i /home/${USERNAME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pulse:"
fi

enable_service mpd.service ${USERNAME}
