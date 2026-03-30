# Diseño de Base de Datos - SGIR (PostgreSQL)

Este documento detalla la estructura de la base de datos para el Sistema de Gestión de Infraestructura y Recursos (SGIR).

## 1. Definición de Entidades

### A. Gestión de Acceso y Seguridad
1.  **`roles`**: Catálogo de permisos del sistema (Administrador, Operador, Auditor).
2.  **`usuarios_sistema`**: Usuarios con acceso al panel de control (FastAPI/Frontend).

### B. Inventario de Infraestructura (Assets)
3.  **`niveles_criticidad`**: Clasificación de servidores (N1: Estándar, N2: Productivo, N3: Misión Crítica).
4.  **`motores_db`**: Catálogo de manejadores y versiones (MySQL 5.7, Oracle 19c, MongoDB 6.0).
5.  **`servidores`**: Registro físico/virtual de los nodos a monitorear.
6.  **`instancias_db`**: Bases de datos específicas dentro de cada servidor que requieren monitoreo y respaldo.

### C. Operaciones y Métricas
7.  **`monitoreo_historico`**: Almacén de métricas de salud (CPU, RAM, Disco, Conexiones).
8.  **`respaldos`**: Registro de archivos generados, rutas de almacenamiento y hashes de integridad.
9.  **`bitacora_auditoria`**: Registro maestro de acciones realizadas por usuarios o por el sistema.
