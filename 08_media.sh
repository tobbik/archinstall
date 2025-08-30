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
  libva-mesa-driver mesa-vdpau mesa-demos libvdpau-va-gl \
  mesa ffmpeg ${AUDIOPACKAGES} mpd mpc mpv \
  mpd-mpris mpv-mpris \
  yt-dlp aria2 atomicparsley python-mutagen \
  alsa-tools alsa-utils alsa-plugins pamixer \
  python-pycryptodome python-pycryptodomex \
  python-websockets python-brotli python-brotlicffi \
  python-xattr python-pyxattr python-secretstorage \
  avidemux-cli live-media libmatroska faac libfdk-aac libmtp \
  discount libnotify iniparser

# key for mpd-notification
sudo --user ${USERNAME} gpg --recv-keys 4E8FCA25FDAC4855
AUR_PACKAGES=(
  mpd-notification
)
install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/mpd" ".config/mpv" ".config/mpd-notification.conf"

mkdir -p ${USERHOME}/.config/mpd/playlists

# setup user audio base configs
if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  cp -avr /usr/share/pipewire ${USERHOME}/.config/
  enable_service pipewire-pulse.service ${USERNAME}
  enable_service wireplumber.service ${USERNAME}
  sed -i ${USERHOME}/.config/mpd/mpd.conf \
      -e "s:^# pipewire$:\0\naudio_output {\n  type    \"pipewire\"\n  name    \"PipeWire Sound Server\"\n}\n:"
  sed -i ${USERHOME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pipewire:"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  cp -avr /etc/pulse ${USERHOME}/.config/
  sed -i ${USERHOME}/.config/mpv/mpv.conf \
      -e "s:^ao=.*$:ao=pulse:"
fi

enable_service mpd.service ${USERNAME}
enable_service mpd-mpris.service ${USERNAME}
enable_service mpd-notification.service ${USERNAME}
