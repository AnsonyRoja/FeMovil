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



 Future insertCobro({
    required int cBankAccountId,
    required int? cDocTypeId,
    required String? dateTrx,
    required String description,
    required int? cBPartnerId,
    required dynamic payAmt,
    required String? date,
    required dynamic cCurrencyId,
    required dynamic cOrderId,
    required dynamic cInvoiceId,
    required dynamic documentNo,
    required dynamic tenderType,
    required int saleOrderId,
  }) async {
    final db = await DatabaseHelper.instance.database;

        

  int cobroId =  await db!.insert(
      'cobros',
      {
        'c_bankaccount_id': cBankAccountId,
        'c_doctype_id': cDocTypeId,
        'date_trx': dateTrx,
        'date': date,
        'description': description,
        'c_bpartner_id': cBPartnerId,
        'pay_amt': payAmt,
        'c_currency_id': cCurrencyId,
        'c_order_id': cOrderId,
        'c_invoice_id': cInvoiceId,
        'documentno': documentNo,
        'tender_type': tenderType,
        'sale_order_id': saleOrderId,
      },
    // Esto significa que si hay un conflicto, es decir si ya existe un registro con la misma clave primaria o restriccion unica, el registro existente se remplazara por el nuevo
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );


    return cobroId;

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


      // Insertar la orden de venta en la tabla 'orden_venta'
      int orderId = await db.insert('orden_compra', {
        'proveedor_id': order['proveedor_id'],
        'documentno': order['documentno'],
        'c_doc_type_target_id': order['c_doc_type_target_id'],
        'ad_client_id': order['ad_client_id'],
        'ad_org_id': order['ad_org_id'],
        'm_warehouse_id': order['m_warehouse_id'],
        'payment_rule': order['payment_rule'],
        'dateordered':order['dateordered'],
        'sales_rep_id': order['sales_rep_id'],
        'c_bpartner_id': order['c_bpartner_id'],
        'c_bpartner_location_id': order['c_bpartner_location_id'],
        'm_price_list_id' : order['m_price_list_id'],
        'c_currency_id': order['c_currency_id'],
        'c_payment_term_id': order['c_payment_term_id'],
        'c_conversion_type_id' : order['c_conversion_type_id'],
        'po_reference' : order['po_reference'], 
        'description' : order['description'], 
        'id_factura' : order['id_factura'], 
        'fecha': order['fecha'], 
        'monto' : order['monto'],
        'saldo_neto': order['saldo_neto'],
        'usuario_id':order['usuario_id'],
        'status_sincronized' : order['status_sincronized'],
      });

      // Recorrer la lista de productos y agregarlos a la tabla de unión 'orden_venta_producto'
      for (Map<String, dynamic> product in order['productos']) {
        await db.insert('orden_compra_lines', {
          'orden_compra_id': orderId,
          'producto_id': product['id'],
          'qty_entered': product['quantity'],
          'ad_client_id': order['ad_client_id'],
          'ad_org_id': order['ad_org_id'], 
          'price_entered': product['price'], 
          'price_actual': product['price'],
          'm_product_id': product['m_product_id'],  

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



     Future insertRetencion(Map<String, dynamic> retencion) async {
          final db = await DatabaseHelper.instance.database;

        if (db != null) {
              int retencionId = await db.insert('f_retenciones', {
                'ad_client_id': retencion['ad_client_id'],
                'ad_org_id': retencion['ad_org_id'],
                'c_bpartner_id': retencion['c_bpartner_id'],
                'c_bpartner_location_id': retencion['c_bpartner_location_id'],
                'c_currency_id': retencion['c_currency_id'],
                'c_doctypetarget_id': retencion['c_doctypetarget_id'],
                'c_paymentterm_id': retencion['c_paymentterm_id'],
                'description':retencion['description'],
                'documentno': retencion['documentno'],
                'is_sotrx': retencion['is_sotrx'],
                'm_pricelist_id': retencion['m_pricelist_id'],
                'payment_rule' : retencion['payment_rule'],
                'date_invoiced': retencion['date_invoiced'],
                'date_acct': retencion['date_acct'],
                'sales_rep_id' : retencion['sales_rep_id'],
                'sri_authorization_code' : retencion['sri_authorization_code'], 
                'ing_establishment' : retencion['ing_establishment'], 
                'ing_emission' : retencion['ing_emission'], 
                'ing_sequence': retencion['ing_sequence'], 
                'ing_taxsustance' : retencion['ing_taxsustance'],
                'date': retencion['date'],
                'monto':retencion['monto'],
                'provider_id': retencion['provider_id'],
              });

       for (Map<String, dynamic> product in retencion['productos']) {
        await db.insert('f_retencion_lines', {  
          'f_retencion_id': retencionId,
          'producto_id': product['id'],
          'qty_entered': product['quantity'],
          'ad_client_id': retencion['ad_client_id'],
          'ad_org_id': retencion['ad_org_id'], 
          'price_entered': product['price'], 
          'price_actual': product['price'],
          'm_product_id': product['m_product_id'],  

        });

        // Actualizar la cantidad disponible del producto en la tabla 'products'
        // int productId = product['id'];
        // int soldQuantity = product['quantity'];
        // await db.rawUpdate(
        //   'UPDATE products SET quantity = quantity + ? WHERE id = ?',
        //   [soldQuantity, productId],
        // );
      }
      print('Se inserto correctamente');
        return retencionId;
        
        }else{

          return -1;
        }


    

    }


 Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await DatabaseHelper.instance.database;
    await db?.insert(
      'usuarios',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
