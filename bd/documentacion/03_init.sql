-- ==============================================================================
-- SGIR - INICIALIZACIÓN DE INFRAESTRUCTURA (03_init.sql)
-- Registro de servidores usando nombres de servicio Docker
-- ==============================================================================

-- 1. REGISTRO DE SERVIDORES
INSERT INTO Servidor (nombre_servidor, direccion_ip, es_legacy, id_nivel_criticidad, id_estado_servidor) VALUES 
('Servidor PostgreSQL Core', 'db', FALSE, 4, 1),
('Servidor MySQL 5 Legacy', 'mysql5', TRUE, 3, 1),
('Servidor MySQL 8 Modern', 'mysql8', FALSE, 3, 1),
('Servidor Oracle Enterprise', 'oracle21c', FALSE, 4, 1),
('Servidor MongoDB NoSQL', 'mongodb', FALSE, 2, 1),
('SSH Gateway Server', 'ssh_server', FALSE, 2, 1),
('Nodo Ubuntu Stable', 'ubuntu_stable', FALSE, 2, 1),
('Nodo Fedora Latest', 'fedora_latest', FALSE, 2, 1),
('Nodo Ubuntu Legacy (Old)', 'ubuntu_legacy', TRUE, 1, 1);

-- 2. REGISTRO DE INSTANCIAS DBMS
-- IDs de DBMS: 1:Postgres, 2:MySQL 5.7, 3:MySQL 8.0, 4:Oracle, 5:MongoDB
INSERT INTO Instancia_DBMS (nombre_instancia, puerto, id_servidor, id_dbms, id_estado_instancia, parametros_conexion) VALUES 
('PostgreSQL Instance', 5432, 1, 1, 1, '{"database": "sgir_db", "user": "sgir"}'::jsonb),
('MySQL 5.7 Instance', 3306, 2, 2, 1, '{"database": "sgir_db_5", "user": "sgir"}'::jsonb),
('MySQL 8.0 Instance', 3306, 3, 3, 1, '{"database": "sgir_db_8", "user": "sgir"}'::jsonb),
('Oracle 21c XE', 1521, 4, 4, 1, '{"service_name": "XEPDB1", "user": "system"}'::jsonb),
('MongoDB Cluster 0', 27017, 5, 5, 1, '{"database": "admin", "user": "sgir"}'::jsonb);

-- 4. BASES DE DATOS INICIALES
INSERT INTO Base_de_Datos (nombre_base, id_instancia, id_estado_bd) VALUES 
('sgir_db', 1, 1),    -- Postgres
('sgir_db_5', 2, 1),  -- MySQL 5
('sgir_db_8', 3, 1),  -- MySQL 8
('XE', 4, 1),         -- Oracle
('admin', 5, 1);      -- MongoDB
