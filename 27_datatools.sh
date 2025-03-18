source config.sh

pacman -S ${PACMANFLAGS} \
  postgresql sqlite redis minio-client
#  mongodb elasticsearch rabbitmq

usermod -a -G postgres ${USERNAME}
#usermod -a -G rabbitmq ${USERNAME}
#usermod -a -G elasticsearch ${USERNAME}
