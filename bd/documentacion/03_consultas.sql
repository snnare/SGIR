-- ==============================================================================
-- CONSULTAS DE PRUEBA Y VALIDACIÓN (TESTING QUERIES) - SGIR
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- 1. INVENTARIO Y SALUD DE INFRAESTRUCTURA (Prueba de JOINs básicos)
-- ------------------------------------------------------------------------------
-- Objetivo: Listar todos los servidores con su nivel de criticidad y estado actual.
-- Valida: Relación Servidor -> Nivel_Criticidad -> Estado_General
SELECT 
    s.id_servidor,
    s.nombre_servidor,
    s.direccion_ip,
    s.es_legacy,
    nc.nombre_nivel AS criticidad,
    eg.nombre_estado AS estado_actual
FROM 
    Servidor s
JOIN 
    Nivel_Criticidad nc ON s.id_nivel_criticidad = nc.id_nivel_criticidad
JOIN 
    Estado_General eg ON s.id_estado_servidor = eg.id_estado
ORDER BY 
    s.id_servidor;


-- ------------------------------------------------------------------------------
-- 2. MAPEO DE BASES DE DATOS A SERVIDORES (Navegación de 3 niveles)
-- ------------------------------------------------------------------------------
-- Objetivo: Saber exactamente en qué máquina física/virtual vive cada base de datos.
-- Valida: Relación Base_de_Datos -> Instancia_DBMS -> Servidor -> DBMS
SELECT 
    bd.nombre_base,
    bd.tamano_mb,
    i.nombre_instancia,
    d.nombre_dbms || ' ' || d.version AS motor_db,
    s.nombre_servidor
FROM 
    Base_de_Datos bd
JOIN 
    Instancia_DBMS i ON bd.id_instancia = i.id_instancia
JOIN 
    DBMS d ON i.id_dbms = d.id_dbms
JOIN 
    Servidor s ON i.id_servidor = s.id_servidor
ORDER BY 
    bd.tamano_mb DESC;


-- ------------------------------------------------------------------------------
-- 3. AUDITORÍA DE POLÍTICAS DE RESPALDO (Prueba de tabla intermedia N:M)
-- ------------------------------------------------------------------------------
-- Objetivo: Ver qué políticas aplican a la base de datos de "Control Escolar".
-- Valida: Relación Base_de_Datos -> Asignacion_Politica_BD -> Política_de_Respaldo
SELECT 
    bd.nombre_base,
    pr.nombre_politica,
    pr.frecuencia_horas,
    tr.nombre_tipo AS tipo_respaldo
FROM 
    Base_de_Datos bd
JOIN 
    Asignacion_Politica_BD ap ON bd.id_base_datos = ap.id_base_datos
JOIN 
    Política_de_Respaldo pr ON ap.id_politica = pr.id_politica
JOIN 
    Tipo_Respaldo tr ON pr.id_tipo_respaldo = tr.id_tipo_respaldo
WHERE 
    bd.nombre_base = 'db_control_escolar';


-- ------------------------------------------------------------------------------
-- 4. REPORTE DE ESTADO DE RESPALDOS (Ideal para el Dashboard Principal)
-- ------------------------------------------------------------------------------
-- Objetivo: Mostrar los últimos respaldos ejecutados, dónde se guardaron y si fallaron.
-- Valida: Convergencia de múltiples llaves foráneas en la tabla Respaldo.
SELECT 
    r.fecha_inicio,
    bd.nombre_base,
    pr.nombre_politica,
    eg.nombre_estado AS resultado,
    rr.descripcion_ruta AS destino,
    r.tamano_mb
FROM 
    Respaldo r
JOIN 
    Base_de_Datos bd ON r.id_base_datos = bd.id_base_datos
JOIN 
    Política_de_Respaldo pr ON r.id_politica = pr.id_politica
JOIN 
    Estado_General eg ON r.id_estado_ejecucion = eg.id_estado
JOIN 
    Ruta_Respaldo rr ON r.id_ruta_respaldo = rr.id_ruta
ORDER BY 
    r.fecha_inicio DESC
LIMIT 5;


-- ------------------------------------------------------------------------------
-- 5. MONITOREO PROACTIVO: ALERTAS ACTIVAS (Filtrado y Agregación)
-- ------------------------------------------------------------------------------
-- Objetivo: Listar solo las alertas que están "Abiertas" (id_estado = 6) y su severidad.
-- Valida: Tablas Alerta, Servidor, Nivel_Alerta
SELECT 
    a.fecha_alerta,
    s.nombre_servidor,
    na.nombre_nivel AS urgencia,
    a.descripcion
FROM 
    Alerta a
JOIN 
    Servidor s ON a.id_servidor = s.id_servidor
JOIN 
    Nivel_Alerta na ON a.id_nivel_alerta = na.id_nivel_alerta
WHERE 
    a.id_estado_alerta = 6 -- 6 corresponde a "Abierta" en los Inserts
ORDER BY 
    na.id_nivel_alerta DESC, a.fecha_alerta DESC;


-- ------------------------------------------------------------------------------
-- 6. MÉTRICAS DE ESTRÉS EN SERVIDORES LEGACY (Análisis temporal)
-- ------------------------------------------------------------------------------
-- Objetivo: Extraer las métricas de CPU y RAM del servidor legacy que está en peligro.
-- Valida: Relación Servidor -> Monitoreo -> Métrica -> Tipo_Metrica
SELECT 
    s.nombre_servidor,
    tm.nombre_tipo AS metrica,
    m.valor || ' ' || tm.unidad_medida AS medicion,
    m.fecha_registro
FROM 
    Métrica m
JOIN 
    Monitoreo mon ON m.id_monitoreo = mon.id_monitoreo
JOIN 
    Servidor s ON mon.id_servidor = s.id_servidor
JOIN 
    Tipo_Metrica tm ON m.id_tipo_metrica = tm.id_tipo_metrica
WHERE 
    s.es_legacy = TRUE
ORDER BY 
    m.fecha_registro DESC;


-- ------------------------------------------------------------------------------
-- 7. TRAZABILIDAD Y BITÁCORA DE AUDITORÍA (Seguridad)
-- ------------------------------------------------------------------------------
-- Objetivo: Ver qué ha hecho el usuario Administrador (Angel) en el sistema.
-- Valida: Relación Usuario -> Bitacora -> Tipo_Evento
SELECT 
    b.fecha_evento,
    te.nombre_evento,
    b.entidad_afectada,
    b.id_entidad,
    b.descripcion_evento
FROM 
    Bitacora b
JOIN 
    Usuario u ON b.id_usuario = u.id_usuario
JOIN 
    Tipo_Evento_Auditoria te ON b.id_tipo_evento = te.id_tipo_evento
WHERE 
    u.email = 'aromero@uaemex.mx'
ORDER BY 
    b.fecha_evento DESC;
