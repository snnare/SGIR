-- ==============================================================================
-- SEED DATA - SGIR (DOCKER CONTAINERS ENVIRONMENT)
-- Fecha: 2026-04-09
-- Descripción: Carga de servicios activos definidos en docker-compose.yml
-- ==============================================================================

-- 1. DBMS & SISTEMAS OPERATIVOS
-- Agregamos Linux como un "DBMS" para el monitoreo de recursos base (CPU/RAM/DISK)
INSERT INTO DBMS (nombre_dbms, version, descripcion) VALUES 
('PostgreSQL', '16-alpine', 'Base de datos principal del sistema'),
('MySQL', '5.7', 'Legacy Infrastructure Service'),
('MySQL', '8.0', 'Modern Infrastructure Service'),
('MongoDB', 'latest', 'NoSQL Metrics Store'),
('Linux OS', 'Fedora/Ubuntu', 'Servidores para monitoreo base y backups via SSH');

-- 2. SERVIDORES (Nodos detectados en el stack de Docker)
-- Se asume 172.17.0.1 como el gateway para acceder a los puertos mapeados del host
INSERT INTO Servidor (nombre_servidor, direccion_ip, es_legacy, id_nivel_criticidad, id_estado_servidor, descripcion) VALUES 
('sgir_postgres', '172.17.0.1', FALSE, 4, 1, 'Contenedor DB principal (Postgres 16)'),
('sgir_mysql5', '172.17.0.1', TRUE, 3, 1, 'Contenedor MySQL 5.7 (Legacy)'),
('sgir_mysql8', '172.17.0.1', FALSE, 3, 1, 'Contenedor MySQL 8.0 (Modern)'),
('sgir_mongodb', '172.17.0.1', FALSE, 2, 1, 'Contenedor MongoDB NoSQL'),
('sgir_ssh_server', '172.17.0.1', FALSE, 2, 1, 'Servidor SSH Genérico para pruebas de conectividad'),
('sgir_fedora', '172.17.0.1', FALSE, 1, 1, 'Nodo Fedora para pruebas de monitoreo base y scripts');

-- 3. CREDENCIALES (Texto Plano para desarrollo/seed)
-- Mapeo de usuarios y contraseñas definidos en el docker-compose
INSERT INTO Credencial_Acceso (usuario, password_hash, id_tipo_acceso, id_estado_credencial, id_servidor) VALUES 
('sgir', 'sgir', 2, 1, 1),      -- Postgres (DB Native)
('sgir', 'sgir', 2, 1, 2),      -- MySQL 5 (DB Native)
('sgir', 'sgir', 2, 1, 3),      -- MySQL 8 (DB Native)
('sgir', 'sgir', 2, 1, 4),      -- MongoDB (DB Native)
('sgir_user', 'sgir_pass', 1, 1, 5), -- SSH Server (SSH)
('sgir', 'sgir', 1, 1, 6);      -- Fedora Node (SSH)

-- 4. INSTANCIAS (Mapeo de puertos expuestos en el host)
INSERT INTO Instancia_DBMS (nombre_instancia, puerto, id_servidor, id_dbms, id_estado_instancia) VALUES 
('sgir_db', 5432, 1, 6, 1),    -- Postgres Master
('sgir_db_5', 3305, 2, 7, 1), -- MySQL 5.7
('sgir_db_8', 3308, 3, 8, 1), -- MySQL 8.0
('admin', 27017, 4, 9, 1),    -- MongoDB Admin
('ssh_generic', 2222, 5, 10, 1), -- Acceso SSH Port 2222
('fedora_base', 2223, 6, 10, 1); -- Acceso SSH Port 2223

-- 5. BASES DE DATOS (Entidades lógicas dentro de las instancias)
INSERT INTO Base_de_Datos (nombre_base, tamano_mb, id_instancia, id_estado_bd) VALUES 
('sgir_db', 0.0, 1, 1),     -- Inicializada por 01_modelo_fisico.sql
('sgir_db_5', 0.0, 2, 1),   -- Inicializada en MySQL 5
('sgir_db_8', 0.0, 3, 1),   -- Inicializada en MySQL 8
('admin', 0.0, 4, 1),       -- DB por defecto en Mongo
('config', 0.0, 4, 1),      -- DB interna Mongo
('local', 0.0, 4, 1);       -- DB interna Mongo

-- 6. BITÁCORA DE INICIO DE PROYECTO (Opcional para dar realismo)
-- Se registra que el sistema detectó los contenedores exitosamente
INSERT INTO Bitacora_Operacion (descripcion, fecha_ejecucion, id_estado_operacion, id_usuario, id_servidor) VALUES 
('Sincronización inicial con infraestructura Docker Compose finalizada', CURRENT_TIMESTAMP, 4, 1, 1);
