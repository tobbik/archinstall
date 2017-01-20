OLDDIR=$(pwd)
mkdir -p /home/${USERNAME}/packages
cd /home/${USERNAME}/packages

# pycharm
pacman -S --needed --noconfirm jdk8-openjdk
wget https://aur.archlinux.org/cgit/aur.git/snapshot/pycharm-community.tar.gz -O - | tar xz
cd pycharm-community
makepkg
pacman -U --needed --noconfirm pycharm-community-*-any.pkg.tar.xz
rm -rf src pkg
cd /home/${USERNAME}/packages

#MS visual code
pacman -S --needed --noconfirm gconf
wget https://aur.archlinux.org/cgit/aur.git/snapshot/visual-studio-code.tar.gz -O - | tar xz
cd visual-studio-code
makepkg
pacman -U --needed --noconfirm visual-studio-code-*.pkg.tar.xz
rm -rf src pkg
cd /home/${USERNAME}/packages


cd ${OLDDIR}
