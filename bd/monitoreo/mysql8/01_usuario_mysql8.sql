-- En MySQL 8 es obligatorio crear el usuario primero y luego dar permisos
CREATE USER 'db_monitor'@'%' IDENTIFIED WITH caching_sha2_password BY '1212';

-- Permisos básicos de lectura de metadatos y estado del servidor
GRANT SELECT, PROCESS ON *.* TO 'db_monitor'@'%';

-- Permiso para ver el diccionario de datos (reemplaza gran parte de info_schema en v8)
GRANT SHOW DATABASES ON *.* TO 'db_monitor'@'%';

-- Permiso específico para Performance Schema y Sys Schema (vital en MySQL 8)
GRANT SELECT ON performance_schema.* TO 'db_monitor'@'%';
GRANT SELECT ON sys.* TO 'db_monitor'@'%';

-- MySQL 8 introduce "Roles", pero para un script de monitoreo simple 
-- esto es suficiente.
FLUSH PRIVILEGES;
