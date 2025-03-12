source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-bitstream-vera ttf-ubuntu-font-family \
  zathura-pdf-mupdf mupdf-gl \
  alsa-tools alsa-utils alsa-plugins pamixer \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum pavucontrol \
  mpd ario

# setup user audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/

if ! test -f /home/${USERNAME}/.config/mpd/mpd.conf ; then
  mkdir -p /home/${USERNAME}/.config/mpd/playlists
  cp -avr usertemplate/.config/mpd/mpd.conf /home/${USERNAME}/.config/mpd/
fi

enable_service pipewire-pulse.service ${USERNAME}
enable_service wireplumber.service ${USERNAME}
enable_service mpd.service ${USERNAME}

