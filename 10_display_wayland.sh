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
  wayland ly wl-clipboard dunst jq wlr-randr \
  wf-recorder wayvnc grim slurp satty graphicsmagick \
  polkit-gnome brightnessctl kanshi \
  foot foot-terminfo libadwaita \
  ${PORTALPACKAGES} playerctl fuzzel \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  ttf-dejavu ttf-dejavu-nerd ttf-droid \
  ddcutil gtk4 gobject-introspection

sed -i /etc/ly/config.ini \
  -e "s:^#save =.*:save = true:" \
  -e "s:^#save_file =.*:save_file = /etc/ly/save:" \
  -e "s:^#load =.*:load = true:" \
  -e "s:^#blank_password =.*:blank_password = true:" \
  -e "s:^\(border_fg\).*$:\1 = 3:" \
  -e "s:^#clock = .*:clock = %c:" \
  -e "s:^#blank_box = .*:blank_box = true:"

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
  wdisplays
  wlopm
  wlogout
  wlr-which-key
  wlrctl
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles  ".config/foot" ".config/dunst" ".config/fuzzel" \
  ".config/kanshi" ".config/wlr-which-key" \
  ".local/bin/mpd-control" ".local/bin/wayland-screen-shooter" \
  ".local/bin/wayland-screen-brightness" \
  ".local/bin/wayland-volume-adjust" \
  ".local/bin/wayland-window-switcher"

