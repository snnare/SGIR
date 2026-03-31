-- Script de Inicialización para Monitoreo - MySQL 8.x
-- Base de datos de prueba para monitoreo
CREATE DATABASE IF NOT EXISTS sgir_test_db_8;

-- En MySQL 8 se debe crear el usuario primero y luego asignar permisos
CREATE USER IF NOT EXISTS 'monitor_user'@'%' IDENTIFIED BY 'monitor_pass';

-- Permisos necesarios:
-- PROCESS: Ver procesos de todos los usuarios (detectar bloqueos)
-- SELECT: Consultar information_schema para tamaños y métricas globales
-- REPLICATION CLIENT: Salud de replicación
GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'monitor_user'@'%';

FLUSH PRIVILEGES;

-- Crear tabla dummy para generar peso en el monitoreo
USE sgir_test_db_8;
CREATE TABLE IF NOT EXISTS health_check_dummy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO health_check_dummy (data) VALUES ('Initial data for MySQL 8 monitoring tests');
