source config.sh
source helper.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  scour ddcutil glib2-devel gtk4 \
  gtk4 libyaml qt6-base qt6-tools \
  gobject-introspection labwc \
  swaylock swayidle swaybg \
  wlsunset gammastep

# needed for wlr-randr
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48
# wlogout
sudo --user ${USERNAME} gpg --keyserver keyserver.ubuntu.com  --recv-keys F4FDB18A9937358364B276E9E25D679AF73C6D2F

AUR_PACKAGES=(
  labwc-menu-generator-git
  labwc-tweaks-git
  luminance
  sfwbar
  wdisplays
  wlopm
  wlogout
  wlr-which-key
  wlrctl
)

install_aur_packages "${AUR_PACKAGES[@]}"

add_dotfiles ".config/labwc" ".config/sfwbar" ".config/wlr-which-key" \
  ".config/wlogout" ".config/swaylock" ".config/gammastep" \

sed -i /home/${USERNAME}/.config/gammastep/config.ini \
      -e "s:^adjustment-method=.*$:adjustment-method=wayland:"

enable_service gammastep.service ${USERNAME}
