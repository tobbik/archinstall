source config.sh

EXTRAPACKAGES=""

if [ $(uname -m) = 'x86_64' ]; then
  EXTRAPACKAGES="dragonfly-reverb-lv2"
fi

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  ardour audacity freeverb3 \
  ${EXTRAPACKAGES}

