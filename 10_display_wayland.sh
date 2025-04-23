source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  PORTALPACKAGES="xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  PORTALPACKAGES=""
fi

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  wayland ly wl-clipboard dunst jq wlr-randr \
  wf-recorder wayvnc grim slurp satty \
  polkit-gnome brightnessctl kanshi \
  foot foot-terminfo libadwaita \
  ${PORTALPACKAGES} playerctl fuzzel \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  ttf-dejavu ttf-dejavu-nerd ttf-droid

sed -i /etc/ly/config.ini \
  -e "s:^#save =.*:save = true:" \
  -e "s:^#save_file =.*:save_file = /etc/ly/save:" \
  -e "s:^#load =.*:load = true:" \
  -e "s:^#blank_password =.*:blank_password = true:" \
  -e "s:^#clock = .*:clock = %c:" \
  -e "s:^#blank_box = .*:blank_box = true:"

enable_service ly.service
enable_service foot-server.service ${USERNAME}

# seatd is installed as a dependency of labwc
usermod -a -G seat ${USERNAME}

add_dotfiles  ".config/foot" ".config/dunst" ".config/fuzzel" \
  ".local/bin/mpd-control" ".local/bin/wayland-screen-shooter" \
  ".local/bin/wayland-screen-brightness" \
  ".local/bin/wayland-volume-adjust" \
  ".local/bin/wayland-window-switcher"

