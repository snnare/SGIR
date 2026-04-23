#!/bin/bash

echo "Configurando Ubuntu Legacy (14.04 Trusty) para monitoreo..."

# REPARAR REPOS (Vital para distros legacy)
cat <<EOF > /etc/apt/sources.list
deb http://old-releases.ubuntu.com/ubuntu trusty main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu trusty-security main restricted universe multiverse
EOF

# Actualizar e instalar herramientas
apt-get update && apt-get install -y openssh-server procps

# Configurar SSH
mkdir -p /var/run/sshd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Crear usuario y password
if [ ! -z "$USER_NAME" ]; then
    echo "Creando usuario $USER_NAME..."
    useradd -m -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$USER_PASSWORD" | chpasswd
    
    # Simular archivos .sql y .dmp.gz
    truncate -s 5M /home/"$USER_NAME"/archivo_legacy.sql
    truncate -s 10M /home/"$USER_NAME"/dump_antiguo.dmp.gz
    chown "$USER_NAME":"$USER_NAME" /home/"$USER_NAME"/*
fi

echo "Iniciando SSH..."
exec /usr/sbin/sshd -D
