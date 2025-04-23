AURBASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

ARCH=$(uname -m)
PKG_SUFFIX=pkg.tar.zst
if [ x"$ARCH" == x"aarch64" ]; then
  PKG_SUFFIX=pkg.tar.xz
fi

source config.sh

function run_module() {
  local moduleFileName="$1"
  local logPath="logs"
  if [[ ! -z $2 ]] ; then
    logPath="$2"
  fi
  [ -d ${logPath} ] || mkdir -p ${logPath}
  local MBYTES_AVAILABLE_ROOT=$(( $(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $2}') / 1024 ))
  local MBYTES_AVAILABLE_BOOT=$(( $(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $2}') / 1024 ))

  echo "Now executing: ${moduleFileName}:" >> "${logPath}/progress.log"
  BYTES_ROOT_START=$(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $3}')
  BYTES_BOOT_START=$(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $3}')
  START_SECS=${SECONDS}
  source "${moduleFileName}" 2>&1 | tee "${logPath}/${moduleFileName}.log"
  ELAPSED_SECS=$((${SECONDS} - ${START_SECS}))
  TIME_PASSED=$(date -u -d @"${ELAPSED_SECS}" +'%-Mm %Ss')
  BYTES_ROOT_END=$(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $3}')
  BYTES_BOOT_END=$(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $3}')
  MBYTES_ROOT_ADDED=$((  $(( ${BYTES_ROOT_END} - ${BYTES_ROOT_START} )) / 1024  ))
  MBYTES_BOOT_ADDED=$((  $(( ${BYTES_BOOT_END} - ${BYTES_BOOT_START} )) / 1024  ))
  echo "    Time Taken:  ${TIME_PASSED}" >> "${logPath}/progress.log"
  echo "    MegaBytes added to /    : ${MBYTES_ROOT_ADDED}MB" >> "${logPath}/progress.log"
  echo "    MegaBytes added to /boot: ${MBYTES_BOOT_ADDED}MB" >> "${logPath}/progress.log"
  df -h | grep ${DISKROOTDEVPATH} >> "${logPath}/progress.log"
  df -h | grep ${DISKBOOTDEVPATH} >> "${logPath}/progress.log"
  echo -e "----------------\n"    >> "${logPath}/progress.log"
}

function enable_service() {
  local SERVICE=$1
  local FORUSER=$2
  if [ x"${FORUSER}" == "x" ]; then
    systemctl is-enabled ${SERVICE} >/dev/null || systemctl enable ${SERVICE}
  else
    sudo --user ${FORUSER} systemctl --user is-enabled ${SERVICE} >/dev/null || \
      sudo --user ${FORUSER} systemctl --user enable ${SERVICE}
  fi
}

function add_dotfiles() {
  local HOME_DIR=/home/${USERNAME}
  for ELEM in $@
  do
    local E_ITEM=$(basename ${ELEM})
    local E_PATH=$(dirname  ${ELEM})
    if test -d dotfiles/${E_PATH}/${E_ITEM} ; then
      if ! test -d ${HOME_DIR}/${E_PATH}/${E_ITEM} ; then
        [ -d ${HOME_DIR}/${E_PATH} ] || mkdir ${HOME_DIR}/${E_PATH}
        cp -avr dotfiles/${E_PATH}/${E_ITEM} ${HOME_DIR}/${E_PATH}/
      fi
    elif test -f dotfiles/${E_PATH}/${E_ITEM} ; then
      if ! test -f ${HOME_DIR}/${E_PATH}/${E_ITEM} ; then
        [ -d ${HOME_DIR}/${E_PATH} ] || mkdir ${HOME_DIR}/${E_PATH}
        cp -av dotfiles/${E_PATH}/${E_ITEM} ${HOME_DIR}/${E_PATH}/
      fi
    else
      echo "Couldn't find CONFIGFILE dotfiles/${E_PATH}/${E_ITEM}"
    fi
  done
}

function add_alias() {
  ALIAS=$1
  COMMAND=$2
  if ! grep -q "alias ${ALIAS}=" /home/${USERNAME}/.bashrc ; then
    echo -e "alias ${ALIAS}='${COMMAND}'" >> /home/${USERNAME}/.bashrc
  fi
}

function add_export() {
  VARNAME="$1"
  VARVALUE="$2"
  if ! grep -q "export ${VARNAME}=" /home/${USERNAME}/.bash_profile ; then
    echo "export ${VARNAME}=${VARVALUE}" >> /home/${USERNAME}/.bash_profile
  fi
}

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

function aur_create_pkg () {
  local ASUSER="$1"
  local OLDDIR=$(pwd)
  cd "$2/$3"
  local PKG="$3"
  echo "     ..... BUILDING '${PKG}' >>>>>>>>>>>"
  sudo --user ${ASUSER} makepkg
  if grep -q '^arch.*any' PKGBUILD ; then
    if pacman -U --needed --noconfirm ${PKG}-*any.${PKG_SUFFIX} ; then
      echo "     ..... PACKAGE INSTALLATION SUCCESS: '${PKG}' >>>>>>>>>>>>"
    else
      echo "     ..... PACKAGE INSTALLATION FAILED: '${PKG}' >>>>>>>>>>>>"
    fi
  else
    if pacman -U --needed --noconfirm ${PKG}-*${ARCH}.${PKG_SUFFIX} ; then
      echo "     ..... PACKAGE INSTALLATION SUCCESS: '${PKG}' >>>>>>>>>>>>"
    else
      echo "     ..... PACKAGE INSTALLATION FAILED: '${PKG}' >>>>>>>>>>>>"
    fi
  fi
  rm -rf src pkg
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
  fi
}

function aur_install_packages() {
  local the_packages=("$@")
  for PACKAGE in ${the_packages[@]}; do
    aur_handle_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
  done
}

