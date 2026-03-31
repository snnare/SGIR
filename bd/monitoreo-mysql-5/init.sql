-- Script de Inicialización para Monitoreo - MySQL 5.x
-- Base de datos de prueba para monitoreo
CREATE DATABASE IF NOT EXISTS sgir_test_db;

-- Crear el usuario de monitoreo con permisos mínimos necesarios
-- PROCESS: Permite ver conexiones activas y detectar hilos bloqueados (SHOW PROCESSLIST)
-- SELECT: Permite consultar el peso de las bases de datos desde information_schema
-- REPLICATION CLIENT: Recomendado para salud general del motor

GRANT SELECT, PROCESS, REPLICATION CLIENT ON *.* TO 'monitor_user'@'%' IDENTIFIED BY 'monitor_pass';

FLUSH PRIVILEGES;

-- Crear tabla dummy para generar peso en el monitoreo
USE sgir_test_db;
CREATE TABLE IF NOT EXISTS health_check_dummy (
    id INT AUTO_INCREMENT PRIMARY KEY,
    data VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO health_check_dummy (data) VALUES ('Initial data for monitoring health check tests');
