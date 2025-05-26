#!/bin/bash

SESSIONNAME=archinstall
INSTALLERPID=$(cat /tmp/archinstall.pid)

if pacman -Q tmux; then
  tmux new-session -s ${SESSIONNAME}
  tmux rename-window -t ${SESSIONNAME}:0 'Installation'
  tmux send-keys -t ${SESSIONNAME}:0  'cd /root/installer' C-m './setup-chroot.sh' C-m
  tmux send-keys -t ${SESSIONNAME}:0  "tail -f /proc/${INSTALLERPID}/1" C-m
  tmux new-window -t ${SESSIONNAME}:1 -n 'Log Files'
  tmux send-keys -t ${SESSIONNAME}:1  'sleep 3 && cd /root/installer/logs' C-m 'ls -l' C-m
else
  echo "can't monitor installation: tmux is not installed"
fi
