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

declare -a downloads
downloads[0]="https://nodejs.org/dist/v22.14.0/node-v22.14.0-linux-x64.tar.xz" # Stable Releases
mkdir -p /tmp/temp

for ((i = 0; i < ${#downloads[@]}; i++)); do
  echo "[ $i ] - Baixando: ${downloads[i]}"
  wget ${downloads[i]} --directory-prefix=/tmp/temp > /dev/null 2>&1
done

if ls /tmp/temp/*.tar.xz > /dev/null 2>&1; then
  for arquivo in /tmp/temp/*.tar.xz; do
    echo "Descompactando $arquivo..."
    tar -xJvf "$arquivo" -C /tmp/temp > /dev/null 2>&1
    rm "$arquivo"
  done
fi

sleep 5

for dir in /tmp/temp/*; do
  package=$(basename "$dir")
  echo "Pacote $package baixado"
  mv -v "$dir" /usr/local/bin/ > /dev/null 2>&1
done

rm -rf /tmp/temp/

sleep 10
echo "Configurando variáveis de ambiente..."
if [ -d "/usr/local/bin/$package" ]; then
  if ! grep -q "#NodeJs setup dev" /home/$usuario/.bashrc; then
    echo "#NodeJs setup dev" >> /home/$usuario/.bashrc
    echo "export NODEJS_HOME=/usr/local/bin/$package" >> /home/$usuario/.bashrc
    echo 'export PATH=$PATH:$NODEJS_HOME/bin' >> /home/$usuario/.bashrc
    echo "Variáveis de ambiente configuradas para $package."
  else
    echo "As variáveis de ambiente já estão configuradas no .bashrc."
  fi
else
  echo "Erro: Diretório do pacote não encontrado em /usr/local/bin/."
  exit 1
fi

source /home/$usuario/.bashrc

echo "$package instalado com sucesso!"
