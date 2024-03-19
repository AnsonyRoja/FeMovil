import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/products.dart';


Future<void> syncProducts(List<Map<String, dynamic>> productsData) async {
      final db = await DatabaseHelper.instance.database;
      if (db != null) {
        // Itera sobre los datos de los productos recibidos
        for (Map<String, dynamic> productData in productsData) {
          // Construye un objeto Product a partir de los datos recibidos
          Product product = Product(
            mProductId: productData['m_product_id'],
            productType: productData['product_type'],
            productTypeName: productData['product_type_name'],
            codProd: productData['cod_product'],
            prodCatId: productData['pro_cat_id'],
            taxName: productData['tax_cat_name'],
            umId: productData['um_id'] ,
            umName: productData['um_name'],
            name: productData['name'],
            price: productData['price'],
            quantity: productData['quantity'],
            categoria: productData['categoria'],
            qtySold: productData['total_sold'],
            taxId: productData['tax_cat_id'],
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


     Future<List<Map<String, dynamic>>> listarCategorias() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
              SELECT DISTINCT pro_cat_id, categoria
              FROM products
            ''');
          }
          return []; 
        }


        Future<List<Map<String, dynamic>>> listarUnidadesDeMedida() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT um_id, um_name
               FROM products
            ''');
          }
          return [];
        }

        Future<List<Map<String, dynamic>>> listarImpuestos() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT tax_cat_id, tax_cat_name
               FROM products
            ''');
          }
          return [];
        }

                Future<List<Map<String, dynamic>>> listarProductType() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT product_type, product_type_name
               FROM products
            ''');
          }
          return [];
        }


          