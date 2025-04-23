source config.sh
source helper.sh

# everything Xorg and Terminals
# XFCE Desktop
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  xorg-server xorg-apps xorg-xinit xf86-video-vesa \
  xorg-xclipboard xclip xsel xdg-utils gammastep \
  xterm rxvt-unicode rxvt-unicode-terminfo \
  xfce4 xfce4-goodies tumbler \
  thunar thunar-volman tumbler \
  ttf-dejavu ttf-dejavu-nerd ttf-droid

# set xfce4 as standard X desktop for non graphical login
cp /etc/X11/xinit/xinitrc                /home/${USERNAME}/.xinitrc
sed  -i "/twm/d;/xclock/d;/xterm/d"      /home/${USERNAME}/.xinitrc
echo -e "\nxset -b\nexec startxfce4" >>  /home/${USERNAME}/.xinitrc

cat >> /etc/polkit-1/rules.d/85-suspend.rules << EORULES
polkit.addRule(function(action, subject) {
    if (action.id == "org.freedesktop.login1.suspend" &&
        subject.isInGroup("users")) {
        return polkit.Result.YES;
    }
});
EORULES

if ! grep -q 'xset -b' /home/${USERNAME}/.bashrc ; then
  echo -e "# keep term silent (no beeps)\nxset -b" >> /home/${USERNAME}/.bashrc
fi

add_dotfiles ".Xresources" ".config/gammastep" ".config/autostart/URXvt deamon.desktop"
sed -i /home/${USERNAME}/.config/gammastep/config.ini \
      -e "s:^adjustment-method=.*$:adjustment-method=randr:"

enable_service gammastep.service ${USERNAME}
