-- Script de Creación de Base de Datos - SGIR
-- Motor: PostgreSQL

-- Extensiones necesarias
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Catálogo de Roles
CREATE TABLE roles (
    id_rol SERIAL PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- 2. Niveles de Criticidad
CREATE TABLE niveles_criticidad (
    id_nivel SERIAL PRIMARY KEY,
    nombre_nivel VARCHAR(50) NOT NULL,
    politica_retencion_dias INTEGER NOT NULL DEFAULT 7
);

INSERT INTO niveles_criticidad (nombre_nivel, politica_retencion_dias) VALUES
('Baja', 7),
('Media', 15),
('Crítica', 30);

-- 3. Catálogo de Motores de DB
CREATE TABLE motores_db (
    id_motor SERIAL PRIMARY KEY,
    nombre_motor VARCHAR(50) NOT NULL,
    version VARCHAR(100) NOT NULL,
    es_legacy BOOLEAN DEFAULT FALSE,
    CONSTRAINT uq_motores_db UNIQUE (nombre_motor, version)
);

-- 4. Usuarios del Sistema
CREATE TABLE usuarios_sistema (
    id_usuario UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_rol INTEGER REFERENCES roles(id_rol),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    esta_activo BOOLEAN DEFAULT TRUE,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Servidores (Assets)
CREATE TABLE servidores (
    id_servidor UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_nivel INTEGER REFERENCES niveles_criticidad(id_nivel),
    hostname VARCHAR(100) NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    os_type VARCHAR(255),
    ssh_user VARCHAR(50),
    ssh_port INTEGER DEFAULT 22,
    ssh_key_path VARCHAR(255),
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Instancias de Base de Datos
CREATE TABLE instancias_db (
    id_instancia UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_servidor UUID REFERENCES servidores(id_servidor) ON DELETE CASCADE,
    id_motor INTEGER REFERENCES motores_db(id_motor),
    db_name VARCHAR(100) NOT NULL,
    db_user VARCHAR(50),
    db_password TEXT, -- Debe almacenarse cifrado (AES o similar)
    puerto_db INTEGER,
    creado_en TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Histórico de Monitoreo
CREATE TABLE monitoreo_historico (
    id_metrica BIGSERIAL PRIMARY KEY,
    id_servidor UUID REFERENCES servidores(id_servidor) ON DELETE SET NULL,
    id_instancia UUID REFERENCES instancias_db(id_instancia) ON DELETE SET NULL,
    cpu_usage DECIMAL(5,2),
    ram_usage DECIMAL(5,2),
    disco_usage DECIMAL(5,2),
    conexiones_activas INTEGER,
    peso_total_gb DECIMAL(12,2),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Registro de Respaldos
CREATE TABLE respaldos (
    id_respaldo UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_instancia UUID REFERENCES instancias_db(id_instancia) ON DELETE CASCADE,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_local VARCHAR(512),
    ruta_nube VARCHAR(512),
    tamano_bytes BIGINT,
    sha256_hash VARCHAR(64),
    estado VARCHAR(20) CHECK (estado IN ('Exitoso', 'Fallido', 'En proceso')),
    fecha_ejecucion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. Bitácora de Auditoría
CREATE TABLE bitacora_auditoria (
    id_log BIGSERIAL PRIMARY KEY,
    id_usuario UUID REFERENCES usuarios_sistema(id_usuario) ON DELETE SET NULL,
    accion VARCHAR(200) NOT NULL,
    metadata JSONB,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices básicos para optimización
CREATE INDEX idx_monitoreo_timestamp ON monitoreo_historico(timestamp);
CREATE INDEX idx_servidor_ip ON servidores(ip_address);
CREATE INDEX idx_respaldo_fecha ON respaldos(fecha_ejecucion);
