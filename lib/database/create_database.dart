  import 'package:femovil/infrastructure/models/products.dart';
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
            cod_product INTEGER,
            name TEXT,
            quantity INTEGER,
            price REAL,
            pro_cat_id INTEGER,
            categoria TEXT,
            tax_cat_id INTEGER,
            tax_cat_name STRING,
            um_id INTEGER,
            um_name STRING,
            quantity_sold INTEGER,
            FOREIGN KEY(tax_id) REFERENCES tax(id)

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
          saldo_neto,
          usuario_id INTEGER,
          FOREIGN KEY (cliente_id) REFERENCES clients(id),
          FOREIGN KEY (usuario_id) REFERENCES usuarios(id)

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
          saldo_neto REAL,
          usuario_id INTEGER,
          FOREIGN KEY (proveedor_id) REFERENCES clients(id),
          FOREIGN KEY (usuario_id) REFERENCES usuarios(id)

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

        await db.execute('''
          CREATE TABLE retenciones(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            total_bdi INTEGER,
            impuesto TEXT,
            fecha_transaccion TEXT,
            tipo_retencion TEXT,
            nro_document INTEGER,
            porcentaje REAL, 
            total_impuesto REAL, 
            regla_retencion TEXT,
            orden_compra_id INTEGER,
            FOREIGN KEY(orden_compra_id) REFERENCES orden_compra(id)
            )

        ''');

          await db.execute('''
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT,
            ad_user_id TEXT,
            email TEXT,
            phone TEXT
            )
        ''');

          await db.execute('''
          CREATE TABLE tax(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          name TEXT,
          rate INTEGER,
          iswithholding TEXT
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
    required double amount,
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

  Future<List<Map<String, dynamic>>> getProductsAndTaxes() async {
  final  db = await database;
  if (db != null) {
    // Realiza una consulta que una las tablas "products" y "tax" utilizando una cláusula JOIN
    return await db.rawQuery('''
      SELECT p.*, t.rate AS tax_rate
      FROM products p
      JOIN tax t ON p.tax_id = t.id
      WHERE t.iswithholding = 'n'
    ''');
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return [];
  }
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

   Future<List<Map<String, dynamic>>> getTaxs() async {
    final db = await database;
    if (db != null) {
      // Realiza la consulta para recuperar todos los registros de la tabla "products"
      return await db.query('tax');
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
        'saldo_neto': order['saldo_neto'],
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
      // for (Map<String, dynamic> product in order['productos']) {
      //   final productId = product['id'];
      //   final productName = product['name'];
      //   final productQuantity = product['quantity'];
      //   final productAvailableQuantity = await getProductAvailableQuantity(productId);
        
      //   if (productQuantity > productAvailableQuantity) {
      //     // Si la cantidad solicitada es mayor que la cantidad disponible, mostrar un mensaje de error
      //     print('Error: Producto con ID $productId no tiene suficiente stock disponible.');
      //     return {"failure": -1, "Error":"Producto $productName no tiene suficiente stock disponible." };
      //   }
      // }

      // Insertar la orden de venta en la tabla 'orden_venta'
      int orderId = await db.insert('orden_compra', {
        'proveedor_id': order['proveedor_id'],
        'numero_referencia': order['numero_referencia'],
        'numero_factura': order['numero_factura'],
        'fecha': order['fecha'],
        'descripcion': order['descripcion'],
        'monto': order['monto'],
        'saldo_neto':order['saldo_neto'],
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
          'UPDATE products SET quantity = quantity + ? WHERE id = ?',
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
          SELECT p.id, p.name, p.price, p.quantity, ovp.cantidad, t.rate AS impuesto
          FROM products p
          INNER JOIN orden_venta_producto ovp ON p.id = ovp.producto_id
          INNER JOIN tax t ON p.tax_id = t.id
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

  Future<List<Map<String, dynamic>>> getAllOrdenesCompraWithProveedorNames() async {
    final db = await database;
    if (db != null) {
      // Consultar todas las órdenes de compra con el nombre del proveedor asociado
      List<Map<String, dynamic>> ordenesCompra = await db.rawQuery('''
        SELECT oc.*, p.name AS nombre_proveedor
        FROM orden_compra oc
        INNER JOIN providers p ON oc.proveedor_id = p.id
      ''');
      return ordenesCompra;
    } else {
      // Manejar el caso en el que db sea null
      print('Error: db is null');
      return [];
    }
  }

    static Future<void> insertRetencion(Map<String, dynamic> retencion) async {
      await _database?.insert(
        'retenciones',
        retencion,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

  Future<List<Map<String, dynamic>>> getRetencionesWithProveedorNames() async {
    final db = await database;
    if (db != null) {
      // Realiza la consulta para recuperar todas las retenciones de la tabla "retenciones"
      // y sus proveedores asociados
      return await db.rawQuery('''
        SELECT r.*, oc.*, p.name AS nombre_proveedor
        FROM retenciones r
        INNER JOIN orden_compra oc ON r.orden_compra_id = oc.id
        INNER JOIN providers p ON oc.proveedor_id = p.id
      ''');
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
      return [];
    }
  }



  Future<bool> facturaTieneRetencion(int id) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Consultar retenciones asociadas a la factura
      List<Map<String, dynamic>> retenciones = await db.rawQuery('''
        SELECT * FROM retenciones WHERE orden_compra_id = ?
      ''', [id]);

      // Verificar si hay alguna retención asociada
      return retenciones.isNotEmpty;
    } else {
      // Manejar el caso en el que db sea null
      print('Error: db is null');
      return false;
    }
  }


  Future<void> insertTaxData() async {
    // Abre la base de datos
    final db = await database;
    

    // Inserta los datos de prueba en la tabla "tax"
    await db?.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO tax(name, rate, iswithholding) VALUES(?, ?, ?)',
        ['Exento', 0, 'n'], // Datos de prueba para el primer impuesto
      );
      await txn.rawInsert(
        'INSERT INTO tax(name, rate, iswithholding) VALUES(?, ?, ?)',
        ['Iva 16%', 16, 'n'], // Datos de prueba para el segundo impuesto
      );
      // Puedes agregar más inserciones según sea necesario
    });

    print('Datos de prueba insertados en la tabla tax.');
  }


Future<void> syncProducts(List<Map<String, dynamic>> productsData) async {
  final db = await database;
  if (db != null) {
    // Itera sobre los datos de los productos recibidos
    for (Map<String, dynamic> productData in productsData) {
      // Construye un objeto Product a partir de los datos recibidos
      Product product = Product(
        name: productData['name'],
        price: productData['price'],
        quantity: productData['quantity'],
        categoria: productData['categoria'],
        qtySold: productData['total_sold'],
        taxId: productData['tax_id'],
      );

      // Convierte el objeto Product a un mapa
      Map<String, dynamic> productMap = product.toMap();

      // Consulta si el producto ya existe en la base de datos local por su nombre
      List<Map<String, dynamic>> existingProducts = await db.query(
        'products',
        where: 'name = ?',
        whereArgs: [product.name],
      );

      if (existingProducts.isNotEmpty) {
        // Si el producto ya existe, actualiza sus datos
        await db.update(
          'products',
          productMap,
          where: 'name = ?',
          whereArgs: [product.name],
        );
        print('Producto actualizado: ${product.name}');
      } else {
        // Si el producto no existe, inserta un nuevo registro en la tabla de productos
        await db.insert('products', productMap);
        print('Producto insertado: ${product.name}');
      }
    }
    print('Sincronización de productos completada.');
  } else {
    // Manejar el caso en el que db sea null
    print('Error: db is null');
  }
}

   



  }