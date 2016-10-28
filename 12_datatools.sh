pacman -S --needed --noconfirm --asdeps \
	jre8-openjdk-headless
pacman -S --needed --noconfirm \
  postgresql sqlite mongodb elasticsearch

usermod -a -G postgres ${USERNAME}
usermod -a -G rabbitmq ${USERNAME}
usermod -a -G elasticsearch ${USERNAME}
