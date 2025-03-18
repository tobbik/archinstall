source config.sh
source helper.sh

# Everyday GUI tools
pacman -S ${PACMANFLAGS} \
  libreoffice-fresh libreoffice-fresh-en-gb libreoffice-fresh-de \
  hunspell-en_ca hunspell-en_us hunspell-de \
  ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto \
  ttf-liberation awesome-terminal-fonts ttf-font-awesome \
  tesseract-data-eng mupdf-tools cups

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S ${PACMANFLAGS} \
    signal-desktop ghostty
fi


add_dotfiles ".config/ghostty" ".config/gtk-4.0"
