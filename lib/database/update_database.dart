import 'package:femovil/database/create_database.dart';

Future<void> updateProduct(Map<String, dynamic> updatedProduct) async {
    final db = await DatabaseHelper.instance.database;
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
    final db = await DatabaseHelper.instance.database;
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
    final db = await DatabaseHelper.instance.database;
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


Future<void> updateProductMProductIdAndCodProd(int productId, int newMProductId, int newCodProduct) async {
    final db = await DatabaseHelper.instance.database;
  print("esto es el valor de me produc id $newMProductId y el valor de newcodprodu $newCodProduct");
  if (db != null) {
    await db.update(
      'products',
      {
        'm_product_id': newMProductId,
        'cod_product': newCodProduct,
      },
      where: 'id = ?',
      whereArgs: [productId],
    );
    print('Product updated successfully');
  } else {
    print('Error: db is null');
  }
}

Future<void> updateCustomerCBPartnerIdAndCodClient(
  int customerId, 
  int cBPartnerId,
  int newCodClient,
  int cLocationId,
  int cBparnetLocationId,
   ) async {
    final db = await DatabaseHelper.instance.database;

  if (db != null) {
    await db.update(
      'clients',
      {
        'c_bpartner_id': cBPartnerId,
        'cod_client': newCodClient,
        'c_location_id':cLocationId,
        'c_bpartner_location_id': cBparnetLocationId,
      },
      where: 'id = ?',
      whereArgs: [customerId],
    );
    print('Customer updated successfully');
  } else {
    print('Error: db is null');
  }
}