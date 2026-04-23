#!/bin/bash

echo "Configurando Fedora Latest para monitoreo..."

# Instalar herramientas (cronie para Fedora)
dnf install -y openssh-server procps-ng iproute cronie

# Generar llaves de host si no existen
ssh-keygen -A
mkdir -p /run/sshd

# Habilitar login por contraseña
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Crear usuario y password
if [ ! -z "$USER_NAME" ]; then
    echo "Creando usuario $USER_NAME..."
    useradd -m -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$USER_PASSWORD" | chpasswd
    
    # Obtener IP local para el nombre de los archivos
    CONTAINER_IP=$(hostname -I | awk '{print $1}')
    FECHA=$(date +%Y%m%d)

    # Crear rutas de respaldo
    mkdir -p /home/"$USER_NAME"/backups /var/backups/db /tmp/respaldos
    
    # Simular archivos con el nuevo formato
    truncate -s 12M /home/"$USER_NAME"/backups/Rsp_crm_${FECHA}_${CONTAINER_IP}.sql
    truncate -s 30M /var/backups/db/Rsp_erp_${FECHA}_${CONTAINER_IP}.dmp.gz
    truncate -s 18M /tmp/respaldos/Rsp_logs_${FECHA}_${CONTAINER_IP}.sql.gz
    
    chown -R "$USER_NAME":"$USER_NAME" /home/"$USER_NAME"/backups
    chmod 777 /var/backups/db /tmp/respaldos

    # Agregar tareas Cron (Fedora usa /etc/crontab o crontab -e)
    echo "*/10 * * * * root echo 'Check' >> /var/log/health_check.log" >> /etc/crontab
    crond
    
    echo "Usuario, archivos formateados y cron configurados."
fi

echo "Iniciando SSH..."
exec /usr/sbin/sshd -D
