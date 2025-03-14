source config.sh

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
