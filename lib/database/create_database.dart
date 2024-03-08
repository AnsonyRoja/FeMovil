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

      CREATE TABLE providers(
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


        await db.execute('''
        CREATE TABLE orden_compra (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        proveedor_id INTEGER,
        numero_referencia TEXT,
        numero_factura TEXT,
        fecha TEXT,
        descripcion TEXT,
        monto REAL,
        FOREIGN KEY (proveedor_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''

      CREATE TABLE orden_compra_producto (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          orden_compra_id INTEGER,
          producto_id INTEGER,
          cantidad INTEGER,
          FOREIGN KEY (orden_compra_id) REFERENCES orden_compra(id),
          FOREIGN KEY (producto_id) REFERENCES products(id)
       )

    ''');

      await db.execute('''
        CREATE TABLE cobros(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          number_reference INTEGER,
          type_document TEXT,
          payment_type TEXT, 
          date TEXT,
          coin TEXT,
          amount INTEGER,
          bank_account TEXT,
          observation TEXT,
          sale_order_id INTEGER,
          FOREIGN KEY (sale_order_id) REFERENCES orden_venta(id)

        )
      ''');

    },
  );

  return database;
}

Future<void> insertCobro({
  required int numberReference,
  required String? typeDocument,
  required String? paymentType,
  required String date,
  required String? coin,
  required int amount,
  required String? bankAccount,
  required String observation,
  required int saleOrderId,
}) async {
  final db = await database;
  await db!.insert(
    'cobros',
    {
      'number_reference': numberReference,
      'type_document': typeDocument,
      'payment_type': paymentType,
      'date': date,
      'coin': coin,
      'amount': amount,
      'bank_account': bankAccount,
      'observation': observation,
      'sale_order_id': saleOrderId,
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
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

  Future<List<Map<String, dynamic>>> getProviders() async {
  final db = await database;
  if (db != null) {
    // Realiza la consulta para recuperar todos los registros de la tabla "products"
    return await db.query('providers');
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

  Future<void> updateProvider(Map<String, dynamic> updatedProvider) async {
  final db = await database;
  if (db != null) {
    await db.update(
      'providers',
      updatedProvider,
      where: 'id = ?',
      whereArgs: [updatedProvider['id']],
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

  Future insertOrderCompra(Map<String, dynamic> order) async {
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
    int orderId = await db.insert('orden_compra', {
      'proveedor_id': order['proveedor_id'],
      'numero_referencia': order['numero_referencia'],
      'numero_factura': order['numero_factura'],
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




Future<List<Map<String, dynamic>>> getAllOrdersWithClientNames() async {
  final db = await database;
  if (db != null) {
    // Consultar todas las órdenes de venta con el nombre del cliente asociado
    List<Map<String, dynamic>> orders = await db.rawQuery('''
      SELECT o.*, c.name AS nombre_cliente, c.ruc as ruc,
      (o.monto - COALESCE((SELECT SUM(amount) FROM cobros WHERE sale_order_id = o.id), 0)) AS saldo_total
      FROM orden_venta o
      INNER JOIN clients c ON o.cliente_id = c.id
    ''');
    return orders;
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
    return [];
  }
}


Future<Map<String, dynamic>> getOrderWithProducts(int orderId) async {
  
  final db = await database;
  if (db != null) {
    // Consultar la orden de venta con el ID especificado
    List<Map<String, dynamic>> orderResult = await db.query(
      'orden_venta',
      where: 'id = ?',
      whereArgs: [orderId],
    );




    if (orderResult.isNotEmpty) {
      // Consultar los productos asociados a la orden de venta
      List<Map<String, dynamic>> productsResult = await db.rawQuery('''
        SELECT p.id, p.name, p.price, p.quantity, ovp.cantidad
        FROM products p
        INNER JOIN orden_venta_producto ovp ON p.id = ovp.producto_id
        WHERE ovp.orden_venta_id = ?
      ''', [orderId]);


      int clienteId = orderResult[0]['cliente_id'];


      List<Map<String, dynamic>> clientsResult = await db.rawQuery('''
        SELECT c.name, c.ruc
        FROM clients c
        WHERE  c.id = ?
      ''', [clienteId]); 


      // Crear un mapa que contenga la orden de venta y sus productos
      Map<String, dynamic> orderWithProducts = {
        'client': clientsResult,
        'order': orderResult.first, // La primera (y única) fila de la consulta de la orden de venta
        'products': productsResult, // Resultado de la consulta de productos asociados
      };

      return orderWithProducts;
    } else {
      // Manejar el caso en el que no se encuentra la orden de venta
      print('Error: No se encontró la orden de venta con ID $orderId');
      return {};
    }
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
    return {};
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