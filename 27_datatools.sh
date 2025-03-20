source config.sh

pacman -S --needed -noconfirm ${PACMANEXTRAFLAGS} \
  postgresql sqlite redis minio-client
#  mongodb elasticsearch rabbitmq

usermod -a -G postgres ${USERNAME}
#usermod -a -G rabbitmq ${USERNAME}
#usermod -a -G elasticsearch ${USERNAME}
