# Resumen de Cambios en Arquitectura de Base de Datos

Este documento resume las optimizaciones aplicadas al esquema de base de datos para garantizar la escalabilidad, seguridad y consistencia del sistema SGIR.

## 1. Estandarización de Nomenclatura
Se aplicó una convención de nombres profesional para facilitar el mantenimiento:
*   **Singularidad**: Los nombres de las tablas ahora están en singular (ej. `usuario` en lugar de `usuarios`), siguiendo el estándar de que una tabla representa una entidad.
*   **Prefijos de Catálogo**: Las tablas maestras o de referencia ahora usan el prefijo `cat_` (ej. `cat_rol`, `cat_motor_db`).
*   **Sufijos de Tiempo**: Los campos de fecha ahora terminan en `_at` para indicar un punto en el tiempo (ej. `creado_at`, `capturado_at`).
*   **Snake Case**: Se mantiene el uso de minúsculas y guiones bajos para máxima compatibilidad con PostgreSQL.

## 2. Normalización de Datos (3NF)
Se rediseñó el esquema para alcanzar la **Tercera Forma Normal**, eliminando redundancias:
*   **Separación de Credenciales**: Se creó la tabla `credencial`. Esto permite que múltiples servidores o bases de datos compartan la misma credencial sin duplicar contraseñas en el sistema.
*   **Aislamiento de Roles**: La gestión de permisos se centraliza en `cat_rol`, facilitando la auditoría de accesos.

## 3. Seguridad y Gestión de Identidad
Se añadió soporte nativo para un sistema de Login/Register de nivel empresarial:
*   **Humanos vs. Máquinas**: Se separó claramente a los usuarios que entran a la aplicación (`usuario`) de las cuentas de servicio que usa el sistema para conectarse a la infraestructura (`credencial`).
*   **Sesiones Seguras**: La tabla `sesion_usuario` permite gestionar Refresh Tokens (JWT), controlar cierres de sesión remotos y rastrear la IP/Dispositivo de origen.
*   **Protección de Cuentas**: Se añadieron campos para el control de ataques de fuerza bruta (`intentos_fallidos`, `bloqueado_hasta_at`).

## 4. Tipado de Datos Avanzado
Se aprovecharon las capacidades nativas de PostgreSQL para mejorar el rendimiento y la integridad:
*   **UUIDs**: Se utilizan identificadores universales únicos en lugar de enteros autoincrementales para evitar la predicción de IDs y facilitar migraciones futuras.
*   **INET**: Las direcciones IP ahora usan el tipo de datos `INET`, que valida automáticamente el formato (IPv4/IPv6) y permite búsquedas de red más rápidas.
*   **JSONB**: Los metadatos y logs de auditoría se almacenan en formato binario JSON para permitir flexibilidad sin sacrificar velocidad de consulta.

## 5. Integridad Referencial
Se definieron políticas de borrado claras:
*   **CASCADE**: Si se elimina un servidor o instancia, sus métricas y registros operativos relacionados se eliminan automáticamente para evitar datos huérfanos.
*   **RESTRICT/SET NULL**: Los registros de auditoría y roles están protegidos para mantener la trazabilidad histórica incluso si un usuario es dado de baja.
