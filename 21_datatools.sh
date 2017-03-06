pacman -S --needed --noconfirm --asdeps \
  jre8-openjdk-headless
pacman -S --needed --noconfirm \
  postgresql sqlite mongodb elasticsearch rabbitmq redis

usermod -a -G postgres ${USERNAME}
usermod -a -G rabbitmq ${USERNAME}
usermod -a -G elasticsearch ${USERNAME}
usermod -a -G redis ${USERNAME}
