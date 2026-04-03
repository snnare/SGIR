-- ==============================================================================
-- SEED DATA - SISTEMA DE GESTIÓN DE INFRAESTRUCTURA Y RESPALDOS (SGIR)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. POBLANDO CATÁLOGOS (Valores base de negocio)
-- ------------------------------------------------------------------------------

INSERT INTO Estado_General (nombre_estado) VALUES 
('Activo'), ('Inactivo'), ('Pendiente'), ('Éxito'), ('Fallo'), ('Abierta'), ('Cerrada'), ('En Progreso');
-- IDs: 1:Activo, 2:Inactivo, 3:Pendiente, 4:Éxito, 5:Fallo, 6:Abierta, 7:Cerrada, 8:En Progreso

INSERT INTO Rol_Usuario (nombre_rol) VALUES 
('Administrador DBA'), ('Operador de Monitoreo'), ('Auditor TI');
-- IDs: 1:Admin, 2:Operador, 3:Auditor

INSERT INTO Nivel_Criticidad (nombre_nivel, descripcion) VALUES 
('Bajo', 'Servicios de prueba o desarrollo sin impacto operativo.'),
('Medio', 'Sistemas internos de consulta no críticos.'),
('Alto', 'Sistemas institucionales de uso diario.'),
('Crítico', 'Sistemas core (Control Escolar, Nómina, Finanzas). Caída inaceptable.');

INSERT INTO Tipo_Acceso (nombre_tipo) VALUES 
('SSH (RSA Key)'), ('DB Native User'), ('SFTP'), ('API Token');

INSERT INTO DBMS (nombre_dbms, version, descripcion) VALUES 
('PostgreSQL', '16.2', 'Estándar actual open source de la DTIC'),
('PostgreSQL', '12.0', 'Versión antigua en proceso de migración'),
('Oracle Database', '11gR2', 'Legacy. Base de datos monolítica de Control Escolar'),
('Oracle Database', '19c', 'Nueva infraestructura Oracle'),
('MySQL', '8.0', 'Usado para sitios web satélites');

INSERT INTO Tipo_Respaldo (nombre_tipo) VALUES 
('Completo (Full)'), ('Incremental'), ('Diferencial');

INSERT INTO Tipo_Almacenamiento (nombre_tipo) VALUES 
('NAS Local (DTIC)'), ('SAN (Centro de Datos)'), ('AWS S3 (Glacier)'), ('Disco Local Servidor');

INSERT INTO Nivel_Alerta (nombre_nivel) VALUES 
('Informativa'), ('Advertencia (Warning)'), ('Crítica (Critical)');

INSERT INTO Tipo_Metrica (nombre_tipo, unidad_medida) VALUES 
('Uso de CPU', '%'), ('Memoria RAM Libre', 'GB'), ('Uso de Memoria RAM', '%'), 
('Espacio en Disco (Root)', '%'), ('Conexiones Activas DB', 'Count');

INSERT INTO Tipo_Evento_Auditoria (nombre_evento) VALUES 
('Creación de Recurso'), ('Modificación de Configuración'), ('Eliminación Lógica'), 
('Ejecución Manual de Tarea'), ('Alarma del Sistema');

-- ------------------------------------------------------------------------------
-- 2. POBLANDO TABLAS PRINCIPALES (Mínimo 10 registros simulando la DTIC)
-- ------------------------------------------------------------------------------

-- USUARIOS
INSERT INTO Usuario (nombres, apellidos, email, password_hash, id_rol, id_estado_usuario) VALUES 
('Angel', 'Romero Rios', 'aromero@uaemex.mx', '$2b$12$dummyhash_admin1', 1, 1),
('Carlos', 'Martinez', 'cmartinez@uaemex.mx', '$2b$12$dummyhash_admin2', 1, 1),
('Laura', 'Gomez', 'lgomez@uaemex.mx', '$2b$12$dummyhash_oper1', 2, 1),
('Pedro', 'Sanchez', 'psanchez@uaemex.mx', '$2b$12$dummyhash_oper2', 2, 1),
('Maria', 'Lopez', 'mlopez@uaemex.mx', '$2b$12$dummyhash_oper3', 2, 1),
('Jorge', 'Diaz', 'jdiaz@uaemex.mx', '$2b$12$dummyhash_oper4', 2, 2), -- Inactivo
('Ana', 'Ruiz', 'aruiz@uaemex.mx', '$2b$12$dummyhash_oper5', 2, 1),
('Luis', 'Torres', 'ltorres@uaemex.mx', '$2b$12$dummyhash_aud1', 3, 1),
('Elena', 'Flores', 'eflores@uaemex.mx', '$2b$12$dummyhash_aud2', 3, 1),
('Roberto', 'Mendez', 'rmendez@uaemex.mx', '$2b$12$dummyhash_aud3', 3, 1);

-- SERVIDORES
INSERT INTO Servidor (nombre_servidor, direccion_ip, es_legacy, id_nivel_criticidad, id_estado_servidor, descripcion) VALUES 
('srv-ce-db-01', '192.168.10.101', TRUE, 4, 1, 'Servidor Baremetal Oracle 11g Control Escolar'),
('srv-finanzas-db', '192.168.10.105', FALSE, 4, 1, 'Nodo principal BD Finanzas Institucional'),
('srv-rh-db-02', '192.168.10.106', FALSE, 3, 1, 'Servidor PostgreSQL Recursos Humanos'),
('srv-portal-alumnos', '192.168.20.15', FALSE, 3, 1, 'Servidor de lectura para portal de alumnos'),
('srv-legacy-nomina', '192.168.10.99', TRUE, 4, 1, 'Servidor antiguo de nómina, pendiente migrar'),
('srv-dev-01', '192.168.50.10', FALSE, 1, 1, 'Cluster de desarrollo equipo backend'),
('srv-qa-01', '192.168.50.20', FALSE, 2, 1, 'Entorno de pruebas y QA'),
('srv-biblio-db', '192.168.30.12', FALSE, 2, 1, 'Base de datos de red de bibliotecas'),
('srv-investigacion', '192.168.40.50', FALSE, 2, 2, 'Apagado temporalmente por mantenimiento'),
('srv-logs-central', '192.168.100.5', FALSE, 3, 1, 'Concentrador de logs institucionales');

-- CREDENCIALES
INSERT INTO Credencial_Acceso (usuario, password_hash, id_tipo_acceso, id_estado_credencial, id_servidor) VALUES 
('oracle_sys', '$2b$...oraclesys', 2, 1, 1),
('root', '$2b$...sshkey_root1', 1, 1, 1),
('postgres_admin', '$2b$...pgadmin', 2, 1, 2),
('root', '$2b$...sshkey_root2', 1, 1, 2),
('app_finanzas', '$2b$...appfin', 2, 1, 2),
('postgres_rh', '$2b$...pgrh', 2, 1, 3),
('root', '$2b$...sshkey_root3', 1, 1, 3),
('dev_user', '$2b$...dev1', 2, 1, 6),
('qa_tester', '$2b$...qa1', 2, 1, 7),
('root', '$2b$...sshkey_old', 1, 1, 5);

-- RUTAS DE RESPALDO
INSERT INTO Ruta_Respaldo (descripcion_ruta, path, id_tipo_almacenamiento, id_estado_ruta) VALUES 
('NAS Principal DTIC - Producción', '/mnt/nas_dtic/prod_backups/', 1, 1),
('NAS Secundario DTIC - Desarrollo', '/mnt/nas_dtic/dev_backups/', 1, 1),
('SAN Centro de Datos Core', '/vol/san_core/oracle_dumps/', 2, 1),
('Disco Local Tmp', '/var/backups/tmp_dumps/', 4, 1),
('AWS S3 Finanzas Anual', 's3://uaemex-backups-finanzas/anual/', 3, 1),
('AWS S3 Finanzas Mensual', 's3://uaemex-backups-finanzas/mensual/', 3, 1),
('AWS S3 Control Escolar', 's3://uaemex-backups-ce/diario/', 3, 1),
('SAN Centro de Datos Histórico', '/vol/san_historic/db_archive/', 2, 1),
('NAS Bibliotecas', '/mnt/nas_biblio/dumps/', 1, 1),
('AWS S3 Logs Archive', 's3://uaemex-logs-archive/', 3, 1);

-- POLÍTICAS DE RESPALDO
INSERT INTO Política_de_Respaldo (nombre_politica, descripcion, frecuencia_horas, retencion_dias, id_tipo_respaldo, id_estado_politica) VALUES 
('Diario Noche (Full)', 'Respaldo completo a las 2 AM', 24, 7, 1, 1),
('Incremental Medio Día', 'Respaldo incremental cada 4 horas', 4, 2, 2, 1),
('Semanal Fin de Semana', 'Respaldo completo profundo domingos', 168, 30, 1, 1),
('Mensual Histórico', 'Respaldo mensual de cierre', 720, 365, 1, 1),
('Diario Diferencial', 'Diferencial diario a las 8 PM', 24, 14, 3, 1),
('Anual Auditoría', 'Respaldo retenido por 5 años', 8760, 1825, 1, 1),
('Cada Hora (Crítico)', 'Incremental para sistemas muy transaccionales', 1, 1, 2, 1),
('Mensual Desarrollo', 'Snapshot de BDs de desarrollo', 720, 15, 1, 1),
('Semanal Bibliotecas', 'Respaldo de catálogos domingos', 168, 60, 1, 1),
('Diario Legacy', 'Respaldo físico export de Oracle', 24, 5, 1, 1);

-- INSTANCIAS DBMS
INSERT INTO Instancia_DBMS (nombre_instancia, puerto, id_servidor, id_dbms, id_estado_instancia) VALUES 
('ORCL_CE', 1521, 1, 3, 1),
('PG_FINANZAS_MAIN', 5432, 2, 1, 1),
('PG_RH_PROD', 5432, 3, 1, 1),
('PG_PORTAL_RO', 5433, 4, 1, 1),
('ORCL_NOMINA_OLD', 1521, 5, 3, 1),
('PG_DEV_CLUSTER', 5432, 6, 1, 1),
('MYSQL_QA', 3306, 7, 5, 1),
('PG_BIBLIO_MAIN', 5432, 8, 2, 1),
('MYSQL_INVEST_STOP', 3306, 9, 5, 2),
('PG_LOGS_DB', 5432, 10, 1, 1);

-- BASES DE DATOS
INSERT INTO Base_de_Datos (nombre_base, tamano_mb, id_instancia, id_estado_bd) VALUES 
('db_control_escolar', 154000.50, 1, 1),
('db_finanzas_prod', 85000.00, 2, 1),
('db_presupuestos', 22000.25, 2, 1),
('db_recursos_humanos', 64000.00, 3, 1),
('db_portal_replica', 154000.50, 4, 1),
('db_nomina_historico', 310000.00, 5, 1),
('db_finanzas_dev', 5000.00, 6, 1),
('db_sito_institucional_qa', 1500.00, 7, 1),
('db_catalogo_bibliotecas', 45000.00, 8, 1),
('db_logs_app', 120000.00, 10, 1);

-- ASIGNACIÓN DE POLÍTICAS (N:M)
INSERT INTO Asignacion_Politica_BD (id_base_datos, id_politica) VALUES 
(1, 1), (1, 7), (1, 4), -- Control Escolar: Diario, Cada Hora, Mensual
(2, 1), (2, 2),         -- Finanzas: Diario, Incremental 4h
(3, 1),                 -- Presupuestos: Diario
(4, 1), (4, 3),         -- RH: Diario, Semanal
(6, 10), (6, 4),        -- Nomina Legacy: Diario Legacy, Mensual
(7, 8),                 -- Dev Finanzas: Mensual Desarrollo
(8, 8),                 -- QA: Mensual Desarrollo
(9, 9),                 -- Bibliotecas: Semanal
(10, 3);                -- Logs: Semanal

-- RESPALDOS (Historial simulado)
INSERT INTO Respaldo (fecha_inicio, fecha_fin, tamano_mb, hash_integridad, id_base_datos, id_politica, id_credencial, id_ruta_respaldo, id_estado_ejecucion) VALUES 
(CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days' + INTERVAL '2 hours', 154000.50, 'a1b2c3d4...', 1, 1, 1, 3, 4), -- Éxito CE
(CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days' + INTERVAL '2.1 hours', 154100.00, 'e5f6g7h8...', 1, 1, 1, 3, 4), -- Éxito CE
(CURRENT_TIMESTAMP - INTERVAL '1 days', CURRENT_TIMESTAMP - INTERVAL '1 days' + INTERVAL '10 minutes', 0, NULL, 1, 1, 1, 3, 5), -- Fallo CE (Desconexión)
(CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP - INTERVAL '3 days' + INTERVAL '45 minutes', 85000.00, 'i9j0k1l2...', 2, 1, 3, 1, 4), -- Éxito Finanzas
(CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '2 days' + INTERVAL '47 minutes', 85200.00, 'm3n4o5p6...', 2, 1, 3, 1, 4), -- Éxito Finanzas
(CURRENT_TIMESTAMP - INTERVAL '1 days', CURRENT_TIMESTAMP - INTERVAL '1 days' + INTERVAL '50 minutes', 85350.00, 'q7r8s9t0...', 2, 1, 3, 1, 4), -- Éxito Finanzas
(CURRENT_TIMESTAMP - INTERVAL '7 days', CURRENT_TIMESTAMP - INTERVAL '7 days' + INTERVAL '5 hours', 310000.00, 'u1v2w3x4...', 6, 10, 10, 8, 4), -- Éxito Nomina Legacy
(CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '5 days' + INTERVAL '20 minutes', 5000.00, 'y5z6a7b8...', 7, 8, 8, 2, 4), -- Éxito Dev
(CURRENT_TIMESTAMP - INTERVAL '2 hours', NULL, NULL, NULL, 4, 1, 6, 1, 8), -- En Progreso RH
(CURRENT_TIMESTAMP - INTERVAL '1 hours', NULL, NULL, NULL, 9, 9, 3, 9, 3); -- Pendiente Bibliotecas

-- MONITOREOS
INSERT INTO Monitoreo (fecha_inicio, fecha_fin, id_servidor, id_credencial, id_estado_monitoreo) VALUES 
(CURRENT_TIMESTAMP - INTERVAL '24 hours', NULL, 1, 2, 1), -- Sesión activa SSH en CE
(CURRENT_TIMESTAMP - INTERVAL '24 hours', NULL, 2, 4, 1), -- Sesión activa SSH en Finanzas
(CURRENT_TIMESTAMP - INTERVAL '24 hours', NULL, 3, 7, 1), -- Sesión activa SSH en RH
(CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP - INTERVAL '4 days', 5, 10, 2), -- Sesión cerrada Legacy
(CURRENT_TIMESTAMP - INTERVAL '12 hours', NULL, 5, 10, 1), -- Nueva sesión activa Legacy
(CURRENT_TIMESTAMP - INTERVAL '10 days', NULL, 6, 8, 1), -- Activo Dev
(CURRENT_TIMESTAMP - INTERVAL '10 days', NULL, 7, 9, 1), -- Activo QA
(CURRENT_TIMESTAMP - INTERVAL '30 days', NULL, 10, 4, 1), -- Activo Logs
(CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP - INTERVAL '1 days', 4, 4, 2), -- Cerrada Portal
(CURRENT_TIMESTAMP - INTERVAL '5 hours', NULL, 4, 4, 1); -- Activa Portal

-- MÉTRICAS
INSERT INTO Métrica (valor, fecha_registro, id_monitoreo, id_tipo_metrica) VALUES 
(45.5, CURRENT_TIMESTAMP - INTERVAL '1 hour', 1, 1), -- CPU 45% CE
(92.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 1, 3), -- RAM 92% CE
(88.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 1, 4), -- Disco 88% CE
(35.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 2, 1), -- CPU 35% Finanzas
(60.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 2, 3), -- RAM 60% Finanzas
(98.5, CURRENT_TIMESTAMP - INTERVAL '2 hours', 5, 1), -- CPU 98.5% Legacy (Peligro)
(99.0, CURRENT_TIMESTAMP - INTERVAL '2 hours', 5, 3), -- RAM 99% Legacy (Peligro)
(10.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 6, 1), -- CPU 10% Dev
(15.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 7, 1), -- CPU 15% QA
(50.0, CURRENT_TIMESTAMP - INTERVAL '1 hour', 8, 4); -- Disco 50% Logs

-- ALERTAS
INSERT INTO Alerta (descripcion, id_servidor, id_monitoreo, id_nivel_alerta, id_estado_alerta) VALUES 
('Uso de RAM supera el 90% en servidor de Control Escolar', 1, 1, 2, 6), -- Abierta
('Fallo de conexión de red durante el respaldo de BD_Control_Escolar', 1, NULL, 3, 6), -- Abierta (Vino de backup, no de monitoreo)
('Uso de CPU al 98.5% detectado por más de 15 minutos', 5, 5, 3, 6), -- Abierta Crítica Legacy
('Reinicio inesperado del servicio SSH', 4, 9, 2, 7), -- Cerrada
('Espacio en root por encima del 85%', 1, 1, 2, 6), -- Abierta
('Picos de conexión a DB detectados', 2, 2, 1, 7), -- Cerrada Info
('Error de lectura en disco /dev/sdb', 5, 5, 3, 6), -- Abierta Crítica
('Servicio MySQL no responde a pings de salud', 7, 7, 2, 6), -- Abierta Warning QA
('Finalización de espacio de tabla de logs', 10, 8, 1, 6), -- Abierta Info
('Sincronización de reloj (NTP) fuera de desfase', 3, 3, 1, 7); -- Cerrada Info

-- BITÁCORA (Auditoría de eventos recientes)
INSERT INTO Bitacora (entidad_afectada, id_entidad, descripcion_evento, id_usuario, id_tipo_evento) VALUES 
('Servidor', 1, 'Registro inicial de servidor Control Escolar', 1, 1),
('Servidor', 2, 'Registro inicial de servidor Finanzas', 1, 1),
('Servidor', 5, 'Actualización de flag es_legacy a TRUE', 2, 2),
('Base_de_Datos', 10, 'Creación de base de datos de Logs Institucionales', 1, 1),
('Política_de_Respaldo', 7, 'Modificación de retención a 1 día para política cada hora', 1, 2),
('Respaldo', 3, 'Operador canceló el respaldo estancado manualmente', 3, 4),
('Usuario', 6, 'Desactivación de cuenta por baja de personal', 1, 2),
('Alerta', 3, 'Administrador reconoció la alerta de CPU del Legacy', 2, 2),
('Credencial_Acceso', 10, 'Rotación de llave SSH para root en servidor legacy', 1, 2),
('Asignacion_Politica_BD', 2, 'Se asignó política de Incremental 4h a BD Finanzas', 1, 1);
