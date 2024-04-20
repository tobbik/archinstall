ARCH=$(uname -m)
BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

sed -i /etc/makepkg.conf \
  -e "s/purge debug lto/purge !debug lto/"

function prepare_aur_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2"
  local PKG="$3"
  curl ${BASEURL}/${PKG}.tar.gz -O && sudo --user ${ASUSER} tar xzf ${PKG}.tar.gz
  rm ${PKG}.tar.gz && cd ${PKG}
  if grep '^arch=' PKGBUILD | grep -q -i 'any' ; then
    echo "FOUND 'any' architecture. Do nothing."
    return
  fi
  if ! grep '^arch=' PKGBUILD | grep -q -i ${ARCH} ; then
    echo "Adding ${ARCH} to buildable architectures"
    sed -i "s:^\(arch=.*\)):\1 '${ARCH}'):" PKGBUILD
  fi
  echo "..........ARCHITECTURE ADJUSTED >>>>>>>>>>>>>>>>>>"
  cd ${OLDDIR}
}

function create_aur_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2"
  local PKG="$3"
  sudo --user ${ASUSER} makepkg
  if grep -q '^arch.*any' PKGBUILD ; then
    pacman -U --needed --noconfirm ${PKG}-*any.pkg.tar.*
  else
    pacman -U --needed --noconfirm ${PKG}-*${ARCH}.pkg.tar.*
  fi
  rm -rf src pkg
  echo "..........PACKAGE '${PKG}' INSTALLED >>>>>>>>>>>>>>>>>>>>>>"
  cd ${OLDDIR}
}

function handle_aur_pkg() {
  local ASUSER="${1}"
  local BUILDDIR="${2}"
  local PKG="$3"
  echo "_______________################# Creating ${PKG} #######################"
  if [ ! -d ${BUILDDIR} ]; then sudo --user ${ASUSER} mkdir -p ${BUILDDIR}; fi
  if [ ! -d ${BUILDDIR}/${PKG} ]; then
    prepare_aur_pkg ${ASUSER} ${BUILDDIR} ${PKG}
    create_aur_pkg  ${ASUSER} ${BUILDDIR} ${PKG}
  fi
}

