# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  xorg-server xorg-apps xorg-xinit mesa mesa-demos \
  xterm rxvt-unicode rxvt-unicode-terminfo \
  ttf-bitstream-vera ttf-dejavu ttf-droid ttf-hack ttf-inconsolata ttf-roboto ttf-ubuntu-font-family \
  gftp file-roller epdfview xdiskusage \
  wireshark-gtk chromium firefox rox flashplugin \
  gvfs-smb


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
