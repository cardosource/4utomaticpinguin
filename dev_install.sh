#!/bin/bash
# - Script para instalar Node.js
# 1 - baixar da página oficial
# 2 - descompactar
# 3 - configurar


if [ -n "$SUDO_USER" ]; then
  usuario=$SUDO_USER
else
  usuario=$USER
fi


declare -a nodeJs
declare -a downloads
downloads[0]="https://nodejs.org/dist/v18.13.0/node-v18.13.0-linux-x64.tar.xz" # Stable Releases


# baixar arquivos.
for ((i = 0; i < ${#downloads[@]}; i++)); do
  echo "[ $i ] - Baixando: ${downloads[i]}"
  wget ${downloads[i]} --directory-prefix=/tmp/temp > /dev/null 2>&1
done

# descompactar e remover
if test -e /tmp/temp/*.tar.xz; then
  tar -xJvf /tmp/temp/*.tar.xz -C /tmp/temp > /dev/null 2>&1
  rm /tmp/temp/*.tar.xz
fi

sleep 5
# movendo arquivo
for dir in /tmp/temp/*; do
  export package=${dir:10}
  echo "Pacote $package baixado"
  mv -v "$dir"/ /usr/local/bin/ > /dev/null 2>&1
done

rm -rf /tmp/temp/

sleep 10
for lCal in /usr/local/bin/*; do
  pasta=${lCal:15:30}
  pasta=${pasta%%*( )}
  if [ "$pasta" = "$package" ]; then
   sleep 5
     echo "#NodeJs setup dev" >> /home/$usuario/.bashrc
     echo "export NODEJS_HOME=/usr/local/bin/$package" >> /home/$usuario/.bashrc
     echo "export PATH=$PATH:$NODEJS_HOME/bin" >> /home/$usuario/.bashrc


    sleep 5
  fi
done


source /home/$usuario/.bashrc

echo "$package Instalado com sucesso"
