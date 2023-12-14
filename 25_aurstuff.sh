source config.sh

PKGSDIR="/home/${USERNAME}/pkgs"
OLDDIR=$(pwd)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"
sudo --user ${USERNAME} mkdir -p ${PKGSDIR}
cd ${PKGSDIR}

pacman -S --needed --noconfirm \
  qt5-webengine \
  intltool

PACKAGES=(
  osmconvert
  splitter
  mkgmap
  nvm
  wrk
  visual-studio-code-bin
  xdiskusage
  zoom
  slack-desktop
  redshift-minimal
)

for PKG in ${PACKAGES[@]}; do
  echo "Creating ${PKG}"
  cd ${PKGSDIR}
  curl ${BASEURL}/${PKG}.tar.gz --output - | tar xz
  chown -R ${USERNAME}:users ${PKG}
  cd ${PKGSDIR}/${PKG}
  sudo --user ${USERNAME} makepkg
  pacman -U --needed --noconfirm ${PKG}-*.pkg.tar.zst
  rm -rf src pkg
done

cd ${OLDDIR}
