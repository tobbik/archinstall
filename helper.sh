source config.sh

function run_module() {
  local moduleFileName="$1"
  local logPath="logs"
  if [[ ! -z $2 ]] ; then
    logPath="$2"
  fi
  [ ! -d ${logPath} ]  && mkdir -p ${logPath}
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
  BASHRC=/home/$USERNAME/.bashrc
  if ! grep -q "alias ${ALIAS}=" ${BASHRC} ; then
    echo -e "alias ${ALIAS}='${COMMAND}'" >> ${BASHRC}
  fi
}
