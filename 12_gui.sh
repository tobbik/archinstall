source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  file-roller fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  ttf-bitstream-vera ttf-ubuntu-font-family \
  zathura-pdf-mupdf mupdf-gl \
  tesseract-data-eng tesseract-data-osd \
  alsa-tools alsa-utils alsa-plugins pamixer \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum pavucontrol \
  mpd ario

# setup user audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/

add_dotfiles ".config/mpd"
mkdir -p /home/${USERNAME}/.config/mpd/playlists

enable_service pipewire-pulse.service ${USERNAME}
enable_service wireplumber.service ${USERNAME}
enable_service mpd.service ${USERNAME}

