pacman -S --needed --noconfirm \
  sudo screen abs

useradd --gid users \
  --groups wheel,network,video,audio,storage,power \
  --create-home \
  --password $USERPASS \
  --shell /bin/bash \
  $USERNAME

sed -i "s/^\(root .*\)$/\1\n${USERNAME} ALL=(ALL) ALL/" /etc/sudoers

# reset the password to be sure
echo -e "${USERPASS}\n${USERPASS}" | (passwd -q ${USERNAME})

# set root password
echo -e "${ROOTPASS}\n${ROOTPASS}" | (passwd -q root)

# copy all .files (vim,terminal stuff etc.)
cp -r ./usertemplate/* ./usertemplate/. /home/${USERNAME}

# set up .bashrc with some aliases
cat >> /home/${USERNAME}/.bashrc << EOBASHRC
# to make sure terminals remain quiet
xset -b

alias s='sudo'
alias ll='ls --color=auto -l'
alias la='ls --color=auto -a'
alias lla='ls --color=auto -l -a'

EOBASHRC

# set a hardstatus for .screenrc
echo "hardstatus alwayslastline '%{= G}%-Lw%{= R}[%n*%f %t]%{= G}%+Lw%='" >> \
  /home/${USERNAME}/.screenrc
echo -e "\nterm screen-256color\n" >> /home/${USERNAME}/.screenrc

