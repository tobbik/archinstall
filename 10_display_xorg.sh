source config.sh
source helper.sh

# everything Xorg and Terminals
# XFCE Desktop
# lightdm Display Manager
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau mesa-demos \
  xorg-server xorg-apps xorg-xinit \
  xorg-xclipboard xclip xsel xdg-utils \
  xterm rxvt-unicode rxvt-unicode-terminfo \
  xfce4 xfce4-goodies \
  lightdm lightdm-gtk-greeter light-locker \
  gammastep

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

enable-service( lightdm.service )

cat >> /etc/polkit-1/rules.d/85-suspend.rules << EORULES
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.suspend" &&
        subject.isInGroup("users")) {
        return polkit.Result.YES;
    }
});
EORULES

cat > "/home/${USERNAME}/.config/gammastep/config.ini" << EOGAMMACONFIG
[general]
temp-day=5700
temp-night=3600
fade=1
gamma=0.8
adjustment-method=randr
location-provider=manual

[manual]
lat=48.48
lon=-123.53
EOGAMMACONFIG

enable_service gammastep.service, ${USERNAME}

if ! grep -q 'xset -b' /home/${USERNAME}/.bashrc ; then
  echo -e "# keep term silent (no beeps)\nxset -b" > /home/${USERNAME}/.bashrc
fi
