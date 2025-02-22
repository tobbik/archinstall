source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  file-roller guvcview fbset pcmanfm-gtk3 alacritty \
  chromium firefox glfw cups \
  gvfs-smb gvfs-nfs gvfs-mtp \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  hunspell-en_ca hunspell-en_us hunspell-de \
  ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto \
  ttf-ubuntu-font-family ttf-liberation awesome-terminal-fonts ttf-font-awesome \
  zathura-pdf-mupdf tesseract-data-eng mupdf-gl \
  alsa-tools alsa-utils alsa-plugins pamixer \
  pipewire wireplumber pipewire-audio \
  pipewire-alsa pipewire-pulse pipewire-jack \
  helvum pavucontrol

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --noconfirm --needed signal-desktop ghostty
fi

# setupuser audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/

enable_service pipewire-pulse.service ${USERNAME}
enable_service wireplumber.service ${USERNAME}
