source config.sh
source helper.sh

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau mesa-demos libvdpau-va-gl \
  wayland ly wl-clipboard dunst mako jq wlr-randr \
  wf-recorder wayvnc grim slurp \
  swaylock swayidle swaybg wlsunset gammastep \
  polkit-gnome brightnessctl kanshi \
  foot foot-terminfo libadwaita \
  mpv libmpdclient pipewire-jack scdoc playerctl \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  labwc fuzzel \
  gnu-free-fonts

sed -i /etc/ly/config.ini \
  -e "s:^save =.*:save = true:" \
  -e "s:^clear_password =.*:clear_password = true:" \
  -e "s:^clock = .*:clock = %c:" \
  -e "s:^big_clock = .*:big_clock = true:" \
  -e "s:^border_fg = .*:border_fg = 3:"

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

if ! test -f /home/${USERNAME}/.config/labwc/autostart ; then
  # copy all relevant .dot files (labwc, foot, fuzzel)
  for CFGS in usertemplate/.config/{labwc,foot,fuzzel,dunst,waybar}; do
    cp -avr ${CFGS} /home/${USERNAME}/.config/
  done
fi

if ! grep -q 'GTK_THEME=' /home/${USERNAME}/.bash_profile; then
  echo "export GTK_THEME=Adwaita:dark" >> /home/${USERNAME}/.bash_profile
fi
