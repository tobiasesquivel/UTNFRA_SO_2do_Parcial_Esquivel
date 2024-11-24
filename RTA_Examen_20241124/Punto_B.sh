#!/bin/bash

USUARIO=$1

LISTA_USUARIOS=$2

if [ $# -ne 2 ]; then
    echo "Uso: $0 <usuario> <path_repositorio>/202406/bash_script/Lista_Usuarios.txt"
    exit 1
fi

if [ ! -f "$LISTA_USUARIOS" ]; then
    echo "El archivo de lista de usuarios no existe: $LISTA_USUARIOS"
    exit 1
fi

CLAVE=$(grep "^$USUARIO:" /etc/shadow | cut -d: -f2)


if [ -z "$CLAVE" ]; then
    echo "El usuario '$USUARIO' no existe o no tiene clave asignada"
    exit 1
fi

while IFS=, read -r usuario grupo home; do
   
    if [ -z "$usuario" ] || [ -z "$grupo" ] || [ -z "$home" ]; then
        echo "Línea incorrecta en el archivo de lista: $usuario,$grupo,$home"
        continue
    fi

  
    if ! grep -q "^$grupo:" /etc/group; then
        echo "Creando grupo $grupo..."
        sudo groupadd $grupo
    fi

   
    if ! id -u $usuario &>/dev/null; then
        echo "Creando usuario $usuario con clave del usuario $USUARIO..."
        sudo useradd -m -g $grupo -d "$home" $usuario


        echo "$usuario:$CLAVE" | sudo chpasswd
    else
        echo "El usuario $usuario ya existe."
    fi
done < "$LISTA_USUARIOS"

echo "Proceso completado."

