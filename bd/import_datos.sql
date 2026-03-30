-- Script de Carga Masiva
BEGIN;

-- 1. Insertar Motores de DB Únicos
INSERT INTO motores_db (nombre_motor, version) VALUES ('SQL', 'Server␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('mysql', '5.5.62␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', ' 5.7.27␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '8.0.35␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('MySQL', '5.6.26 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('mysql', '5.7␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.5.34␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '8.4lataforma, usuario, password , tipo_db_rdbms') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mongo', 'DB 8␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('MySQL', '5.1.52␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Oracle', '10g V10.2.0.1.0␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.6.35 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('SQL', 'Server 2000 (versión 8.0)␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Tomcat', '5.5.25 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.1.71 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '8.0.34␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '8.0.33␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.5.33-log␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.6.35␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql␍', 'N/A') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('MySQL', '5.1.73␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', ' 5.7.21␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '  5.6.39 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.1.3␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Mysql', '5.5.33␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('mysql', '8.0.22 ␍') ON CONFLICT DO NOTHING;
INSERT INTO motores_db (nombre_motor, version) VALUES ('Oracle', 'Database 10g Enterprise Edition Release 10.2.0.1.0␍') ON CONFLICT DO NOTHING;

-- 2. Tabla temporal para procesamiento
CREATE TEMP TABLE tmp_data (
    ip TEXT, hostname TEXT, plataforma TEXT, estado TEXT, usuario TEXT, pass TEXT, motor TEXT, v_motor TEXT, gb DECIMAL
);

INSERT INTO tmp_data VALUES
('148.215.1.73', 'Sistema de Correspondencia Institucional', 'Red Hat 4.8.5-11', 'Producción', 'mysql', '50.MiLQSIC', 'Mysql', '5.6.35␍', 1.2),
('148.215.1.45', 'desadds.uaemex.mx', 'Linux RedHat AS', 'Desarrollo', 'ddstomcat', 'xra32@:k', 'Tomcat', '5.5.25 ␍', 0),
('148.215.1.98', 'Prod DDS', 'Red Hat Enterprise Linux AS release 4', 'Producción', 'oracle', 'k2!top@.l96', 'Oracle', 'Database 10g Enterprise Edition Release 10.2.0.1.0␍', 0),
('148.215.53.31', 'Clon del servidor 1.98', 'Red Hat Enterprise Linux AS release 4', 'Producción', 'oracle', 'k2!top@.l96', 'Oracle', 'Database 10g Enterprise Edition Release 10.2.0.1.0␍', 0),
('148.215.1.29', 'Ocean3', 'Windows Server 2003 Standard Edition SP2', 'Producción', 'adolfo', 'desaado', 'SQL', 'Server␍', 0),
('148.215.1.31', 'Ocean33', 'Windows Server 2003', 'Desarrollo', 'Administrator', 'zxcdsa123', 'SQL', 'Server 2000 (versión 8.0)␍', 0),
('148.215.1.45', 'desadds.uaemex.mx', 'Linux RedHat AS', 'Desarrollo', 'oracle', 'oracledes', 'Oracle', '10g V10.2.0.1.0␍', 0),
('148.215.1.39', 'wwwdb', 'Red Hat Enterprise Linux Server release 6.7 (Santiago)', 'Producción', 'mysql', 'My5qLPro6.', 'MySQL', '5.6.26 ␍', 1),
('148.215.1.33', 'Repositorio', 'Red Hat Enterprise Linux Server release 5.6 (Tikanga)', 'Producción', 'mysql', 'Us3RMy5q!', 'MySQL', '5.1.52␍', 7.41),
('172.17.154.16', 'srvmysql', 'Red Hat Enterprise Linux Server release 6.3 (Santiago) x86_64 = Arquitectura de 64 bits', 'Desarrollo', 'mysql', 'U5MySQLD3s@', 'Mysql', '5.5.33␍', 11.24),
('172.17.154.52', 'ca-fise.uaemex.mx', 'Red Hat Enterprise Linux Server Release 6.5 (Santiago) x86_64 = Arquitectura de 64 bits.', 'Desarrollo', 'mysql', 'My5Q!f1S3', 'Mysql', '5.1.71 ␍', 1),
('148.215.1.56', 'Moodle', 'Red Hat Linux 7', 'Monitoreo', 'usrbd', 'B@s3D4t0s.', 'Mysql␍', 'N/A', 0),
('148.215.1.90', 'srvmysql', 'Red Hat Enterprise Linux Server release 6.5 (Santiago): x86_64 = Arquitectura de 64 bits', 'Producción', 'mysql', 'U5MySQL.Pr@', 'Mysql', '5.5.33-log␍', 2.61),
('148.215.1.48', 'kayako', 'Red Hat Enterprise Linux Server release 6.6 (Santiago)', 'Producción', 'mysql', 'Myskl500p', 'MySQL', '5.1.73␍', 12.52),
('172.17.154.59', 'bpm_db', 'Red Hat Enterprise Linux Server release 6.5 (Santiago) 64 bits, Ingles, SELinux-Enforcing, Firewall-Habilitado', 'Producción', 'mysql', 'Us3r%My5qL', 'Mysql', '5.5.33␍', 1.70),
('148.215.1.62', 'Nuevo Portal', 'Red Hat Enterprise Linux Server release 7.4 (Maipo)', 'Producción', 'areabd', 'B@s3-D4t0s', 'Mysql', ' 5.7.21␍', 3.25),
('148.215.1.25', 'srvbase', 'Red Hat Enterprise Linux Server release 6.5', 'Producción', 'areabd', '4r3@Bd*Prod', 'Mysql', ' 5.7.21␍', 38.86),
('148.215.1.55', 'srvmovil', 'Red Hat Enterprise Linux Server release 6.3 (Santiago)', 'Producción', 'mysql', 'W1sQL55', 'Mysql', '5.5.34␍', 1),
('148.215.1.145', '', 'Red Hat Enterprise Linux Server release 7.2 (Maipo)', 'Producción', 'mysql', 'MySq!SO2019', 'Mysql', '5.6.35 ␍', 11),
('148.215.109.120', 'Limesurvey', 'Ubuntu 18.04.3 LTS', 'Producción', 'mysql', '4Dm!n120', 'Mysql', ' 5.7.27␍', 1),
('148.215.1.188', 'Activos (SIGAT)', 'Red Hat Enterprise Linux Server release 7.7 (Maipo)', 'Producción', 'mysql', 'Mb@4c3Dat$x', 'mysql', '5.5.62␍', 2.34),
('148.215.109.172', 'Encuentas', 'CentOS Linux release 7.9.2009 (Core)', 'Producción', 'admin', 'Passw0Rd.', 'mysql', '5.7␍', 1),
('148.215.109.170', 'dbcitas', 'Red Hat Enterprise Linux Server release 7.9 (Maipo)', 'Producción', 'admin', 'Passw0rd.', 'mysql', '8.0.22 ␍', 1),
('148.215.1.164', '', 'Red Hat Enterprise Linux Server release 7.7 (Maipo)', 'Producción', 'mysql', 'My4w.164', 'Mysql', '  5.6.39 ␍', 1),
('148.215.109.242', 'Exclusivo para Joomlas (Portal UAEMex)', 'Red Hat Enterprise Linux release 9.3 (Plow)', 'Producción', 'areabd', 'B@s3#my8s3r!', 'Mysql', '8.0.35␍', 1),
('148.215.109.215', '', 'Red Hat Enterprise Linux release 9.2 (Plow)', 'Producción', 'areabd', 'B@s3*s3rm8!', 'Mysql', '8.0.33␍', 1.48),
('148.215.109.153', 'FISE', 'Red Hat', 'Producción', 'admbd', 'B@5e#4dm1*', 'Mysql', '5.1.3␍', 2),
('148.215.53.7', 'Expediente Mongo DB', 'Rocky Linux', 'Producción', 'userbd', '4dm#m0ndb*', 'Mongo', 'DB 8␍', 1),
('148.215.109.241', 'SEPBR', 'Linux', 'Producción', 'areabd', '4r3@Bd*4dm.', 'Mysql', '8.0.34␍', 1),
('148.215.154.3', 'DBSICOINS', 'Rocky Linux 9.6', 'Producción', 'admbd', '4dmBDMy5Ql.vs', 'Mysql', '8.4lataforma, usuario, password , tipo_db_rdbms', 2);

-- 3. Mapear a tablas finales

    -- Insertar Servidores
    INSERT INTO servidores (ip_address, hostname, os_type, id_nivel)
    SELECT DISTINCT ip, hostname, plataforma, 
           CASE 
             WHEN estado = 'Producción' THEN 3
             WHEN estado = 'Monitoreo' THEN 2
             ELSE 1 
           END
    FROM tmp_data;

    -- Insertar Instancias
    INSERT INTO instancias_db (id_servidor, id_motor, db_user, db_password, db_name)
    SELECT s.id_servidor, m.id_motor, t.usuario, t.pass, t.hostname
    FROM tmp_data t
    JOIN servidores s ON t.ip = s.ip_address
    JOIN motores_db m ON t.motor = m.nombre_motor AND t.v_motor = m.version;
    
COMMIT;