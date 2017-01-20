# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  xorg-server xorg-server-utils xorg-apps xorg-xinit mesa \
  xterm rxvt-unicode rxvt-unicode-terminfo \
  ttf-dejavu ttf-hack gftp file-roller epdfview xdiskusage \
  wireshark-gtk chromium firefox rox


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