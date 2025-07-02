source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  PORTALPACKAGES="xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  PORTALPACKAGES=""
fi

# wlogout
sudo --user ${USERNAME} gpg --keyserver keyserver.ubuntu.com --recv-keys F4FDB18A9937358364B276E9E25D679AF73C6D2F

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wayland ly wl-clipboard wl-clip-persist mako jq wlr-randr \
  wf-recorder wayvnc grim slurp satty graphicsmagick \
  brightnessctl kanshi fuzzel \
  foot foot-terminfo libadwaita \
  swaylock swayidle swaybg wlsunset gammastep \
  gtklock gtklock-playerctl-module \
  gtklock-powerbar-module gtklock-userinfo-module \
  ${PORTALPACKAGES} playerctl \
  xwayland-satellite wlroots0.18 wayland-protocols \
  gtk-layer-shell gnome-keyring polkit-gnome \
  ttf-dejavu ttf-dejavu-nerd ttf-droid \
  ddcutil gtk4 gobject-introspection

sed -i /etc/ly/config.ini \
  -e "s:^.*allow_empty_password =.*$:allow_empty_password = false:" \
  -e "s:^.*animation =.*:animation = CMatrix:" \
  -e "s:^.*animation_timeout_sec =.*:animation_timeout_sec = 20:" \
  -e "s:^.*auth_fails =.*:auth_fails = 3:" \
  -e "s:^\(border_fg\).*$:\1 = 0x0000FF00:" \
  -e "s:^#clock = .*:clock = %c:" \
  -e "s:^#save =.*:save = true:" \
  -e "s:^#load =.*:load = true:"

cat > /etc/udev/rules.d/90-brightnessctl.rules << EOUDEVRULES
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chgrp input /sys/class/leds/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
EOUDEVRULES

enable_service ly.service
enable_service foot-server.service ${USERNAME}

# seatd is installed as a dependency of labwc
usermod -a -G seat,i2c ${USERNAME}

AUR_PACKAGES=(
  luminance
  sfwbar
  wdisplays
  wlopm
  wlogout
  wlr-which-key
  wlrctl
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles  ".config/foot" ".config/mako" ".config/fuzzel" \
  ".config/kanshi" ".config/wlr-which-key" ".config/wlogout" \
  ".local/bin/mpd-control" ".local/bin/wayland-screen-shooter" \
  ".config/gammastep" ".config/sfwbar" \
  ".config/swayidle" ".config/swaylock" ".config/gtklock"
  ".local/bin/wayland-screen-brightness" \
  ".local/bin/wayland-volume-adjust" \
  ".local/bin/wayland-window-switcher"

sed -i ${USERHOME}/.config/gammastep/config.ini \
  -e "s:^\(adjustment-method\)=.*$:\1=wayland:"

enable_service gammastep.service ${USERNAME}
