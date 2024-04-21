source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  file-roller guvcview fbset pcmanfm-gtk3 \
  thunar thunar-archive-plugin thunar-media-tags-plugin thunar-volman tumbler \
  chromium firefox glfw \
  gvfs-smb gvfs-nfs gvfs-mtp \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto \
  ttf-ubuntu-font-family ttf-liberation awesome-terminal-fonts ttf-font-awesome \
  zathura-pdf-mupdf tesseract-data-eng \
  alsa-tools alsa-utils alsa-plugins \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum pavucontrol

# setupuser audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/

enable_service pipewire-pulse.service, ${USERNAME}
enable_service wireplumber.service, ${USERNAME}
