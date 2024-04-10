  import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:sqflite/sqflite.dart';

Future<void> insertTaxData() async {
    // Abre la base de datos
    final db = await DatabaseHelper.instance.database;
    

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
    final db = await DatabaseHelper.instance.database;
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
    // Esto significa que si hay un conflicto, es decir si ya existe un registro con la misma clave primaria o restriccion unica, el registro existente se remplazara por el nuevo
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

 

    
      Future insertOrder(Map<String, dynamic> order) async {
    final db = await DatabaseHelper.instance.database;
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
        'documentno': order['documentno'],
        'fecha': order['fecha'],
        'descripcion': order['descripcion'],
        'monto': order['monto'],
        'saldo_neto': order['saldo_neto'],
        'c_bpartner_id': order['c_bpartner_id'],
        'c_bpartner_location_id': order['c_bpartner_location_id'],
        'c_doctypetarget_id': order['c_doctypetarget_id'],
        'ad_client_id': order['ad_client_id'],
        'ad_org_id':order['ad_org_id'],
        'm_warehouse_id': order['m_warehouse_id'],
        'paymentrule' : order['paymentrule'],
        'date_ordered':order['date_ordered'],
        'salesrep_id': order['salesrep_id'],
        'usuario_id': order['usuario_id'],
        'status_sincronized': order['status_sincronized'],
      });

      // Recorrer la lista de productos y agregarlos a la tabla de unión 'orden_venta_producto'
      for (Map<String, dynamic> product in order['productos']) {
        await db.insert('orden_venta_lines', {
          'orden_venta_id': orderId,
          'producto_id': product['id'],
          'qty_entered': product['quantity'],
          'price_entered': product['price'],
          'price_actual': product['price'],
          'm_product_id': product['m_product_id'],
          'ad_client_id': order['ad_client_id'],
          'ad_org_id': order['ad_org_id'],
          'c_order_id': order['c_order_id']

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
    final db = await DatabaseHelper.instance.database;
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
        await db.insert('orden_compra_lines', {
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



     Future<void> insertRetencion(Map<String, dynamic> retencion) async {
          final db = await DatabaseHelper.instance.database;

      await db?.insert(
        'retenciones',
        retencion,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }


 Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await DatabaseHelper.instance.database;
    await db?.insert(
      'usuarios',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
