source config.sh

# everything else for XFCE4 and development support
pacman -S --needed --noconfirm \
  xfce4 xfce4-goodies \
  gvfs-smb gvfs-nfs

# set xfce4 as standard X desktop for non graphical login
cp /etc/X11/xinit/xinitrc                /home/${USERNAME}/.xinitrc
sed  -i "/twm/d;/xclock/d;/xterm/d"      /home/${USERNAME}/.xinitrc
echo -e "\nxset -b\nexec startxfce4" >>  /home/${USERNAME}/.xinitrc


