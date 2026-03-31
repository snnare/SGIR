// Script de Inicialización para Monitoreo - MongoDB
// Se ejecuta en la base de datos 'admin' por defecto

db = db.getSiblingDB('admin');

// Crear el usuario de monitoreo SGIR
// Rol 'clusterMonitor': Permite ejecutar serverStatus, top, dbStats, etc.
db.createUser({
  user: "monitor_user",
  pwd: "monitor_pass",
  roles: [
    { role: "clusterMonitor", db: "admin" },
    { role: "readAnyDatabase", db: "admin" } // Opcional: para dbStats de todos los esquemas
  ]
});

// Crear una base de datos y colección de prueba
db = db.getSiblingDB('sgir_test_db_mongo');
db.health_check_dummy.insert({
  message: "Initial data for MongoDB monitoring tests",
  created_at: new Date()
});
