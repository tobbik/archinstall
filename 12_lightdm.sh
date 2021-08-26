source config.sh

pacman -S --needed --noconfirm \
  lightdm lightdm-gtk-greeter light-locker

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
