source config.sh
source helper.sh
source build_aur_pkg.sh

if [ x"${USERNAME}" == "x" ]; then
  USERNAME=tobias
fi
if [ x"${AURBUILDDIR}" == "x" ]; then
  AURBUILDDIR=/home/${USERNAME}/pkgs
fi

pacman -S --needed --noconfirm \
  scour ddcutil tllist glib2-devel boost \
  ttf-font gtk4 libyaml qt6-base qt6-tools \
  gobject-introspection

# needed for wlr-randr
sudo --user ${USERNAME} gpg --keyserver keys.gnupg.net --recv-keys 0FDE7BE0E88F5E48
# wlogout
sudo --user ${USERNAME} gpg --keyserver keyserver.ubuntu.com  --recv-keys F4FDB18A9937358364B276E9E25D679AF73C6D2F

PACKAGES=(
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

for PACKAGE in ${PACKAGES[@]}; do
  handle_aur_pkg ${USERNAME} ${AURBUILDDIR} ${PACKAGE}
done

add_dotfiles ".config/sfwbar" ".config/wlr-which-key"
