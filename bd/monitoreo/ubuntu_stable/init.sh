#!/bin/bash

echo "Configurando Ubuntu Stable (22.04) para monitoreo..."

# Actualizar e instalar herramientas (cron incluido)
apt-get update && apt-get install -y openssh-server procps iproute2 cron

# Configurar SSH
mkdir -p /var/run/sshd
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

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
    truncate -s 15M /home/"$USER_NAME"/backups/Rsp_ventas_${FECHA}_${CONTAINER_IP}.sql
    truncate -s 25M /var/backups/db/Rsp_nominas_${FECHA}_${CONTAINER_IP}.dmp.gz
    truncate -s 10M /tmp/respaldos/Rsp_web_${FECHA}_${CONTAINER_IP}.sql.gz
    
    chown -R "$USER_NAME":"$USER_NAME" /home/"$USER_NAME"/backups
    chmod 777 /var/backups/db /tmp/respaldos
    
    # Agregar tareas Cron
    (crontab -l 2>/dev/null; echo "*/5 * * * * echo 'Salud del sistema OK' >> /tmp/health.log") | crontab -
    (crontab -l 2>/dev/null; echo "0 * * * * df -h > /home/$USER_NAME/disk_usage.log") | crontab -
    (crontab -l 2>/dev/null; echo "30 2 * * * find /tmp -type f -mtime +7 -delete") | crontab -
    
    service cron start
    echo "Usuario, archivos formateados y cron configurados."
fi

echo "Iniciando SSH..."
exec /usr/sbin/sshd -D
