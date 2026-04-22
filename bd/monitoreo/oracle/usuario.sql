-- Conectar al PDB
ALTER SESSION SET CONTAINER = XEPDB1;

-- Crear usuario
CREATE USER sgir_monitoreo IDENTIFIED BY "12312300";

-- Permisos
GRANT CREATE SESSION TO sgir_monitoreo;
GRANT SELECT_CATALOG_ROLE TO sgir_monitoreo;
GRANT SELECT ON v_$session TO sgir_monitoreo;
GRANT SELECT ON v_$sql TO sgir_monitoreo;
GRANT SELECT ON v_$process TO sgir_monitoreo;
GRANT SELECT ON v_$lock TO sgir_monitoreo;
GRANT SELECT ON v_$instance TO sgir_monitoreo;
GRANT SELECT ON dba_segments TO sgir_monitoreo;
GRANT SELECT ON dba_tablespaces TO sgir_monitoreo;
GRANT SELECT ON dba_free_space TO sgir_monitoreo;
