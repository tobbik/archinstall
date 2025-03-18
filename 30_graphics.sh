source config.sh

pacman -S ${PACMANFLAGS} \
  gimp graphviz \
  inkscape hugin enblend-enfuse geeqie \
  darktable
  #gimp gimp-refocus gimp-dbp gimp-plugin-fblur gimp-plugin-lqr

# blender is currently missing a dependency on aarch64 :-(
if [ x$(uname -m) == x"x86_64" ]; then
  pacman -S ${PACMANFLAGS} \
    blender
fi

