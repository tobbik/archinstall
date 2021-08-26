source config.sh

pacman -S --needed --noconfirm \
   x2goserver x2goclient \
   xorg-xauth xorg-xhost

# setup the ssh deamon config
sed -i 's/^#\(RSAAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(AllowTcpForwarding\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(X11Forwarding\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(X11UseLocalhost\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(X11DisplayOffset\).*/\1 10/' /etc/ssh/sshd_config

echo -e "\nAcceptEnv LANG LC_*\n" >> /etc/ssh/sshd_config

x2godbadmin --createdb
