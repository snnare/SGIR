-- Crear usuario
CREATE USER sgir_monitoreo IDENTIFIED BY "123Nokia$"
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Permitir conexión
GRANT CREATE SESSION TO sgir_monitoreo;

-- Acceso a metadata (similar a information_schema)
GRANT SELECT_CATALOG_ROLE TO sgir_monitoreo;

-- Acceso amplio a diccionario (útil para monitoreo)
GRANT SELECT ANY DICTIONARY TO sgir_monitoreo;

-- Vistas dinámicas clave (rendimiento / estado)
GRANT SELECT ON V_$SESSION TO sgir_monitoreo;
GRANT SELECT ON V_$DATABASE TO sgir_monitoreo;
GRANT SELECT ON V_$INSTANCE TO sgir_monitoreo;
GRANT SELECT ON V_$SYSSTAT TO sgir_monitoreo;
GRANT SELECT ON V_$PROCESS TO sgir_monitoreo;

-- (Opcional) Acceso a objetos del esquema SPARHDB
BEGIN
  FOR t IN (SELECT table_name FROM all_tables WHERE owner = 'SPARHDB') LOOP
    EXECUTE IMMEDIATE 'GRANT SELECT ON SPARHDB.' || t.table_name || ' TO sgir_monitoreo';
  END LOOP;
END;
/
