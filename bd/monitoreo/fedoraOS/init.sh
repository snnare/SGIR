#!/bin/bash

echo "Configurando entorno Fedora para monitoreo..."

# Instalar herramientas básicas y servidor SSH
# procps-ng provee 'top' y 'free'
# coreutils provee 'df'
# openssh-server provee el servicio SSH
dnf install -y \
    procps-ng \
    coreutils \
    openssh-server \
    openssh-clients \
    iproute \
    net-tools \
    passwd

# Generar las llaves de host para SSH si no existen
ssh-keygen -A

# Crear el usuario de monitoreo si se pasaron las variables de entorno
if [ ! -z "$USER_NAME" ]; then
    echo "Creando usuario $USER_NAME..."
    useradd -m -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$USER_PASSWORD" | chpasswd
    echo "Usuario $USER_NAME configurado."
fi

# Asegurar que el directorio para el socket de sshd exista
mkdir -p /run/sshd

echo "Iniciando servicio SSH..."
# Ejecutar sshd en segundo plano (no interactivo)
/usr/sbin/sshd

echo "Sistema listo para monitoreo (SSH puerto 22)."

# Mantener el contenedor ejecutándose
exec "$@"
