pacman -S --needed --noconfirm \
  clang clang-analyzer make tig gdb valgrind pkg-config linux-headers \
  nginx fcgiwrap git postgresql sqlite wireshark-cli mongodb \
  lua lua-socket lua-filesystem luajit ipython python3 figlet nodejs npm \
  gvim geany geany-plugins scite

usermod -a -G git ${USERNAME}
usermod -a -G postgres ${USERNAME}
usermod -a -G http ${USERNAME}
usermod -a -G wireshark ${USERNAME}
