pacman -S --needed --noconfirm \
   docker arch-install-scripts lxc haveged \
   bridge-utils lua-alt-getopt ca-certificates

mkdir -p /home/${USERNAME}/docker
chown -R ${USERNAME}:users /home/${USERNAME}/docker

usermod -a -G docker ${USERNAME}

mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/my_config.conf << EODOCKERCONF
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// \
         --exec-opt native.cgroupdriver=cgroupfs \
         --graph /home/arch/docker \
         --storage-driver overlay
EODOCKERCONF

#systemctl daemon-reload
systemctl enable docker.service

update-ca-trust
