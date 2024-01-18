source config.sh

# everything Xorg and Terminals
# XFCE Desktop
# lightdm Display Manager
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau \
  xorg-server xorg-apps xorg-xinit mesa mesa-demos \
  xorg-xclipboard xclip xsel xdg-utils \
  xterm rxvt-unicode rxvt-unicode-terminfo \
  xfce4 xfce4-goodies \
  lightdm lightdm-gtk-greeter light-locker

# set xfce4 as standard X desktop for non graphical login
cp /etc/X11/xinit/xinitrc                /home/${USERNAME}/.xinitrc
sed  -i "/twm/d;/xclock/d;/xterm/d"      /home/${USERNAME}/.xinitrc
echo -e "\nxset -b\nexec startxfce4" >>  /home/${USERNAME}/.xinitrc

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

# LightDM settings
sed -i "s/#pam-service/pam-service/" /etc/lightdm/lightdm.conf
sed -i "s/#session-wrapper/session-wrapper/" /etc/lightdm/lightdm.conf

systemctl enable lightdm.service

cat >> /etc/polkit-1/rules.d/85-suspend.rules << EORULES
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.suspend" &&
        subject.isInGroup("users")) {
        return polkit.Result.YES;
    }
});
EORULES


