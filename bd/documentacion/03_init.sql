-- ==============================================================================
-- SGIR - INICIALIZACIÓN DE INFRAESTRUCTURA (03_init.sql)
-- Registro de servidores, instancias y credenciales desde docker-compose.yml
-- ==============================================================================

-- 1. REGISTRO DE SERVIDORES
-- Se asume: id_estado=1 (Activo), Criticidad: 4 (Crítico), 3 (Alto), 2 (Medio), 1 (Bajo)
INSERT INTO Servidor (nombre_servidor, direccion_ip, es_legacy, id_nivel_criticidad, id_estado_servidor) VALUES 
('Servidor PostgreSQL Core', 'sgir_postgres', FALSE, 4, 1),
('Servidor MySQL 5 Legacy', '172.20.0.5', TRUE, 3, 1),
('Servidor MySQL 8 Modern', '172.20.0.8', FALSE, 3, 1),
('Servidor Oracle Enterprise', '172.20.0.21', FALSE, 4, 1),
('Servidor MongoDB NoSQL', '172.20.0.27', FALSE, 2, 1),
('SSH Gateway Server', '172.20.0.22', FALSE, 2, 1),
('Nodo Ubuntu Stable', '172.20.0.30', FALSE, 2, 1),
('Nodo Fedora Latest', '172.20.0.31', FALSE, 2, 1),
('Nodo Ubuntu Legacy (Old)', '172.20.0.32', TRUE, 1, 1);

-- 2. REGISTRO DE INSTANCIAS DBMS
-- IDs de DBMS: 1:Postgres, 2:MySQL 5.7, 3:MySQL 8.0, 4:Oracle, 5:MongoDB
INSERT INTO Instancia_DBMS (nombre_instancia, puerto, id_servidor, id_dbms, id_estado_instancia) VALUES 
('PostgreSQL Instance', 5432, 1, 1, 1),
('MySQL 5.7 Instance', 3306, 2, 2, 1),
('MySQL 8.0 Instance', 3306, 3, 3, 1),
('Oracle 21c XE', 1521, 4, 4, 1),
('MongoDB Cluster 0', 27017, 5, 5, 1);

-- 3. REGISTRO DE CREDENCIALES DE ACCESO
-- IDs Tipo Acceso: 1:SSH, 2:DB Native
INSERT INTO Credencial_Acceso (usuario, password_hash, id_tipo_acceso, id_estado_credencial, id_servidor) VALUES 
-- Credenciales de Base de Datos
('sgir', 'sgir', 2, 1, 1),       -- Postgres
('sgir', 'sgir', 2, 1, 2),       -- MySQL 5
('sgir', 'sgir', 2, 1, 3),       -- MySQL 8
('SYS', '123Nokia$', 2, 1, 4),   -- Oracle (ORACLE_PWD)
('sgir', 'sgir', 2, 1, 5),       -- MongoDB

-- Credenciales SSH
('sgir_user', 'sgir_pass', 1, 1, 6), -- SSH Server
('sgir_user', 'sgir_pass', 1, 1, 7), -- Ubuntu Stable
('sgir_user', 'sgir_pass', 1, 1, 8), -- Fedora Latest
('sgir_user', 'sgir_pass', 1, 1, 9); -- Ubuntu Legacy

-- 4. BASES DE DATOS INICIALES
INSERT INTO Base_de_Datos (nombre_base, id_instancia, id_estado_bd) VALUES 
('sgir_db', 1, 1),    -- Postgres
('sgir_db_5', 2, 1),  -- MySQL 5
('sgir_db_8', 3, 1),  -- MySQL 8
('XE', 4, 1),         -- Oracle
('admin', 5, 1);      -- MongoDB
