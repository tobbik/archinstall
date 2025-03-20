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
pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
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

enable_service ly.service
enable_service foot-server.service ${USERNAME}
enable_service gammastep.service ${USERNAME}

# seatd is installed as a dependency of labwc
usermod -a -G seat ${USERNAME}

add_dotfiles ".config/labwc" ".config/foot" ".config/dunst" ".config/waybar" \
            ".config/fuzzel" ".config/swaylock" ".config/gammastep" \
            ".local/bin/mpd-control" ".local/bin/wayland-screen-shooter" \
            ".local/bin/wayland-volume-adjust" ".local/bin/wayland-window-switcher"

sed -i /home/${USERNAME}/.config/gammastep/config.ini \
      -e "s:^adjustment-method=.*$:adjustment-method=wayland:"
