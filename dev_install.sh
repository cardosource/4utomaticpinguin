#/bin/bash
# - Script para instalar NodeJs
# 1 - baixar da página oficial
# 2 - descompacta
# 3 - configura



declare -a downloads 
downloads[0]="https://nodejs.org/dist/v18.13.0/node-v18.13.0-linux-x64.tar.xz" #Stable Releases


#baixar arquivos.
for ((i=0;i < ${#downloads[@]}; i++));
 do
   echo "[ $i ] - Baixando : ${downloads[i]}" 
   wget  ${downloads[i]} --directory-prefix=/tmp/temp  > /dev/null 2>&1
done


#descompactar remover
if test -e /tmp/temp/*.tar.xz ;
    then
    tar -xJvf /tmp/temp/*.tar.xz --directory /tmp/temp
    rm  /tmp/temp/*.tar.xz # deletado compactado
fi



#movendo arquivo
for dir in /tmp/temp/*; 
  do
   packages=${dir:10:13}
   echo "Pacote Baixado : $packages"
   mv -v /tmp/temp/$packages*  /usr/local/bin/
 done 

#configurando
 for lCal in /usr/local/bin/*;
   do
    pasta=${lCal:15:13}
    echo "#$pasta" >> ~/.bashrc
    echo "exportc NODEJS_HOME=/usr/local/bin/$pasta/bin" >> ~/.bashrc
    echo "export PATH=$NODEJS_HOME:$PATH" >> ~/.bashrc
    source ~/.bashrc
done


