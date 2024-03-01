import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;


  class DatabaseHelper {

    static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
    static Database? _database;

    DatabaseHelper._privateConstructor();
    

    Future<Database?> get database async {
      
      if (_database != null) return _database;

      _database = await _initDatabase();
      return _database;
    }

     Future<void> deleteDatabases() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, 'femovil.db');

    // Elimina la base de datos si existe
    await deleteDatabase(dbPath);
    print('Base de datos eliminada');

    // Llama al método _initDatabase para crear la base de datos con la nueva estructura
    await _initDatabase();
    print('Base de datos creada nuevamente');
  }

  Future<Database> _initDatabase() async {
  print("Entré aquí en init database");
  String databasesPath = await getDatabasesPath();
  String dbPath = path.join(databasesPath, 'femovil.db');
  // Abre la base de datos o crea una nueva si no existe
  Database database = await openDatabase(dbPath, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          quantity INTEGER,
          price REAL,
          min_stock INTEGER,
          max_stock INTEGER,
          categoria TEXT
        )
      ''');
    await db.execute('''

      CREATE TABLE clients(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          ruc INTEGER,
          correo TEXT,
          telefono INTEGER,
          grupo TEXT
      )

  ''');
    },
  );

  return database;
}


  Future<List<Map<String, dynamic>>> getProducts() async {
  final db = await database;
  if (db != null) {
    // Realiza la consulta para recuperar todos los registros de la tabla "products"
    return await db.query('products');
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return [];
  }
}

  Future<List<Map<String, dynamic>>> getClients() async {
  final db = await database;
  if (db != null) {
    // Realiza la consulta para recuperar todos los registros de la tabla "products"
    return await db.query('clients');
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return [];
  }
}



 Future<Map<String, dynamic>?> getProductById(int productId) async {
    final db = await database;
    if (db != null) {
      // Realiza la consulta para recuperar un registro específico de la tabla "products" basado en su ID
      List<Map<String, dynamic>> result = await db.query('products', where: 'id = ?', whereArgs: [productId]);
      if (result.isNotEmpty) {
        return result.first;
      } else {
        return null; // Producto no encontrado
      }
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
      return null;
    }
  }

  Future<void> updateProduct(Map<String, dynamic> updatedProduct) async {
  final db = await database;
  if (db != null) {
    await db.update(
      'products',
      updatedProduct,
      where: 'id = ?',
      whereArgs: [updatedProduct['id']],
    );
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
  }
}

  Future<void> updateClient(Map<String, dynamic> updatedClient) async {
  final db = await database;
  if (db != null) {
    await db.update(
      'clients',
      updatedClient,
      where: 'id = ?',
      whereArgs: [updatedClient['id']],
    );
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
  }
}




}