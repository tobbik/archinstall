
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
