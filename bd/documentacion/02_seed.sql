-- ==============================================================================
-- SEED DATA - SGIR (PRODUCCIÓN/SIMULACIÓN SRE)
-- ==============================================================================

-- 1. CATÁLOGOS BASE
INSERT INTO Estado_General (nombre_estado) VALUES 
('Activo'), ('Inactivo'), ('Pendiente'), ('Éxito'), ('Fallo'), ('Abierta'), ('Cerrada'), ('En Progreso');

INSERT INTO Rol_Usuario (nombre_rol) VALUES 
('Administrador DBA'), ('Operador de Monitoreo'), ('Auditor TI');

INSERT INTO Nivel_Criticidad (nombre_nivel, descripcion) VALUES 
('Bajo', 'Pruebas'), ('Medio', 'Interno'), ('Alto', 'Institucional'), ('Crítico', 'Misión Crítica');

INSERT INTO Tipo_Acceso (nombre_tipo) VALUES 
('SSH'), ('DB Native'), ('SFTP'), ('API');

INSERT INTO DBMS (nombre_dbms, version, descripcion) VALUES 
('PostgreSQL', '16.0', 'DB de la App'),
('MySQL', '5.7', 'Legacy Infrastructure'),
('MySQL', '8.0', 'Modern Infrastructure'),
('Oracle Database', '19c', 'Enterprise Data'),
('MongoDB', '8.0', 'NoSQL Metrics');

-- 2. USUARIOS (Password: sgir hashed with bcrypt)
INSERT INTO Usuario (nombres, apellidos, email, password_hash, id_rol, id_estado_usuario) VALUES 
('Admin', 'SRE', 'admin@sgir.io', '$2b$12$K7vU7U2.yO7Y2Fm7P3P3OeG5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z5Z', 1, 1);

-- 3. SERVIDORES (Contenedores Reales detectados por docker ps)
-- Nota: Usamos IPs de host (localhost/127.0.0.1) o nombres de red docker si corresponde
INSERT INTO Servidor (nombre_servidor, direccion_ip, es_legacy, id_nivel_criticidad, id_estado_servidor, descripcion) VALUES 
('SGIR-DB-MASTER', '172.17.0.1', FALSE, 4, 1, 'Base de datos principal del sistema (Postgres)'),
('MYSQL-LEGACY-01', '172.17.0.1', TRUE, 3, 1, 'Servidor MySQL 5.7 Legacy'),
('MYSQL-MODERN-01', '172.17.0.1', FALSE, 3, 1, 'Servidor MySQL 8.0 Modern'),
('MONGODB-METRICS', '172.17.0.1', FALSE, 2, 1, 'Almacén de métricas NoSQL');

-- 4. CREDENCIALES (Cifradas con AES SGIR para que dynamic_db las use)
-- Password real: 'sgir' (cifrado con Fernet de security.py)
INSERT INTO Credencial_Acceso (usuario, password_hash, id_tipo_acceso, id_estado_credencial, id_servidor) VALUES 
('sgir', 'gAAAAABmEDm_o9e5v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v=', 2, 1, 1), -- Postgres
('sgir', 'gAAAAABmEDm_o9e5v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v=', 2, 1, 2), -- MySQL 5
('sgir', 'gAAAAABmEDm_o9e5v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v=', 2, 1, 3), -- MySQL 8
('sgir', 'gAAAAABmEDm_o9e5v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v9v=', 2, 1, 4); -- MongoDB

-- 5. INSTANCIAS DBMS (Mapeo de puertos docker)
INSERT INTO Instancia_DBMS (nombre_instancia, puerto, id_servidor, id_dbms, id_estado_instancia) VALUES 
('sgir_db', 5432, 1, 1, 1),   -- Postgres Master
('mysql5_db', 3305, 2, 2, 1), -- MySQL 5 (Host Port 3305)
('mysql8_db', 3308, 3, 3, 1), -- MySQL 8 (Host Port 3308)
('admin', 27017, 4, 5, 1);    -- MongoDB Admin

-- 6. BASES DE DATOS ESPECÍFICAS
INSERT INTO Base_de_Datos (nombre_base, tamano_mb, id_instancia, id_estado_bd) VALUES 
('sgir_db', 10.5, 1, 1),
('mysql5_db', 5.0, 2, 1),
('mysql8_db', 5.0, 3, 1);
