pacman -S --needed --noconfirm \
   docker arch-install-scripts lxc haveged \
   bridge-utils lua-alt-getopt ca-certificates \
   docker-compose

usermod -a -G docker ${USERNAME}

if [ -z ${DOCKERSTORAGEPATH+x} ]; then
  DOCKERSTORAGEPATH=/home/${USERNAME}/docker
  mkdir -p ${DOCKERSTORAGEPATH}
  chown -R ${USERNAME}:users ${DOCKERSTORAGEPATH}
else
  
fi

mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/my_config.conf << EODOCKERCONF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd \\
         -H fd:// \\
         --exec-opt native.cgroupdriver=cgroupfs \\
         --storage-driver overlay2 \\
         --graph ${DOCKERSTORAGEPATH}
EODOCKERCONF

#systemctl daemon-reload
systemctl enable docker.service

update-ca-trust
