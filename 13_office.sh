source config.sh
source helper.sh

# Everyday GUI tools
pacman -S --needed --noconfirm \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  hunspell-en_ca hunspell-en_us hunspell-de \
  ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto \
  ttf-liberation awesome-terminal-fonts ttf-font-awesome \
  tesseract-data-eng mupdf-tools cups

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --noconfirm --needed signal-desktop ghostty
fi

# setupuser audio
cp -avr /usr/share/pipewire /home/${USERNAME}/.config/

enable_service pipewire-pulse.service ${USERNAME}
enable_service wireplumber.service ${USERNAME}
