source config.sh

EXTRAPACKAGES=""

# blender is currently missing a dependency on aarch64 :-(
if [ x$(uname -m) == x"x86_64" ]; then
  EXTRAPACKAGES="blender"
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  gimp graphviz \
  inkscape hugin enblend-enfuse geeqie \
  darktable \
  ${EXTRAPACKAGES}
  #gimp gimp-refocus gimp-dbp gimp-plugin-fblur gimp-plugin-lqr

