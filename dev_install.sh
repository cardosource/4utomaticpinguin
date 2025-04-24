#!/bin/bash
# - Script para instalar Node.js no Docker
# 1 - baixar da página oficial
# 2 - descompactar
# 3 - configurar


if [ -f /.dockerenv ]; then
       echo "[ !!! ] workstation docker"

    env_file="/etc/profile"
    usuario="root"
else
    if [ -n "$SUDO_USER" ]; then
        usuario=$SUDO_USER

    else
       echo "[ !!! ] workstation  fisico"
        usuario=$USER
    fi
    env_file="/home/$usuario/.bashrc"
fi

declare -a nodeJs
declare -a downloads
downloads[0]="https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz" # Stable Releases

# baixar arquivos.
for ((i = 0; i < ${#downloads[@]}; i++)); do
  echo "[ $i ] - Baixando: ${downloads[i]}"
  wget ${downloads[i]} --directory-prefix=/tmp/temp > /dev/null 2>&1
done

# Verificar se há arquivos .tar.xz e descompactar
if ls /tmp/temp/*.tar.xz > /dev/null 2>&1; then
  for arquivo in /tmp/temp/*.tar.xz; do
    tar -xJvf "$arquivo" -C /tmp/temp > /dev/null 2>&1
    rm "$arquivo"
  done
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
    echo "#NodeJs setup dev" >> "$env_file"
    echo "export NODEJS_HOME=/usr/local/bin/$package" >> "$env_file"
    echo 'export PATH=$PATH:$NODEJS_HOME/bin' >> "$env_file"
   sleep 5
  fi
done

source "$env_file"

echo "$package Instalado com sucesso"
