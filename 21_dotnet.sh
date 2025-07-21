source config.sh

if [ x"$(uname -m)" == x"x86_64" ]; then
  pacman -S --needed --noconfirm ${PACMANEXTRAFLAGS} \
    dotnet-host dotnet-runtime dotnet-sdk dotnet-targeting-pack \
    aspnet-runtime aspnet-targeting-pack
else
  echo "dotnet packages exist only for the x86-_64 architecture. Nothing to install ..."
fi

