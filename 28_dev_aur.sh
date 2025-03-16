source config.sh
source build_aur_pkg.sh

OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

pacman -S --needed --noconfirm \
  meson scdoc qrencode vte4 rust

PACKAGES=(
  nvm
  wrk
  iwgtk
  neovim-gtk-git           # non-git currently broken
)

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done

# set up .bashrc to invoke nvm properly
if ! grep -q 'init-nvm' /home/${USERNAME}/.bashrc ; then
  cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
if [ -f  /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi
EOBASHRC
fi
