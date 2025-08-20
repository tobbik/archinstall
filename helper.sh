AURBASEURL="https://aur.archlinux.org/cgit/aur.git/snapshot"

ARCH=$(uname -m)
PKG_SUFFIX=pkg.tar.zst
if [ x"$ARCH" == x"aarch64" ]; then
  PKG_SUFFIX=pkg.tar.xz
fi

source config.sh
source aur_tools.sh

function run_module() {
  local moduleFileName="$1"
  local secsAtStart=${SECONDS}
  if [[ ! -z $2 ]] ; then
    secsAtStart="$2"
  fi
  local logPath="logs"
  if [[ ! -z $3 ]] ; then
    logPath="$3"
  fi
  [ -d ${logPath} ] || mkdir -p ${logPath}
  local MBYTES_AVAILABLE_ROOT=$(( $(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $2}') / 1024 ))
  local MBYTES_AVAILABLE_BOOT=$(( $(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $2}') / 1024 ))

  echo "Now executing: ${moduleFileName}:" >> "${logPath}/progress.log"
  local BYTES_ROOT_START=$(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $3}')
  local BYTES_BOOT_START=$(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $3}')
  local START_SECS=${SECONDS}
  source "${moduleFileName}" 2>&1 | tee "${logPath}/${moduleFileName}.log"
  local BYTES_ROOT_END=$(df ${DISKROOTDEVPATH} | tail -n1 | awk '{print $3}')
  local BYTES_BOOT_END=$(df ${DISKBOOTDEVPATH} | tail -n1 | awk '{print $3}')
  local MBYTES_ROOT_ADDED=$((  $(( ${BYTES_ROOT_END} - ${BYTES_ROOT_START} )) / 1024  ))
  local MBYTES_BOOT_ADDED=$((  $(( ${BYTES_BOOT_END} - ${BYTES_BOOT_START} )) / 1024  ))
  local ELAPSED_SECS=$((${SECONDS} - ${START_SECS}))
  echo "    Time Taken:  $(date -u -d @"${ELAPSED_SECS}" +'%-Mm %Ss')" >> "${logPath}/progress.log"
  echo "    MegaBytes added to /    : ${MBYTES_ROOT_ADDED}MB" >> "${logPath}/progress.log"
  echo "    MegaBytes added to /boot: ${MBYTES_BOOT_ADDED}MB" >> "${logPath}/progress.log"
  df -h ${DISKROOTDEVPATH} >> "${logPath}/progress.log"
  df -h ${DISKBOOTDEVPATH} | tail -n1 >> "${logPath}/progress.log"
  echo -e "----------------"    >> "${logPath}/progress.log"
  local SECS_SINCE_START=$((${SECONDS} - ${secsAtStart}))
  echo -e "Overall Time: $(date -u -d @"${SECS_SINCE_START}" +'%-Mm %Ss')\n-----------------\n" >> "${logPath}/progress.log"
}

function enable_service() {
  local SERVICE=$1
  local FORUSER=$2
  if [ x"${FORUSER}" == x"" ]; then
    systemctl is-enabled ${SERVICE} >/dev/null || systemctl enable ${SERVICE}
  else
    sudo --user ${FORUSER} bash -c \
      "XDG_RUNTIME_DIR=\"/run/user/$(id -u ${FORUSER})\" \
       DBUS_SESSION_BUS_ADDRESS=\"unix:path=${XDG_RUNTIME_DIR}/bus\" \
       systemctl --user enable $SERVICE"
  fi
}

function add_dotfiles() {
  for ELEM in $@
  do
    local E_ITEM=$(basename ${ELEM})
    local E_PATH=$(dirname  ${ELEM})
    if test -d dotfiles/${E_PATH}/${E_ITEM} ; then
      if ! test -d ${USERHOME}/${E_PATH}/${E_ITEM} ; then
        [ -d ${USERHOME}/${E_PATH} ] || mkdir -p ${USERHOME}/${E_PATH}
        cp -avr dotfiles/${E_PATH}/${E_ITEM} ${USERHOME}/${E_PATH}/
      fi
    elif test -f dotfiles/${E_PATH}/${E_ITEM} ; then
      if ! test -f ${USERHOME}/${E_PATH}/${E_ITEM} ; then
        [ -d ${USERHOME}/${E_PATH} ] || mkdir -p ${USERHOME}/${E_PATH}
        cp -av dotfiles/${E_PATH}/${E_ITEM} ${USERHOME}/${E_PATH}/
      fi
    else
      echo "Couldn't find CONFIGFILE dotfiles/${E_PATH}/${E_ITEM}"
    fi
  done
}

function add_alias() {
  ALIAS=$1
  COMMAND=$2
  if ! grep -q "alias ${ALIAS}=" ${USERHOME}/.bashrc ; then
    echo -e "alias ${ALIAS}='${COMMAND}'" >> ${USERHOME}/.bashrc
  fi
}

function add_export() {
  VARNAME="$1"
  VARVALUE="$2"
  if ! grep -q "export ${VARNAME}=" ${USERHOME}/.bash_profile ; then
    echo "export ${VARNAME}=${VARVALUE}" >> ${USERHOME}/.bash_profile
  fi
}

function install_aur_packages() {
  local the_packages=("$@")
  for PACKAGE in ${the_packages[@]}; do
    aur_handle_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
  done
}

