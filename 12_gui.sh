source config.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  file-roller thunar guvcview \
  chromium firefox \
  gvfs-smb gvfs-nfs \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto ttf-ubuntu-font-family ttf-liberation \
  zathura-pdf-mupdf tesseract-data-eng \
  alsa-tools alsa-utils alsa-plugins \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum pavucontrol


# setupuser audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/
