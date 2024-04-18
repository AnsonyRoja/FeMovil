import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/presentation/cobranzas/cobro.dart';
import 'package:femovil/presentation/screen/compras/idempiere/create_order_purchase.dart';
import 'package:femovil/presentation/screen/ventas/idempiere/create_orden_sales.dart';
import 'package:flutter/material.dart';

class ComprasDetails extends StatefulWidget {
  final int compraId;
  final String nameProveedor;
  const ComprasDetails({super.key, required this.compraId, required this.nameProveedor});

  @override
  State<ComprasDetails> createState() => _ComprasDetailsState();
}

class _ComprasDetailsState extends State<ComprasDetails> {
  late Future<Map<String, dynamic>> _compraData;
  dynamic comprasDate = {};


  initComprasDatas() async {

      dynamic respuesta = await _loadComprasForId();

      print('Esta es la respuesta $respuesta');

  }

  @override
  void initState() {
    super.initState();
    _compraData = _loadComprasForId();

    print('Este es el id de la orden ${widget.compraId} && este es el nombre del proveedor ${widget.nameProveedor}');

    initComprasDatas();

    _loadOrdenesConLineas();

  }

  _updateAndCreateOrders() async {

   dynamic isTrue = await createOrdenPurchaseIdempiere(comprasDate);

              if(isTrue == false){
                return false;
              }else{
                return true;
              }
                            
  }


   _loadOrdenesConLineas() async {

     dynamic response = await obtenerOrdenDeCompraConLineasPorId(widget.compraId);

                setState(() {

                    comprasDate = response;

                });

        print('Estas son las ordenes de ventas con sus respectivas lineas $response');
        
      
  }


  Future<Map<String, dynamic>> _loadComprasForId() async {
  
    return await getOrderPurchaseWithProducts(widget.compraId);
  
  }

  @override
  Widget build(BuildContext context) {
            final screenMax = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        title: const Text('Orden de Compra', style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 102, 102),
          ),),
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
                iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),

      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: FutureBuilder(
          future: _compraData,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final compraData = snapshot.data!['order'];
              final productsData = snapshot.data!['products'];
              print("Esto es lo que hay productsData ${snapshot.data}");
              print("esto es ventas data $compraData");
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
 
                      Container(
                        width: screenMax ,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                        child: const Text('Datos Del Cliente', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                      ),
                        const SizedBox(height: 10,),
                       Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                        width: screenMax ,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto hacia la izquierda  
                            children: [
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                      const Text("N°"),
                                      const SizedBox(height: 5,),
                                       Text( compraData['documentno']  != '' ? compraData['documentno'].toString(): compraData['id'].toString(), textAlign: TextAlign.start,),
                                     ],
                                   ),
                                 ),
                                 const Divider(),
                  
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                      const Text('Fecha'),
                                      const SizedBox(height: 5,),
                                       Text(compraData['fecha']),
                                     ],
                                   ),
                                 ),
                                 const Divider(),
                  
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Text('Proveedor'),
                                        const SizedBox(height: 5,),
                                        Text(widget.nameProveedor),
                                   
                                    ],
                                   ),
                                 ), 
                                 const Divider(),
                          
                        
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       const Text('Descripción'),
                                       const SizedBox(height: 5,),
                                       Text(compraData['description']),
                                     ],
                                   ),
                                 ),
        
                                 const Divider(),

                            
                          
                          ],),
                        ) ,
                      ),
                  
                     
                      const SizedBox(height: 10),
                      Container(
                        width: screenMax,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                        child: const Text('Productos', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                       const SizedBox(height: 10),
        
                        Container(
                        width: screenMax,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                Text('Cantidad', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                Text('Precio', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                Text('Impuesto', textAlign: TextAlign.start, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),

                              ],
                            ),
                          ),
                        )),
                               const SizedBox(height: 10),

                      Container(
                        width: screenMax,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                        child: ListView.builder(
                          
                          shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(), // Deshabilita el desplazamiento

                          itemCount: productsData.length,
                          itemBuilder: (context, index) {
                            final product = productsData[index];
                            print('Estos son los productos $product');
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: Text('${product['name']}',)),
                                        const SizedBox(width: 50,),
                                        Expanded(child: Text(product['qty_entered'].toString())),
                                        Expanded(child: Text(product['price_actual'].toString())),
                                        const SizedBox(width: 15,),
                                        Expanded(child: Text('${product['impuesto'].toString()}%'))
                                        
                                    ] 
                                                         
                                  ),
                                 const Divider(),

                                ],
                              ),
                              
                            );
                            
                          },
                        ),
                      ),
                      const SizedBox(height: 10,),
                    Container(
                      width: screenMax,
                     decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                        ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Saldo Neto', style: TextStyle(fontWeight: FontWeight.bold)),
                                
                                Text(' \$ ${compraData['saldo_neto'].toString()}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Monto', style: TextStyle(fontWeight: FontWeight.bold)),
                                
                                Text(' \$ ${compraData['monto'].toString()}'),
                              ],
                            ),
                          ],
                        ),
                      )),
                const SizedBox(height: 10,),
                  Container(
                  width: screenMax,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: compraData['status_sincronized'] == 'Borrador' ? Colors.green:Colors.grey, // Color verde para el fondo del botón
                  ),
                  child: ElevatedButton(
                    onPressed:compraData['status_sincronized'] == 'Borrador' ? ()  {

                        String newValue = 'Completado';
                        updateOrderePurchaseForStatusSincronzed(compraData['id'], newValue );

                        setState(() {
                          
                        _compraData =  _loadComprasForId();
                        });


                    }: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Hace que el color de fondo del botón sea transparente
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Completar',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para que se destaque sobre el fondo verde
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                   Container(
                  width: screenMax,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: compraData['status_sincronized'] == 'Borrador' ? Colors.green:Colors.grey, // Color verde para el fondo del botón
                  ),
                  child: ElevatedButton(
                    onPressed:compraData['status_sincronized'] == 'Borrador' ? ()  async{


                     dynamic isTrue =  await _updateAndCreateOrders();


                            if(isTrue != false){
                              String newValue = 'Enviado';
                              updateOrderePurchaseForStatusSincronzed(compraData['id'], newValue );

                            }else{
                              String newValue = 'Por Enviar';

                              updateOrderePurchaseForStatusSincronzed(compraData['id'], newValue );


                            }

                        if(mounted){

                        setState(() {
                          
                          _compraData =  _loadComprasForId();

                        });

                        }


                    }: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Hace que el color de fondo del botón sea transparente
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Comp y Enviar',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para que se destaque sobre el fondo verde
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                     Container(
                  width: screenMax,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: compraData['status_sincronized'] == 'Completado' || compraData['status_sincronized'] == 'Por Enviar'  ? Colors.green:Colors.grey, // Color verde para el fondo del botón
                  ),
                  child: ElevatedButton(
                    onPressed:compraData['status_sincronized'] == 'Completado' ||  compraData['status_sincronized'] == 'Por Enviar'  ? () async {
                        
                       dynamic isTrue =  await _updateAndCreateOrders();


                          if(isTrue != false){

                        String newValue = 'Enviado';
                        updateOrderePurchaseForStatusSincronzed(compraData['id'], newValue );
                        
                          }else{

                               String newValue = 'Por Enviar';
                        updateOrderePurchaseForStatusSincronzed(compraData['id'], newValue );
                        

                          } 

                          if(mounted){

                        setState(() {
                          
                         _compraData =  _loadComprasForId();

                        });

                        }


                    }: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Hace que el color de fondo del botón sea transparente
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Enviar',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para que se destaque sobre el fondo verde
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15,),
                Container(
                  width: screenMax,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:  compraData['status_sincronized'] == 'Completado' || compraData['status_sincronized'] == 'Enviado' ? Colors.green: Colors.grey, // Color verde para el fondo del botón
                  ),
                  child: ElevatedButton(
                    onPressed: compraData['status_sincronized'] == 'Completado' || compraData['status_sincronized'] == 'Enviado' ? () {

                        // Navigator.of(context).push(
                        //  MaterialPageRoute(
                        //     builder: (context) =>  Cobro(orderId: compraData['id'],saldoTotal:, loadCobranzas: _loadVentasForId),
                        //   ),
                        //  );

                    }: null,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // Hace que el color de fondo del botón sea transparente
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        'Cobrar',
                        style: TextStyle(
                          color: Colors.white, // Texto blanco para que se destaque sobre el fondo verde
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
