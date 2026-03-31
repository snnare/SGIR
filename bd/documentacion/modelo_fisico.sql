-- Script de Creación de Base de Datos - SGIR (Normalizado)
-- Motor: PostgreSQL

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. MÓDULO DE IDENTIDAD Y ACCESO (HUMANOS)
-- ==========================================

CREATE TABLE cat_rol (
    id_rol SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

CREATE TABLE usuario (
    id_usuario UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_rol INTEGER REFERENCES cat_rol(id_rol) ON DELETE RESTRICT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    esta_activo BOOLEAN DEFAULT TRUE,
    ultimo_login_at TIMESTAMP WITH TIME ZONE,
    intentos_fallidos INTEGER DEFAULT 0,
    bloqueado_hasta_at TIMESTAMP WITH TIME ZONE,
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sesion_usuario (
    id_sesion UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_usuario UUID REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    refresh_token VARCHAR(512) NOT NULL UNIQUE,
    ip_origen INET,
    user_agent VARCHAR(255),
    expira_at TIMESTAMP WITH TIME ZONE NOT NULL,
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 2. MÓDULO DE INFRAESTRUCTURA (ASSETS)
-- ==========================================

CREATE TABLE cat_nivel_criticidad (
    id_nivel SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    dias_retencion INTEGER NOT NULL DEFAULT 7
);

CREATE TABLE cat_motor_db (
    id_motor SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    version VARCHAR(20) NOT NULL,
    es_legacy BOOLEAN DEFAULT FALSE,
    CONSTRAINT uq_motor_version UNIQUE (nombre, version)
);

CREATE TABLE credencial (
    id_credencial UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre_alias VARCHAR(100) NOT NULL,
    tipo VARCHAR(10) CHECK (tipo IN ('SSH', 'DB')),
    usuario VARCHAR(50) NOT NULL,
    password_cifrado TEXT,
    llave_privada_path VARCHAR(255),
    extra_params JSONB,
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE servidor (
    id_servidor UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_nivel INTEGER REFERENCES cat_nivel_criticidad(id_nivel) ON DELETE RESTRICT,
    id_credencial UUID REFERENCES credencial(id_credencial) ON DELETE SET NULL,
    hostname VARCHAR(100) NOT NULL UNIQUE,
    ip_address INET NOT NULL,
    puerto_ssh INTEGER DEFAULT 22,
    sistema_operativo VARCHAR(50),
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE instancia_db (
    id_instancia UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_servidor UUID REFERENCES servidor(id_servidor) ON DELETE CASCADE,
    id_motor INTEGER REFERENCES cat_motor_db(id_motor) ON DELETE RESTRICT,
    id_credencial UUID REFERENCES credencial(id_credencial) ON DELETE SET NULL,
    nombre_db VARCHAR(100) NOT NULL,
    puerto_db INTEGER,
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 3. MÓDULO DE OPERACIONES (MÉTRICAS Y LOGS)
-- ==========================================

CREATE TABLE metrica_monitoreo (
    id_metrica BIGSERIAL PRIMARY KEY,
    id_servidor UUID REFERENCES servidor(id_servidor) ON DELETE CASCADE,
    id_instancia UUID REFERENCES instancia_db(id_instancia) ON DELETE CASCADE,
    cpu_uso DECIMAL(5,2),
    ram_uso DECIMAL(5,2),
    disco_uso DECIMAL(5,2),
    conexiones_activas INTEGER,
    tamano_db_gb DECIMAL(12,2),
    capturado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE respaldo (
    id_respaldo UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    id_instancia UUID REFERENCES instancia_db(id_instancia) ON DELETE CASCADE,
    nombre_archivo VARCHAR(255) NOT NULL,
    ruta_local VARCHAR(512),
    ruta_nube VARCHAR(512),
    tamano_bytes BIGINT,
    hash_sha256 VARCHAR(64),
    estado VARCHAR(20) DEFAULT 'En proceso' CHECK (estado IN ('Exitoso', 'Fallido', 'En proceso')),
    ejecutado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE log_auditoria (
    id_log BIGSERIAL PRIMARY KEY,
    id_usuario UUID REFERENCES usuario(id_usuario) ON DELETE SET NULL,
    evento VARCHAR(200) NOT NULL,
    detalles JSONB,
    creado_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices de Optimización
CREATE INDEX idx_metrica_capturado_at ON metrica_monitoreo(capturado_at);
CREATE INDEX idx_servidor_ip ON servidor(ip_address);
CREATE INDEX idx_respaldo_ejecutado_at ON respaldo(ejecutado_at);
CREATE INDEX idx_log_usuario ON log_auditoria(id_usuario);
