 import 'package:femovil/database/create_database.dart';

Future<List<Map<String, dynamic>>> getProductsAndTaxes() async {
      final db = await DatabaseHelper.instance.database;
  if (db != null) {
    // Realiza una consulta que una las tablas "products" y "tax" utilizando una cláusula JOIN
    return await db.rawQuery('''
      SELECT p.*, t.rate AS tax_rate
      FROM products p
      JOIN tax t ON p.tax_cat_id = t.c_tax_category_id
      WHERE t.iswithholding = 'N'
    ''');
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return [];
  }
}



Future<List<Map<String, dynamic>>> getProducts() async {
      final db = await DatabaseHelper.instance.database;
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
      final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Realiza la consulta para recuperar todos los registros de la tabla "products"
      return await db.query('tax');
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
      return [];
    }
  }


 Future<List<Map<String, dynamic>>> getBankAccounts() async {
      final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Realiza la consulta para recuperar todos los registros de la tabla "bank_account_app"
      return await db.query('bank_account_app');
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
      return [];
    }
  }



    Future<List<Map<String, dynamic>>> getClients() async {
     final db = await DatabaseHelper.instance.database;

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
      final db = await DatabaseHelper.instance.database;
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
      final db = await DatabaseHelper.instance.database;
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


    Future<List<Map<String, dynamic>>> getAllOrdersWithClientNames() async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Consultar todas las órdenes de venta con el nombre del cliente asociado
      List<Map<String, dynamic>> orders = await db.rawQuery('''
        SELECT o.*, c.bp_name AS nombre_cliente, c.ruc as ruc,
        (o.monto - COALESCE((SELECT SUM(pay_amt) FROM cobros WHERE sale_order_id = o.id), 0)) AS saldo_total
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
  
    Future<List<Map<String, dynamic>>> getAllOrdersWithVendorsNames() async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Consultar todas las órdenes de venta con el nombre del cliente asociado
      List<Map<String, dynamic>> orders = await db.rawQuery('''
        SELECT o.*, p.bpname AS nombre_proveedor, p.tax_id as ruc
        FROM orden_compra o
        INNER JOIN providers p ON o.proveedor_id = p.id
      ''');
      return orders;
    } else {
      // Manejar el caso en el que db sea null
      print('Error: db is null');
      return [];
    }
  }


  Future<Map<String, dynamic>> getOrderWithProducts(int orderId) async {
    
    final db = await DatabaseHelper.instance.database;
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
          SELECT p.id, p.name, p.price, p.quantity, ovl.qty_entered, ovl.price_actual, t.rate AS impuesto
          FROM products p
          INNER JOIN orden_venta_lines ovl ON p.id = ovl.producto_id
          INNER JOIN tax t ON p.tax_cat_id  = t.c_tax_category_id
          WHERE ovl.orden_venta_id = ?
        ''', [orderId]);



        int clienteId = orderResult[0]['cliente_id'];


        List<Map<String, dynamic>> clientsResult = await db.rawQuery('''
          SELECT c.bp_name, c.ruc, c.email
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


    Future<Map<String, dynamic>> getOrderPurchaseWithProducts(int orderId) async {
    

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Consultar la orden de venta con el ID especificado
      List<Map<String, dynamic>> orderResult = await db.query(
        'orden_compra',
        where: 'id = ?',
        whereArgs: [orderId],
      );




      if (orderResult.isNotEmpty) {
        // Consultar los productos asociados a la orden de venta
       List<Map<String, dynamic>> productsResult = await db.rawQuery('''
          SELECT p.id, p.name, p.price, p.quantity, ocl.qty_entered, ocl.price_actual, t.rate AS impuesto
          FROM products p
          INNER JOIN orden_compra_lines ocl ON p.id = ocl.producto_id
          INNER JOIN tax t ON p.tax_cat_id  = t.c_tax_category_id
          WHERE ocl.orden_compra_id = ?
        ''', [orderId]);


        int provedorId = orderResult[0]['proveedor_id'];


        List<Map<String, dynamic>> clientsResult = await db.rawQuery('''
          SELECT p.bpname, p.tax_id
          FROM providers p
          WHERE  p.id = ?
        ''', [provedorId]); 


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
    final db = await DatabaseHelper.instance.database;
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
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Consultar todas las órdenes de compra con el nombre del proveedor asociado
      List<Map<String, dynamic>> ordenesCompra = await db.rawQuery('''
        
        SELECT oc.*, p.bpname AS nombre_proveedor
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


  Future<List<Map<String, dynamic>>> getRetencionesWithProveedorNames() async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      // Realiza la consulta para recuperar todas las retenciones de la tabla "retenciones"
      // y sus proveedores asociados
      return await db.rawQuery('''
        SELECT r.*, oc.*, p.bpname AS nombre_proveedor
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




   Future<List<Map<String, dynamic>>> getProductsWithZeroValues() async {
        final db = await DatabaseHelper.instance.database;
        if (db != null) {
          return await db.rawQuery('''
            SELECT * FROM products 
            WHERE cod_product = 0 AND m_product_id = 0
          ''');
        }
        return [];
      }


   Future<List<Map<String, dynamic>>> getCustomersWithZeroValues() async {
        final db = await DatabaseHelper.instance.database;
        if (db != null) {
          return await db.rawQuery('''
            SELECT * FROM clients 
            WHERE c_bpartner_id = 0 AND cod_client = 0
          ''');
        }
        return [];
      }

Future<List<Map<String, dynamic>>> getVendorWithZeroValues() async {
        final db = await DatabaseHelper.instance.database;
        if (db != null) {
          return await db.rawQuery('''
            
            SELECT * FROM providers 
            WHERE c_bpartner_id = 0 AND c_code_id = 0

          ''');
        }
        return [];
      }


  // Método para obtener los datos de un usuario por ID
 Future<Map<String, dynamic>?> getUserByLogin(String user, String password) async {
  final db = await DatabaseHelper.instance.database;
  if (db != null) {
    final List<Map<String, dynamic>> users = await db.query(
      'usuarios',
      where: 'name = ? AND password = ?', // Combina las condiciones en una sola cadena
      whereArgs: [user, password],
    );

    if (users.isNotEmpty) {
      return users.first;
    } else {
      return null;
    }
  }
  return null;
}


Future<List<Map<String, dynamic>>> obtenerOrdenesDeVentaConLineas() async {
  final db = await DatabaseHelper.instance.database;

  final List<Map<String, dynamic>> resultado = await db!.rawQuery('''
    SELECT 
      orden_venta.id,
      orden_venta.c_doctypetarget_id,
      orden_venta.ad_client_id,
      orden_venta.ad_org_id,
      orden_venta.m_warehouse_id,
      orden_venta.documentno,
      orden_venta.c_order_id,
      orden_venta.paymentrule,
      orden_venta.date_ordered,
      orden_venta.salesrep_id,
      orden_venta.c_bpartner_id,
      orden_venta.c_bpartner_location_id,
      orden_venta.fecha,
      orden_venta.descripcion,
      orden_venta.monto,
      orden_venta.saldo_neto,
      orden_venta.usuario_id,
      orden_venta.cliente_id,
      orden_venta.id_factura,
      orden_venta.status_sincronized,
      orden_venta_lines.id AS line_id,
      orden_venta_lines.producto_id,
      orden_venta_lines.price_entered,
      orden_venta_lines.price_actual,
      orden_venta_lines.m_product_id,
      orden_venta_lines.qty_entered
    FROM orden_venta
    JOIN orden_venta_lines ON orden_venta.id = orden_venta_lines.orden_venta_id
    WHERE orden_venta.documentno IS NULL OR orden_venta.documentno = '' 
  ''');

  Map<int, Map<String, dynamic>> ordenesMap = {};

  for (var row in resultado) {
    if (!ordenesMap.containsKey(row['id'])) {
      ordenesMap[row['id']] = {
        'id': row['id'],
        'c_doctypetarget_id': row['c_doctypetarget_id'],
        'ad_client_id': row['ad_client_id'],
        'ad_org_id': row['ad_org_id'],
        'm_warehouse_id': row['m_warehouse_id'],
        'documentno': row['documentno'],
        'paymentrule': row['paymentrule'],
        'date_ordered': row['date_ordered'],
        'salesrep_id': row['salesrep_id'],
        'c_bpartner_id': row['c_bpartner_id'],
        'c_bpartner_location_id': row['c_bpartner_location_id'],
        'fecha': row['fecha'],
        'descripcion': row['descripcion'],
        'monto': row['monto'],
        'saldo_neto': row['saldo_neto'],
        'usuario_id': row['usuario_id'],
        'cliente_id': row['cliente_id'],
        'id_factura':row['id_factura'],
        'status_sincronized': row['status_sincronized'],
        'lines': []
      };
    }

    ordenesMap[row['id']]!['lines'].add({
      'line_id': row['line_id'],
      'ad_client_id':row['ad_client_id'],
      'ad_org_id': row['ad_org_id'],
      'producto_id': row['producto_id'],
      'price_entered': row['price_entered'],
      'price_actual': row['price_actual'],
      'm_product_id': row['m_product_id'],
      'qty_entered': row['qty_entered']
    });
  }

  return ordenesMap.values.toList();
}



Future<Map<String, dynamic>> obtenerOrdenDeVentaConLineasPorId(int orderId) async {
  final db = await DatabaseHelper.instance.database;

  final List<Map<String, dynamic>> resultado = await db!.rawQuery('''
    SELECT 
      orden_venta.id,
      orden_venta.c_doctypetarget_id,
      orden_venta.ad_client_id,
      orden_venta.ad_org_id,
      orden_venta.m_warehouse_id,
      orden_venta.documentno,
      orden_venta.paymentrule,
      orden_venta.date_ordered,
      orden_venta.salesrep_id,
      orden_venta.c_bpartner_id,
      orden_venta.c_bpartner_location_id,
      orden_venta.fecha,
      orden_venta.descripcion,
      orden_venta.monto,
      orden_venta.saldo_neto,
      orden_venta.usuario_id,
      orden_venta.cliente_id,
      orden_venta.status_sincronized,
      orden_venta_lines.id AS line_id,
      orden_venta_lines.producto_id,
      orden_venta_lines.price_entered,
      orden_venta_lines.price_actual,
      orden_venta_lines.m_product_id,
      orden_venta_lines.qty_entered
    FROM orden_venta
    JOIN orden_venta_lines ON orden_venta.id = orden_venta_lines.orden_venta_id
    WHERE orden_venta.id = ?
  ''', [orderId]);

  // Si no se encontraron resultados, retornar un mapa vacío
  if (resultado.isEmpty) return {};

  // Crear un mapa para almacenar la orden de venta y sus líneas de productos
  Map<String, dynamic> ordenDeVenta = {};

  // Iterar sobre el resultado y construir la estructura deseada
  for (var row in resultado) {
    // Si la orden de venta aún no ha sido agregada al mapa, agregarla
    if (ordenDeVenta.isEmpty) {
      ordenDeVenta = {
        'id': row['id'],
        'c_doctypetarget_id': row['c_doctypetarget_id'],
        'ad_client_id': row['ad_client_id'],
        'ad_org_id': row['ad_org_id'],
        'm_warehouse_id': row['m_warehouse_id'],
        'documentno': row['documentno'],
        'paymentrule': row['paymentrule'],
        'date_ordered': row['date_ordered'],
        'salesrep_id': row['salesrep_id'],
        'c_bpartner_id': row['c_bpartner_id'],
        'c_bpartner_location_id': row['c_bpartner_location_id'],
        'fecha': row['fecha'],
        'descripcion': row['descripcion'],
        'monto': row['monto'],
        'saldo_neto': row['saldo_neto'],
        'usuario_id': row['usuario_id'],
        'cliente_id': row['cliente_id'],
        'status_sincronized': row['status_sincronized'],
        'lines': [] // Inicializar la lista de líneas de productos
      };
    }

    // Agregar la línea de producto actual a la lista de líneas de la orden de venta
    ordenDeVenta['lines'].add({
      'line_id': row['line_id'],
      'ad_client_id':row['ad_client_id'],
      'ad_org_id': row['ad_org_id'],
      'producto_id': row['producto_id'],
      'price_entered': row['price_entered'],
      'price_actual': row['price_actual'],
      'm_product_id': row['m_product_id'],
      'qty_entered': row['qty_entered']
    });

  }

  // Retornar la orden de venta con sus líneas de productos
  return ordenDeVenta;
}

Future<Map<String, dynamic>> obtenerOrdenDeCompraConLineasPorId(int orderId) async {
  print('Entre aqui a obtenerordedecomprasconlineas y esta es el orderid $orderId');
  final db = await DatabaseHelper.instance.database;

  final List<Map<String, dynamic>> resultado = await db!.rawQuery('''

    SELECT 
      orden_compra.id,
      orden_compra.c_doc_type_target_id,
      orden_compra.ad_client_id,
      orden_compra.ad_org_id,
      orden_compra.m_warehouse_id,
      orden_compra.documentno,
      orden_compra.payment_rule,
      orden_compra.dateordered,
      orden_compra.sales_rep_id,
      orden_compra.c_bpartner_id,
      orden_compra.c_bpartner_location_id,
      orden_compra.fecha,
      orden_compra.description,
      orden_compra.monto,
      orden_compra.saldo_neto,
      orden_compra.usuario_id,
      orden_compra.proveedor_id,
      orden_compra.status_sincronized,
      orden_compra_lines.id AS line_id,
      orden_compra_lines.producto_id,
      orden_compra_lines.price_entered,
      orden_compra_lines.price_actual,
      orden_compra_lines.m_product_id,
      orden_compra_lines.qty_entered
    FROM orden_compra
    JOIN orden_compra_lines ON orden_compra.id = orden_compra_lines.orden_compra_id
    WHERE orden_compra.id = ?

  ''', [orderId]);

  // Si no se encontraron resultados, retornar un mapa vacío
  if (resultado.isEmpty) return {};

  // Crear un mapa para almacenar la orden de venta y sus líneas de productos
  Map<String, dynamic> ordenDeCompra = {};

  // Iterar sobre el resultado y construir la estructura deseada
  for (var row in resultado) {
    // Si la orden de venta aún no ha sido agregada al mapa, agregarla
    if (ordenDeCompra.isEmpty) {
      ordenDeCompra = {
        'id': row['id'],
        'c_doc_type_target_id': row['c_doc_type_target_id'],
        'ad_client_id': row['ad_client_id'],
        'ad_org_id': row['ad_org_id'],
        'm_warehouse_id': row['m_warehouse_id'],
        'documentno': row['documentno'],
        'payment_rule': row['payment_rule'],
        'dateordered': row['dateordered'],
        'sales_rep_id': row['sales_rep_id'],
        'c_bpartner_id': row['c_bpartner_id'],
        'c_bpartner_location_id': row['c_bpartner_location_id'],
        'fecha': row['fecha'],
        'description': row['description'],
        'monto': row['monto'],
        'saldo_neto': row['saldo_neto'],
        'usuario_id': row['usuario_id'],
        'proveedor_id': row['proveedor_id'],
        'status_sincronized': row['status_sincronized'],
        'lines': [] // Inicializar la lista de líneas de productos
      };
    }

    // Agregar la línea de producto actual a la lista de líneas de la orden de venta
    ordenDeCompra['lines'].add({
      'line_id': row['line_id'],
      'ad_client_id':row['ad_client_id'],
      'ad_org_id': row['ad_org_id'],
      'producto_id': row['producto_id'],
      'price_entered': row['price_entered'],
      'price_actual': row['price_actual'],
      'm_product_id': row['m_product_id'],
      'qty_entered': row['qty_entered']
    });
  }


  // Retornar la orden de venta con sus líneas de productos
  return ordenDeCompra;
}



Future<Map<String, dynamic>?> getClientById(int clientId) async {
  final db = await DatabaseHelper.instance.database;

  if (db != null) {
    // Realiza la consulta para recuperar el cliente con el ID especificado
    List<Map<String, dynamic>> results = await db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [clientId],
    );

    // Verifica si se encontró un cliente con el ID especificado
    if (results.isNotEmpty) {
      // Devuelve el primer cliente encontrado (debería ser único ya que se filtra por ID)
      return results.first;
    } else {
      // Si no se encontró ningún cliente con el ID especificado, devuelve null
      return null;
    }
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return null;
  }
}


Future<Map<String, dynamic>?> getVendorsById(int vendorId) async {
  final db = await DatabaseHelper.instance.database;

  if (db != null) {
    // Realiza la consulta para recuperar el cliente con el ID especificado
    List<Map<String, dynamic>> results = await db.query(
      'providers',
      where: 'id = ?',
      whereArgs: [vendorId],
    );

    // Verifica si se encontró un cliente con el ID especificado
    if (results.isNotEmpty) {
      // Devuelve el primer cliente encontrado (debería ser único ya que se filtra por ID)
      return results.first;
    } else {
      // Si no se encontró ningún cliente con el ID especificado, devuelve null
      return null;
    }
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return null;
  }
}
