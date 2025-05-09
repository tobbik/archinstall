AURBASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

ARCH=$(uname -m)
case "${ARCH}" in
  'aarch64') _pkgsuffix='pkg.tar.xz' ;;
  *)         _pkgsuffix='pkg.ta.zst' ;;
esac

# $1 -> USER; $2 -> BUILDDIR; $3 -> PKG
function aur_prepare_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2"
  local PKG="$3"
  echo "     ..... PREPARING '${PKG}' >>>>>>>>>>>"
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
function aur_create_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2/$3"
  local PKG="$3"
  echo "     ..... BUILDING '${PKG}' >>>>>>>>>>>"
  sudo --user ${ASUSER} makepkg
  rm -rf src pkg
  cd ${OLDDIR}
}

# $1 -> BUILDDIR; $2 -> PKG
function aur_install_pkg() {
  local OLDDIR=$(pwd)
  cd "$1/$2"
  local PKGARCH=${ARCH}
  if grep -q '^arch.*any' PKGBUILD ; then
    PKGARCH='any'
  fi
  source PKGBUILD
  for PKG in ${pkgname[@]}; do
    local PKGFILE=${PKG}-${pkgver}-${pkgrel}-${PKGARCH}.${_pkgsuffix}
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
    echo "################# Creating ${PKG} #######################"
    aur_prepare_pkg ${ASUSER} ${BUILDDIR} ${PKG}
    aur_create_pkg  ${ASUSER} ${BUILDDIR} ${PKG}
    aur_install_pkg           ${BUILDDIR} ${PKG}
  fi
}

