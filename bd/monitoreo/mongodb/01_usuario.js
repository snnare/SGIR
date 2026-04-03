// Cambiamos a la base de datos admin para crear el usuario
db = db.getSiblingDB('admin');

db.createUser({
  user: "monitor_user",
  pwd: "tu_password_seguro_mongo",
  roles: [
    { role: "clusterMonitor", db: "admin" },
    { role: "readAnyDatabase", db: "admin" } // Opcional: si necesitas monitorear tamaños de colecciones
  ]
});

print("Usuario de monitoreo creado exitosamente.");
