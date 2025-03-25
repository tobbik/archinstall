source config.sh

pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  ardour audacity freeverb3

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    dragonfly-reverb-lv2
fi
