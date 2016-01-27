pacman -S --needed --noconfirm x2goserver x2goclient

sed -i 's/^#\(RSAAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sed -i 's/^#\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config

x2godbadmin --createdb
