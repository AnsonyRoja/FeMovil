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


  Future<List<Map<String, dynamic>>> getRetencionesWithProveedorNames() async {
    final db = await DatabaseHelper.instance.database;
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



