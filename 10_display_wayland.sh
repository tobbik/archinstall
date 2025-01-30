source config.sh
source helper.sh

# everything Xorg and Terminals and command line
pacman -S --needed --noconfirm \
  mesa libva-mesa-driver mesa-vdpau mesa-demos \
  wayland ly wl-clipboard dunst mako jq \
  wf-recorder wayvnc grim slurp \
  swaylock swayidle swaybg wlsunset \
  polkit-gnome brightnessctl kanshi \
  fuzzel bemenu-wayland \
  foot foot-terminfo \
  mpv libmpdclient pipewire-jack scdoc \
  xorg-xwayland wlroots wayland-protocols gtk-layer-shell \
  labwc

sed -i /etc/ly/config.ini \
  -e "s:^save.*true.*:save = true:" \
  -e "s:^clear_password.*:clear_password = true:" \
  -e "s:^clock = .*:clock = %c:" \
  -e "s:^big_clock = .*:big_clock = true:" \
  -e "s:^border_fg = .*:border_fg = 3:" \
  -e "s:^vi_mode = .*:vi_mode = true:"

enable_service ly.service
enable_service foot-server.service, ${USERNAME}
enable_service ssh-agent.service, ${USERNAME}

