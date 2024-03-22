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
            m_product_id INTEGER,
            name TEXT,
            quantity INTEGER,
            price REAL,
            product_type STRING,
            product_type_name STRING,
            pro_cat_id INTEGER,
            categoria TEXT,
            tax_cat_id INTEGER,
            tax_cat_name STRING,
            product_group_id INTEGER,
            product_group_name STRING,
            um_id INTEGER,
            um_name STRING,
            quantity_sold INTEGER,
            FOREIGN KEY(tax_cat_id) REFERENCES tax(id)

          )
        ''');
      await db.execute('''

        CREATE TABLE clients(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            c_bpartner_id INTEGER,
            cod_client INTEGER,
            bp_name TEXT,
            c_bp_group_id INTEGER,
            group_bp_name STRING,
            lco_tax_id_typeid INTEGER,
            tax_id_type_name STRING,
      
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
          c_tax_id INTEGER,
          tax_indicator STRING,
          rate REAL,
          name TEXT,
          c_tax_category_id INTEGER,
          iswithholding TEXT
          )
        ''');

      },
    );

    return database;
  }




  }