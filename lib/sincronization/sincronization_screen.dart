import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:femovil/presentation/products/idempiere/create_product.dart';
import 'package:femovil/presentation/products/products_http.dart';
import 'package:femovil/sincronization/https/customer_http.dart';
import 'package:flutter/material.dart';

  double syncPercentage = 0.0; // Estado para mantener el porcentaje sincronizado
  double syncPercentageClient = 0.0;
  double syncPercentageProviders = 0.0;
  double syncPercentageSelling = 0.0;
  double syncPercentageImpuestos = 0.0;


class SynchronizationScreen extends StatefulWidget {
  const SynchronizationScreen({Key? key}) : super(key: key);



  @override
  _SynchronizationScreenState createState() => _SynchronizationScreenState();
}

class _SynchronizationScreenState extends State<SynchronizationScreen> {
GlobalKey<_SynchronizationScreenState> synchronizationScreenKey = GlobalKey<_SynchronizationScreenState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: synchronizationScreenKey,
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        title: const Text('Synchronization'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.topCenter,
            child: ElevatedButton(
              onPressed: () {
                // Llamada a la función de sincronización
                setState(() {
                syncPercentage = 0;
                getPosPropertiesInit();
                  sincronizationCustomers(setState);
                  // sincronizationImpuestos(setState);
                  syncPercentageClient = 0;
                  syncPercentageImpuestos = 0;
                // synchronizeProductsWithIdempiere(setState);
                });
           
              },
              child: const Text('Sincronizar'),
            ),
          ),
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Productos'),
                      Container(
            width: 150,
            height: 20, // Altura del contenedor
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo inicial
              border: Border.all(color: Colors.green), // Borde verde
              borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                  width: 150 * (syncPercentage / 100), // Ancho dinámico del contenedor verde
                ),
                Center(
                  child: Text(
                    '${syncPercentage.toStringAsFixed(1)} %', // Porcentaje visible
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ),
                  ),
                ),
              ],
            ),
          ),
                    // Ícono de check para mostrar que la sincronización fue exitosa
                    syncPercentage == 100.0
                        ? const Icon(Icons.check, color: Colors.green)
                        : const SizedBox(),
                  ],
                ),

                
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Clientes'),
                          Container(
                width: 150,
                height: 20, // Altura del contenedor
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo inicial
                  border: Border.all(color: Colors.green), // Borde verde
                  borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                      width: 150 * (syncPercentageClient / 100), // Ancho dinámico del contenedor verde
                    ),
                    Center(
                      child: Text(
                        '${syncPercentageClient.toStringAsFixed(1)} %', // Porcentaje visible
                        style: const TextStyle(
                          color: Colors.black, // Color del texto
                          fontWeight: FontWeight.bold, // Fuente en negrita
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              syncPercentageClient == 100.0
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Proveedores'),
                      Container(
            width: 150,
            height: 20, // Altura del contenedor
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo inicial
              border: Border.all(color: Colors.green), // Borde verde
              borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                  width: 150 * (syncPercentageProviders / 100), // Ancho dinámico del contenedor verde
                ),
                Center(
                  child: Text(
                    '${syncPercentageProviders.toStringAsFixed(1)} %', // Porcentaje visible
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ),
                  ),
                ),
              ],
            ),
          ),
                    // Ícono de check para mostrar que la sincronización fue exitosa
                    syncPercentageProviders == 100.0
                        ? const Icon(Icons.check, color: Colors.green)
                        : const SizedBox(),
                  ],
                ),

                
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Ventas'),
                          Container(
                width: 150,
                height: 20, // Altura del contenedor
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo inicial
                  border: Border.all(color: Colors.green), // Borde verde
                  borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                      width: 150 * (syncPercentageSelling / 100), // Ancho dinámico del contenedor verde
                    ),
                    Center(
                      child: Text(
                        '${syncPercentageSelling.toStringAsFixed(1)} %', // Porcentaje visible
                        style: const TextStyle(
                          color: Colors.black, // Color del texto
                          fontWeight: FontWeight.bold, // Fuente en negrita
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              syncPercentageSelling == 100.0
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Impuestos'),
                      Container(
            width: 150,
            height: 20, // Altura del contenedor
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo inicial
              border: Border.all(color: Colors.green), // Borde verde
              borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                  width: 150 * (syncPercentageImpuestos / 100), // Ancho dinámico del contenedor verde
                ),
                Center(
                  child: Text(
                    '${syncPercentageImpuestos.toStringAsFixed(1)} %', // Porcentaje visible
                    style: const TextStyle(
                      color: Colors.black, // Color del texto
                      fontWeight: FontWeight.bold, // Fuente en negrita
                    ),
                  ),
                ),
              ],
            ),
          ),
                    // Ícono de check para mostrar que la sincronización fue exitosa
                    syncPercentageImpuestos == 100.0
                        ? const Icon(Icons.check, color: Colors.green)
                        : const SizedBox(),
                  ],
                ),

                
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Ventas'),
                          Container(
                width: 150,
                height: 20, // Altura del contenedor
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo inicial
                  border: Border.all(color: Colors.green), // Borde verde
                  borderRadius: BorderRadius.circular(5.0), // Bordes redondeados
                ),
                child: Stack(
                  children: [
                    Container(
                      color: Colors.green.withOpacity(0.5), // Opacidad del contenedor verde
                      width: 150 * (syncPercentageSelling / 100), // Ancho dinámico del contenedor verde
                    ),
                    Center(
                      child: Text(
                        '${syncPercentageSelling.toStringAsFixed(1)} %', // Porcentaje visible
                        style: const TextStyle(
                          color: Colors.black, // Color del texto
                          fontWeight: FontWeight.bold, // Fuente en negrita
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              syncPercentageSelling == 100.0
                            ? const Icon(Icons.check, color: Colors.green)
                            : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }


  
}


  synchronizeProductsWithIdempiere(setState) async {

                List<Map<String, dynamic>> productsWithZeroValues = await getProductsWithZeroValues();
    
                await sincronizationProducts(setState);
  

                for (var productData in productsWithZeroValues) {

                  Product product = Product(
                    mProductId: productData['m_product_id'],
                    productType: productData['product_type'],
                    productTypeName: productData['product_type_name'],
                    codProd: productData['cod_product'],
                    prodCatId: productData['pro_cat_id'],
                    taxName: productData['tax_cat_name'],
                    productGroupId: productData['product_group_id'],
                    produtGroupName: productData['product_group_name'],
                    umId: productData['um_id'],
                    umName: productData['um_name'],
                    name: productData['name'],
                    price: productData['price'],
                    quantity: productData['quantity'],
                    categoria: productData['categoria'],
                    qtySold: productData['total_sold'],
                    taxId: productData['tax_cat_id'],
                  );



                       dynamic result = await createProductIdempiere(product.toMap());
                           print('este es el $result');
                       
                    final mProductId = result['StandardResponse']['outputFields']['outputField'][0]['@value'];
                    final codProdc = result['StandardResponse']['outputFields']['outputField'][1]['@value'];
                    print('Este es el mp product id $mProductId && el codprop $codProdc');
                    // Limpia los controladores de texto después de guardar el producto

                    await updateProductMProductIdAndCodProd(productData['id'], mProductId, codProdc);
                  

                }

}



