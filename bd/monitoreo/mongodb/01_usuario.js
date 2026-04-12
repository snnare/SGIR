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

const baseName = "mi_base_";

for (let i = 1; i <= 50; i++) {
  let dbName = baseName + i;

  let newDb = db.getSiblingDB(dbName);

  // Insertar documento dummy para forzar creación
  newDb.init_collection.insertOne({
    createdAt: new Date(),
    init: true
  });

  print("Base creada: " + dbName);
}