
     import 'package:femovil/database/create_database.dart';

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

          Future<List<Map<String, dynamic>>> listarProductGroup() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT product_group_id, product_group_name
               FROM products
            ''');
          }
          return [];
        }

           Future<List<Map<String, dynamic>>> listarCountryGroup() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT c_country_id, country
               FROM clients
            ''');
          }
          return [];
        }

         Future<List<Map<String, dynamic>>> listarGroupTercero() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT c_bp_group_id, group_bp_name
               FROM clients
            ''');
          }
          return [];
        }

        // Listar tax type es el tipo de impuesto

      Future<List<Map<String, dynamic>>> listarTaxType() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT lco_tax_id_typeid, tax_id_type_name
               FROM clients
            ''');
          }
          return [];
        }

        // Tax payer es el tipo de constribuyente 
        // Person type es el tipo de persona 

      Future<List<Map<String, dynamic>>> listarTaxPayer() async {
          final db = await DatabaseHelper.instance.database;
          if(db != null) {
            return await db.rawQuery('''
            SELECT DISTINCT lco_tax_payer_typeid, tax_payer_type_name
               FROM clients
            ''');
          }
          return [];
        }