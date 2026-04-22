-- En MySQL 8 es obligatorio crear el usuario primero y luego dar permisos
CREATE USER 'sgir_monitoreo'@'%' IDENTIFIED WITH caching_sha2_password BY '123Nokia$';

-- Permisos básicos de lectura de metadatos y estado del servidor
GRANT SELECT, PROCESS ON *.* TO 'sgir_monitoreo'@'%';

-- Permiso para ver el diccionario de datos (reemplaza gran parte de info_schema en v8)
GRANT SHOW DATABASES ON *.* TO 'sgir_monitoreo'@'%';

-- Permiso específico para Performance Schema y Sys Schema (vital en MySQL 8)
GRANT SELECT ON performance_schema.* TO 'sgir_monitoreo'@'%';
GRANT SELECT ON sys.* TO 'sgir_monitoreo'@'%';

-- MySQL 8 introduce "Roles", pero para un script de monitoreo simple 
-- esto es suficiente.
FLUSH PRIVILEGES;
