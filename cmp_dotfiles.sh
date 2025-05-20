#!/bin/bash

OLD_DIR=$(pwd)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function handle_item() {
  local ELEM="$1"
  if [ -d "${ELEM}" ]; then
    echo "${ELEM} ... is a directory"
    for DOT_ELEM in "${ELEM}"/* "${ELEM}"/.*; do
      handle_item "${DOT_ELEM}"
    done
  elif [ -f "${ELEM}" ]; then
    printf "${ELEM} ... is a file "
    if [ -f "${HOME}/${ELEM}" ]; then
      if cmp -s "${HOME}/${ELEM}" "${ELEM}"; then
        echo "(un-altered)"
      else
        echo "(diffing)"
        nvim -d "${HOME}/${ELEM}" "${ELEM}"
      fi
    fi
  fi
}

function main() {
  cd ${SCRIPT_DIR}/dotfiles
  for DOT_ITEM in * .*; do
    handle_item "${DOT_ITEM}"
  done
  cd ${OLD_DIR}
}

main "$@"
