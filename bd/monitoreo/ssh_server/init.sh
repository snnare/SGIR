#!/bin/bash

echo "Configurando entorno de monitoreo en OpenSSH Server..."

# Detectar gestor de paquetes (Alpine en linuxserver images)
if command -v apk >/dev/null 2>&1; then
    echo "Usando apk (Alpine Linux base)..."

    apk update

    apk add --no-cache \
        procps \
        coreutils \
        iproute2 \
        net-tools \
        bash \
        curl \
        htop \
        util-linux
else
    echo "No se detectó apk. Entorno no estándar."
fi

# Crear usuario adicional si se define (opcional)
if [ ! -z "$USER_NAME" ]; then
    echo "Usuario ya gestionado por linuxserver image: $USER_NAME"
    echo "No es necesario crear usuarios manualmente aquí."
fi

# Mostrar herramientas disponibles
echo "Herramientas instaladas:"
echo "- top"
echo "- free"
echo "- df"
echo "- ip"
echo "- netstat (si está disponible)"

echo "Entorno listo para monitoreo vía SSH."