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
          image_path TEXT, 
          price REAL,
          min_stock INTEGER,
          max_stock INTEGER,
          categoria TEXT,
          quantity_sold INTEGER
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

    await db.execute('''
        CREATE TABLE orden_venta (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        numero_referencia TEXT,
        fecha TEXT,
        descripcion TEXT,
        monto REAL,
        FOREIGN KEY (cliente_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''

      CREATE TABLE orden_venta_producto (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          orden_venta_id INTEGER,
          producto_id INTEGER,
          cantidad INTEGER,
          FOREIGN KEY (orden_venta_id) REFERENCES orden_venta(id),
          FOREIGN KEY (producto_id) REFERENCES products(id)
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

    Future insertOrder(Map<String, dynamic> order) async {
  final db = await database;
  if (db != null) {
    // Verificar la disponibilidad de productos antes de insertar la orden
    for (Map<String, dynamic> product in order['productos']) {
      final productId = product['id'];
      final productName = product['name'];
      final productQuantity = product['quantity'];
      final productAvailableQuantity = await getProductAvailableQuantity(productId);
      
      if (productQuantity > productAvailableQuantity) {
        // Si la cantidad solicitada es mayor que la cantidad disponible, mostrar un mensaje de error
        print('Error: Producto con ID $productId no tiene suficiente stock disponible.');
        return {"failure": -1, "Error":"Producto $productName no tiene suficiente stock disponible." };
      }
    }

    // Insertar la orden de venta en la tabla 'orden_venta'
    int orderId = await db.insert('orden_venta', {
      'cliente_id': order['cliente_id'],
      'numero_referencia': order['numero_referencia'],
      'fecha': order['fecha'],
      'descripcion': order['descripcion'],
      'monto': order['monto'],
    });

    // Recorrer la lista de productos y agregarlos a la tabla de unión 'orden_venta_producto'
    for (Map<String, dynamic> product in order['productos']) {
      await db.insert('orden_venta_producto', {
        'orden_venta_id': orderId,
        'producto_id': product['id'],
        'cantidad': product['quantity'], // Agrega la cantidad del producto si es necesario
      });

      // Actualizar la cantidad disponible del producto en la tabla 'products'
      int productId = product['id'];
      int soldQuantity = product['quantity'];
      await db.rawUpdate(
        'UPDATE products SET quantity = quantity - ? WHERE id = ?',
        [soldQuantity, productId],
      );
    }

    return orderId;
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
    return -1;
  }
}

Future<int> getProductAvailableQuantity(int productId) async {
  final db = await database;
  if (db != null) {
    // Consultar la cantidad disponible del producto en la tabla 'products'
    List<Map<String, dynamic>> result = await db.query('products', where: 'id = ?', whereArgs: [productId]);
    if (result.isNotEmpty) {
      return result.first['quantity'] ?? 0;
    } else {
      // Manejar el caso en el que no se encuentre el producto
      print('Error: No se encontró el producto con ID $productId');
      return 0;
    }
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
    return 0;
  }
}



}