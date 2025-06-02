source config.sh

# Most developing is being done in containers, but install these
# to have the clients installed on the host
pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
  postgresql sqlite valkey minio-client
#  mongodb elasticsearch rabbitmq

usermod -a -G postgres ${USERNAME}
#usermod -a -G rabbitmq ${USERNAME}
#usermod -a -G elasticsearch ${USERNAME}
