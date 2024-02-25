source config.sh

if ! grep -q ${USERNAME} /etc/passwd ; then
  # copy all .files (vim,terminal stuff etc.)
  cp -R  ./usertemplate /home/${USERNAME}
  cp -av  /etc/skel/.*  /home/${USERNAME}/

  useradd --gid users \
    --groups wheel,network,video,audio,storage,power,locate \
    --password ${USERPASS} \
    --shell /bin/bash \
    ${USERNAME}
else
  usermod -a -G  wheel,network,video,audio,storage,power,locate ${USERNAME}
fi

if [ ! -f /etc/sudoers.d/${USERNAME} ]; then
  # user sudo access
  printf "${USERNAME} ALL=(ALL:ALL) ALL\n" > /etc/sudoers.d/${USERNAME}
fi

# reset the password to be sure
echo -e "${USERPASS}\n${USERPASS}" | (passwd -q ${USERNAME})

# set root password
echo -e "${ROOTPASS}\n${ROOTPASS}" | (passwd -q root)

# set up .bashrc with some aliases
if ! grep -q 'alias lla=' /home/${USERNAME}/.bashrc ; then
  cat >> /home/${USERNAME}/.bashrc << EOBASHRC
# to make sure terminals remains silent (no beeps)
xset -b

alias s='sudo'
alias ll='ls --color=auto -l'
alias la='ls --color=auto -a'
alias lla='ls --color=auto -l -a'
EOBASHRC
fi

# set a hardstatus for .screenrc
if ! grep -q 'hardstatus alwayslastline' /home/${USERNAME}/.screenrc; then
  echo "hardstatus alwayslastline '%{= G}%-Lw%{= R}[%n*%f %t]%{= G}%+Lw%='" >> \
    /home/${USERNAME}/.screenrc
  echo -e "\nterm screen-256color\n" >> /home/${USERNAME}/.screenrc
fi

chown -R ${USERNAME}:users /home/${USERNAME}
