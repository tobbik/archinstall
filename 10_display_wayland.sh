source config.sh
source helper.sh

# mpv and mpd need ffmpeg which needs a jack server

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  JACKPACKAGES="pipewire-jack ffmpeg xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-wlr"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  JACKPACKAGES="jack2 ffmpeg"
fi

# everything Xorg and Terminals and command line
pacman -S ${PACMANFLAGS} \
  mesa libva-mesa-driver mesa-vdpau mesa-demos libvdpau-va-gl \
  wayland ly wl-clipboard dunst jq wlr-randr \
  wf-recorder wayvnc grim slurp satty \
  swaylock swayidle swaybg wlsunset gammastep \
  polkit-gnome brightnessctl kanshi \
  foot foot-terminfo libadwaita \
  ${JACKPACKAGES} playerctl \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  labwc fuzzel waybar \
  gnu-free-fonts

sed -i /etc/ly/config.ini \
  -e "s:^#save =.*:save = true:" \
  -e "s:^#save_file =.*:save_file = /etc/ly/save:" \
  -e "s:^#load =.*:load = true:" \
  -e "s:^#blank_password =.*:blank_password = true:" \
  -e "s:^#clock = .*:clock = %c:" \
  -e "s:^#blank_box = .*:blank_box = true:"

mkdir -p "/home/${USERNAME}/.config/gammastep"
cat > "/home/${USERNAME}/.config/gammastep/config.ini" << EOGAMMACONFIG
[general]
temp-day=5700
temp-night=3600
fade=1
gamma=1.0
adjustment-method=wayland
location-provider=manual

[manual]
lat=48.48
lon=-123.53
EOGAMMACONFIG

enable_service ly.service
enable_service foot-server.service ${USERNAME}
enable_service gammastep.service ${USERNAME}

# seatd is installed as a dependency of labwc
usermod -a -G seat ${USERNAME}

add_dotfiles ".config/labwc" ".config/foot" ".config/dunst" ".config/waybar" ".config/fuzzel" \
            ".local/bin/mpd-control" ".local/bin/wayland-screen-shooter" \
            ".local/bin/wayland-volume-adjust" ".local/bin/wayland-window-switcher"

if ! grep -q 'GTK_THEME=' /home/${USERNAME}/.bash_profile; then
  echo "export GTK_THEME=Adwaita:dark" >> /home/${USERNAME}/.bash_profile
fi
