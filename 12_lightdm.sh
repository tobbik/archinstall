pacman -S --needed --noconfirm \
  lightdm lightdm-gtk-greeter

sed -i "s/#pam-service/pam-service/" /etc/lightdm/lightdm.conf
sed -i "s/#session-wrapper/session-wrapper/" /etc/lightdm/lightdm.conf

systemctl enable lightdm.service

