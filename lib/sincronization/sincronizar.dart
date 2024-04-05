import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/infrastructure/models/impuestos.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:femovil/sincronization/sincronization_screen.dart';




Future<void> syncCustomers( customersData,setState) async {
      final db = await DatabaseHelper.instance.database;
    
       double contador = 0;


      if (db != null) {
        // Itera sobre los datos de los productos recibidos
        for (Map<String, dynamic> customerData in customersData) {
          // Construye un objeto Product a partir de los datos recibidos
          Customer customer = Customer(
              cbPartnerId: customerData['c_bpartner_id'],
              codClient: customerData['cod_client'],
              bpName: customerData['bp_name'].toString(),
              cBpGroupId: customerData['c_bp_group_id'],
              cBpGroupName: customerData['group_bp_name'].toString(),
              lcoTaxIdTypeId: customerData['lco_tax_id_typeid'],
              taxIdTypeName: customerData['tax_id_type_name'].toString(),
              email: customerData['email'].toString(),
              cBparnetLocationId: customerData['c_bpartner_location_id'],
              isBillTo: customerData['is_bill_to'].toString(),
              phone: customerData['phone'].toString(),
              cLocationId: customerData['c_location_id'],
              city: customerData['city'].toString(),
              region: customerData['region'].toString(),
              country: customerData['country'].toString(),
              codePostal: customerData['code_postal'] ?? 0 ,
              cCityId: customerData['c_city_id'],
              cRegionId: customerData['c_region_id'],
              cCountryId: customerData['c_country_id'],
              ruc: customerData['ruc'].toString(),
              address: customerData['address'].toString(),
              lcoTaxPayerTypeId: customerData['lco_tax_payer_typeid'],
              taxPayerTypeName: customerData['tax_payer_type_name'].toString(),
              lvePersonTypeId: customerData['lve_person_type_id'],
              personTypeName: customerData['person_type_name'].toString(),
            
          );
          
            contador++;

         
            
                    setState(() {
                      
                          syncPercentageClient = (contador / customersData.length) * 100;

                    });

          
          
                   


          // Convierte el objeto Product a un mapa
          Map<String, dynamic> customerMap = customer.toMap();


          // Consulta si el producto ya existe en la base de datos local por su nombre
          List<Map<String, dynamic>> existingCustomer= await db.query(
            'clients',
            where: 'bp_name = ?',
            whereArgs: [customer.bpName],
          );

          if (existingCustomer.isNotEmpty) {
            // Si el producto ya existe, actualiza sus datos
            await db.update(
              'clients',
              customerMap,
              where: 'bp_name = ?',
              whereArgs: [customer.bpName],
            );
            print('cliente actualizado: ${customer.bpName}');
          } else {
            // Si el producto no existe, inserta un nuevo registro en la tabla de productos
            await db.insert('clients', customerMap);
            print('cliente insertado: ${customer.bpName}');
          }
        }
        print('Sincronización de Impuestos completada.');
      } else {
        // Manejar el caso en el que db sea null
        print('Error: db is null');
      }
    }



Future<void> syncImpuestos(List<Map<String, dynamic>> impuestosData,setState) async {
      final db = await DatabaseHelper.instance.database;
    
       double contador = 0;



      if (db != null) {
        // Itera sobre los datos de los productos recibidos
        for (Map<String, dynamic> impuestoData in impuestosData) {
          // Construye un objeto Product a partir de los datos recibidos
          Impuesto impuesto = Impuesto(
            cTaxCategoryId: impuestoData['c_tax_category_id'],
            cTaxId: impuestoData['c_tax_id'],
            isWithHolding: impuestoData['iswithholding'].toString(),
            name: impuestoData['name'].toString(),
            rate: impuestoData['rate'],
            taxIndicators: impuestoData['tax_indicator'].toString(),
            
            
          );
          
            contador++;

            
                    setState(() {
                      
                              syncPercentageImpuestos = (contador / impuestosData.length) * 100;
                    });

                   



          // Convierte el objeto Product a un mapa
          Map<String, dynamic> impuestoMap = impuesto.toMap();


          // Consulta si el producto ya existe en la base de datos local por su nombre
          List<Map<String, dynamic>> existingImpuesto= await db.query(
            'tax',
            where: 'name = ?',
            whereArgs: [impuesto.name],
          );

          if (existingImpuesto.isNotEmpty) {
            // Si el producto ya existe, actualiza sus datos
            await db.update(
              'tax',
              impuestoMap,
              where: 'name = ?',
              whereArgs: [impuesto.name],
            );
            print('Producto actualizado: ${impuesto.name}');
          } else {
            // Si el producto no existe, inserta un nuevo registro en la tabla de productos
            await db.insert('tax', impuestoMap);
            print('Producto insertado: ${impuesto.name}');
          }
        }
        print('Sincronización de Impuestos completada.');
      } else {
        // Manejar el caso en el que db sea null
        print('Error: db is null');
      }
    }




Future<void> syncProducts(List<Map<String, dynamic>> productsData,setState) async {
      final db = await DatabaseHelper.instance.database;
    
       double contador = 0;



      if (db != null) {
        // Itera sobre los datos de los productos recibidos
        for (Map<String, dynamic> productData in productsData) {
          // Construye un objeto Product a partir de los datos recibidos
          Product product = Product(
            mProductId: productData['m_product_id'].toString(),
            productType: productData['product_type'].toString(),
            productTypeName: productData['product_type_name'].toString(),
            codProd: productData['cod_product'].toString(),
            prodCatId: productData['pro_cat_id'].toString(),
            taxName: productData['tax_cat_name'].toString(),
            productGroupId: productData['product_group_id'].toString(),
            produtGroupName: productData['product_group_name'].toString(),
            umId: productData['um_id'].toString(),
            umName: productData['um_name'].toString(),
            name: productData['name'].toString(),
            price: productData['price'],
            quantity: productData['quantity'] is int ? productData['quantity']: 0,
            categoria: productData['categoria'].toString(),
            qtySold: productData['total_sold'].toString(),
            taxId: productData['tax_cat_id'].toString(),
            priceListSales: productData['pricelistsales'],
          );
          
            contador++;

            
                    setState(() {
                      
                              syncPercentage = (contador / productsData.length) * 100;
                    });

                   



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



     