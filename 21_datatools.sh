source config.sh

#pacman -S --needed --noconfirm --asdeps \
#  jre8-openjdk-headless
pacman -S --needed --noconfirm \
  postgresql sqlite redis minio-client
#  mongodb elasticsearch rabbitmq redis

usermod -a -G postgres ${USERNAME}
#usermod -a -G rabbitmq ${USERNAME}
#usermod -a -G elasticsearch ${USERNAME}
