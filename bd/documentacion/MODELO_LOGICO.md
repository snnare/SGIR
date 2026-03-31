# Modelo Lógico de Base de Datos - SGIR (Normalizado)

Este documento define la estructura lógica del sistema siguiendo estándares de normalización (3NF) y nomenclatura consistente.

## 1. Módulo de Identidad y Acceso (Humanos)
Controla quién entra a la plataforma y qué permisos tiene.

*   **`cat_rol`** (Catálogo de Roles)
    *   `id_rol` (PK, Serial)
    *   `nombre` (Varchar, 50, Unique): admin, operador, auditor.
    *   `descripcion` (Text)

*   **`usuario`** (Usuarios del Sistema)
    *   `id_usuario` (PK, UUID)
    *   `id_rol` (FK -> cat_rol)
    *   `username` (Varchar, 50, Unique)
    *   `email` (Varchar, 100, Unique)
    *   `password_hash` (Varchar)
    *   `esta_activo` (Boolean)
    *   `ultimo_login_at` (Timestamp)
    *   `intentos_fallidos` (Integer)
    *   `bloqueado_hasta_at` (Timestamp)
    *   `creado_at` (Timestamp)

*   **`sesion_usuario`** (Manejo de JWT y Refresh Tokens)
    *   `id_sesion` (PK, UUID)
    *   `id_usuario` (FK -> usuario)
    *   `refresh_token` (Varchar, Unique)
    *   `ip_origen` (Inet)
    *   `user_agent` (Varchar)
    *   `expira_at` (Timestamp)
    *   `creado_at` (Timestamp)

## 2. Módulo de Infraestructura y Bóveda (Assets)
Administra los servidores, bases de datos y sus credenciales de servicio.

*   **`cat_nivel_criticidad`**
    *   `id_nivel` (PK, Serial)
    *   `nombre` (Varchar, 50): Estándar, Productivo, Misión Crítica.
    *   `dias_retencion` (Integer)

*   **`cat_motor_db`**
    *   `id_motor` (PK, Serial)
    *   `nombre` (Varchar, 50): MySQL, Oracle, MongoDB.
    *   `version` (Varchar, 20)
    *   `es_legacy` (Boolean)

*   **`credencial`** (Bóveda de Credenciales de Infraestructura)
    *   `id_credencial` (PK, UUID)
    *   `nombre_alias` (Varchar): Identificador amigable (ej. "Admin SSH Producción").
    *   `tipo` (Varchar, 10): 'SSH' o 'DB'.
    *   `usuario` (Varchar, 50): Usuario real en el activo remoto.
    *   `password_cifrado` (Text): Cifrado reversible (AES-256).
    *   `llave_privada_path` (Varchar): Ruta a archivos .pem/.key.
    *   `extra_params` (JSONB): Parámetros específicos (puertos no estándar, flags).
    *   `creado_at` (Timestamp)

*   **`servidor`**
    *   `id_servidor` (PK, UUID)
    *   `id_nivel` (FK -> cat_nivel_criticidad)
    *   `id_credencial` (FK -> credencial): Credencial tipo SSH para acceso base.
    *   `hostname` (Varchar, 100)
    *   `ip_address` (Inet)
    *   `puerto_ssh` (Integer, Default 22)
    *   `sistema_operativo` (Varchar, 50)
    *   `creado_at` (Timestamp)

*   **`instancia_db`**
    *   `id_instancia` (PK, UUID)
    *   `id_servidor` (FK -> servidor)
    *   `id_motor` (FK -> cat_motor_db)
    *   `id_credencial` (FK -> credencial): Credencial tipo DB para monitoreo.
    *   `nombre_db` (Varchar, 100)
    *   `puerto_db` (Integer)
    *   `creado_at` (Timestamp)

## 3. Módulo de Operaciones (Métricas y Logs)
Registra la actividad histórica y auditoría.

*   **`metrica_monitoreo`**
    *   `id_metrica` (PK, BigSerial)
    *   `id_servidor` (FK -> servidor)
    *   `id_instancia` (FK -> instancia_db)
    *   `cpu_uso` (Decimal)
    *   `ram_uso` (Decimal)
    *   `disco_uso` (Decimal)
    *   `conexiones_activas` (Integer)
    *   `tamano_db_gb` (Decimal)
    *   `capturado_at` (Timestamp)

*   **`respaldo`**
    *   `id_respaldo` (PK, UUID)
    *   `id_instancia` (FK -> instancia_db)
    *   `nombre_archivo` (Varchar)
    *   `ruta_local` (Varchar)
    *   `ruta_nube` (Varchar)
    *   `tamano_bytes` (BigInt)
    *   `hash_sha256` (Varchar)
    *   `estado` (Varchar, 20): Exitoso, Fallido, En proceso.
    *   `ejecutado_at` (Timestamp)

*   **`log_auditoria`**
    *   `id_log` (PK, BigSerial)
    *   `id_usuario` (FK -> usuario)
    *   `evento` (Varchar, 200): Ej: "LOGIN_EXITOSO", "BACKUP_INICIADO".
    *   `detalles` (JSONB): Datos adicionales del contexto.
    *   `creado_at` (Timestamp)
