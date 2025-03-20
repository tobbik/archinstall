BASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

ARCH=$(uname -m)
SUFFIX=pkg.tar.zst
if [ x"$ARCH" == x"aarch64" ]; then
  SUFFIX=pkg.tar.xz
fi

function prepare_aur_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2"
  local PKG="$3"
  echo "     ..... PREPARING '${PKG}' >>>>>>>>>>>"
  curl ${BASEURL}/${PKG}.tar.gz -O && sudo --user ${ASUSER} tar xzf ${PKG}.tar.gz
  rm ${PKG}.tar.gz && cd ${PKG}
  if grep -q '^arch.*any' PKGBUILD ; then
    echo "FOUND 'any' architecture. Do nothing."
  else
    if ! grep '^arch=' PKGBUILD | grep -q -i ${ARCH} ; then
      echo "     ..... ADDING ${ARCH} to buildable architectures"
      sed -i "s:^\(arch=.*\)):\1 '${ARCH}'):" PKGBUILD
    fi
  fi
  cd ${OLDDIR}
}

function create_aur_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2/$3"
  local PKG="$3"
  echo "     ..... BUILDING '${PKG}' >>>>>>>>>>>"
  sudo --user ${ASUSER} makepkg
  if grep -q '^arch.*any' PKGBUILD ; then
    if pacman -U --needed --noconfirm ${PKG}-*any.${SUFFIX} ; then
      echo "     ..... PACKAGE INSTALLATION SUCCESS: '${PKG}' >>>>>>>>>>>>"
    else
      echo "     ..... PACKAGE INSTALLATION FAILED: '${PKG}' >>>>>>>>>>>>"
    fi
  else
    if pacman -U --needed --noconfirm ${PKG}-*${ARCH}.${SUFFIX} ; then
      echo "     ..... PACKAGE INSTALLATION SUCCESS: '${PKG}' >>>>>>>>>>>>"
    else
      echo "     ..... PACKAGE INSTALLATION FAILED: '${PKG}' >>>>>>>>>>>>"
    fi
  fi
  rm -rf src pkg
  cd ${OLDDIR}
}

function handle_aur_pkg() {
  local ASUSER="${1}"
  local BUILDDIR="${2}"
  local PKG="$3"
  if [ ! -d ${BUILDDIR} ]; then sudo --user ${ASUSER} mkdir -p ${BUILDDIR}; fi
  if [ ! -d ${BUILDDIR}/${PKG} ]; then
    echo "################# Creating ${PKG} #######################"
    prepare_aur_pkg ${ASUSER} ${BUILDDIR} ${PKG}
    create_aur_pkg  ${ASUSER} ${BUILDDIR} ${PKG}
  fi
}

