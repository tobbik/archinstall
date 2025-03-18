source config.sh

pacman -S ${PACMANFLAGS} \
  ardour audacity freeverb3

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S ${PACMANFLAGS} \
    dragonfly-reverb-lv2
fi
