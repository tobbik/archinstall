source config.sh

PKGSDIR="/home/${USERNAME}/pkgs"
OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${PKGSDIR}
cd ${PKGSDIR}

pacman -S --needed --noconfirm \
  qt5-webengine \
  intltool \
  patchelf \
  fltk \
  meson scdoc gtk4 qrencode

PACKAGES=(
  masterpdfeditor
  osmconvert
  splitter
  mkgmap
  nvm
  wrk
  visual-studio-code-bin
  xdiskusage
  zoom
  slack-desktop
  iwgtk
  #redshift-minimal
)

for PKG in ${PACKAGES[@]}; do
  echo "_______________################# Creating ${PKG} #######################"
  cd ${PKGSDIR}
  curl ${BASEURL}/${PKG}.tar.gz -O && sudo --user ${USERNAME} tar xzf ${PKG}.tar.gz
  rm ${PKG}.tar.gz && cd ${PKG}
  if ! grep -q '^arch.*any' PKGBUILD ; then
    sed -i "s:^\(arch=.*\)):\1 'aarch64'):" PKGBUILD
  fi
  sudo --user ${USERNAME} makepkg
  if grep -q '^arch.*any' PKGBUILD ; then
    pacman -U --needed --noconfirm ${PKG}-*any.pkg.tar.*
  else
    pacman -U --needed --noconfirm ${PKG}-*$(uname -m).pkg.tar.*
  fi
  rm -rf src pkg
done

cd ${OLDDIR}


# set up .bashrc to invoke nvm properly
cat >> /home/${USERNAME}/.bashrc << EOBASHRC

# initialize node version manager if present
if [ -f  /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi
EOBASHRC
