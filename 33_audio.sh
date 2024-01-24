source config.sh

pacman -S --needed --noconfirm \
  ardour audacity

if [ $(uname -m) = 'x86_64' ]; then
  pacman -S dragonfly-reverb-lv2
fi
