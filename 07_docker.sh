mkdir -p /home/${USERNAME}/docker
chown -R ${USERNAME}:users /home/${USERNAME}/docker

touch /etc/systemd/system/docker.d/my_config.conf
cat > /etc/systemd/system/docker.d/my_config.conf << EODOCKERCONF
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// \
         --exec-opt native.cgroupdriver=cgroupfs \
         --graph /home/arch/docker \
         --storage-driver overlay
EODOCKERCONF

systemctl daemon-reload
systemctl enable docker

