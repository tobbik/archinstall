source config.sh
source helper.sh

if [ x"$AUDIOSYSTEM" == x"pipewire" ]; then
  # portals require pipewire ...
  PORTALPACKAGES="xdg-desktop-portal-hyprland"
fi

if [ x"$AUDIOSYSTEM" == x"pulseaudio" ]; then
  PORTALPACKAGES=""
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  hyprland hyprland-protocols hyprpaper hyprlock hypridle \
  hyprsunset hyprpolkitagent hyprpicker \
  nwg-dock-hyprland nwg-panel nwg-displays \
  swaync ${PORTALPACKAGES}

add_dotfiles \
  ".config/hypr/hyprlock.conf" ".config/hypr/hypridle.conf" \
  ".config/hypr/hyprland.conf"
