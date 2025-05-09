AURBASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

ARCH=$(uname -m)
case "${ARCH}" in
  'aarch64') _pkgsuffix='pkg.tar.xz' ;;
  *)         _pkgsuffix='pkg.tar.zst' ;;
esac

# $1 -> USER; $2 -> BUILDDIR; $3 -> PKG
function aur_extract_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2"
  local PKG="$3"
  echo "     ..... DOWNLOADING and EXTRACTING '${PKG}' >>>>>>>>>>>"
  curl ${AURBASEURL}/${PKG}.tar.gz -O && sudo --user ${ASUSER} tar xzf ${PKG}.tar.gz
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

# $1 -> USER; $2 -> BUILDDIR; $3 -> PKG
function aur_build_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2/$3"
  local PKG="$3"
  echo "     ..... BUILDING '${PKG}' >>>>>>>>>>>"
  sudo --user ${ASUSER} makepkg
  rm -rf src pkg
  cd ${OLDDIR}
}

# $1 -> USER; $2 -> BUILDDIR; $3 -> PKG
function aur_install_pkg() {
  local OLDDIR=$(pwd)
  cd "$2/$3"
  local PKGARCH=${ARCH}
  if grep -q '^arch.*any' PKGBUILD ; then
    PKGARCH='any'
  fi
  source PKGBUILD
  for PKG in ${pkgname[@]}; do
    local PKGFILE=${PKG}-${pkgver}-${pkgrel}-${PKGARCH}.${_pkgsuffix}
    if [ ! -f "${PKGFILE}" ]; then
      aur_build_pkg   ${ASUSER} ${BUILDDIR} ${PKG}
      source PKGBUILD     # source again, to re-read git versioned packages
      PKGFILE=${PKG}-${pkgver}-${pkgrel}-${PKGARCH}.${_pkgsuffix}
    fi
    echo "     ..... INSTALLING '${PKGFILE}' >>>>>>>>>>>"
    if pacman -U --needed --noconfirm ${PKGFILE} ; then
      echo "     ..... PACKAGE INSTALLATION SUCCESS: '${PKGFILE}' >>>>>>>>>>>>"
    else
      echo "     ..... PACKAGE INSTALLATION FAILED: '${PKGFILE}' >>>>>>>>>>>>"
    fi
  done
  unset pkgname
  cd ${OLDDIR}
}

function aur_handle_pkg() {
  local ASUSER="${1}"
  local BUILDDIR="${2}"
  local PKG="$3"
  if [ ! -d ${BUILDDIR} ]; then sudo --user ${ASUSER} mkdir -p ${BUILDDIR}; fi

  if [ ! -d ${BUILDDIR}/${PKG} ]; then
    aur_extract_pkg ${ASUSER} ${BUILDDIR} ${PKG}
  fi
  aur_install_pkg ${ASUSER} ${BUILDDIR} ${PKG}
}

