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

-- TABLAS COMPLETADAS SEGÚN REQUERIMIENTO
INSERT INTO Tipo_Respaldo (nombre_tipo) VALUES 
('Completo'), ('Incremental'), ('Diferencial');

INSERT INTO Tipo_Almacenamiento (nombre_tipo) VALUES 
('Disco Local'), ('S3 Cloud'), ('NFS/NAS'), ('SAN/Fibre Channel');

INSERT INTO Nivel_Alerta (nombre_nivel) VALUES 
('Informativo'), ('Advertencia'), ('Crítico'), ('Fatal');

INSERT INTO Tipo_Metrica (nombre_tipo, unidad_medida) VALUES 
('Uso de CPU', '%'), ('Uso de Memoria', '%'), ('Espacio en Disco', 'GB'), ('Latencia de Red', 'ms'), ('IOPS', 'ops/s');

INSERT INTO Tipo_Evento_Auditoria (nombre_evento) VALUES 
('Inicio de Sesión'), ('Cierre de Sesión'), ('Falla de Autenticación'), ('Creación de Usuario'), ('Modificación de Configuración'), ('Ejecución de Respaldo'), ('Restauración de Datos');
