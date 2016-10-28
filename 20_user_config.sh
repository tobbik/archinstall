# set xfce4 as standard X desktop
cp /etc/X11/xinit/xinitrc                /home/${USERNAME}/.xinitrc
sed  -i "/twm/d;/xclock/d;/xterm/d"      /home/${USERNAME}/.xinitrc
echo -e "\nxset -b\nexec startxfce4" >>  /home/${USERNAME}/.xinitrc

# copy all .files (vim,terminal stuff etc.)
cp -r ./usertemplate/* ./usertemplate/. /home/${USERNAME}

# set up rox symlinks
OLDDIR=$(pwd)
cd /home/${USERNAME}
mkdir -p .config/rox.sourceforge.net/SendTo
cd .config/rox.sourceforge.net/SendTo
ln -s ../../../../../usr/bin/vim gvim
for linkName in ${ROXLINKS[@]}; do
	echo "Create Symlink for ${linkName}"
	ln -s ../../../../../usr/bin/${linkName} ${linkName}
done
cd ${OLDDIR}

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

#set up git
git config --global user.name "${GITNAME}"
git config --global user.email "${GITEMAIL}"
git config --global core.editor "/usr/bin/vim"
git config --global merge.tool "/usr/bin/vimdiff"
mv /root/.gitconfig /home/${USERNAME}/
chown ${USERNAME}:users /home/${USERNAME}/.gitconfig

# docker container directory - if you choose the docker package and not set
# DOCKERSTORAGEPATH the installer will create /home/${USERNAMME}/docker instead
#DOCKERSTORAGEPATH=/mnt/whatever

# start urxvtd at startup
mkdir -p "/home/${USERNAME}/.config/autostart"
cat > "/home/${USERNAME}/.config/autostart/URxvt daemon.desktop" << EOURXVTD
[Desktop Entry]
Encoding=UTF-8
Version=0.9.4
Type=Application
Name=URXvt Daemon
Comment=
Exec=urxvtd -f -q
OnlyShowIn=XFCE;
StartupNotify=false
Terminal=false
Hidden=false
EOURXVTD

# flatten all permissions
chown -R ${USERNAME}:users /home/${USERNAME}
