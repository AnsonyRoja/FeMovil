import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/cobranzas/cobro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VentasDetails extends StatefulWidget {
  final int ventaId;
  final String nameClient;
  final double saldoTotal;
  const VentasDetails({super.key, required this.ventaId, required this.nameClient, required this.saldoTotal});

  @override
  State<VentasDetails> createState() => _VentasDetailsState();
}

class _VentasDetailsState extends State<VentasDetails> {
  late Future<Map<String, dynamic>> _ventaData;

  @override
  void initState() {
    super.initState();
    _ventaData = _loadVentasForId();
  }

  Future<Map<String, dynamic>> _loadVentasForId() async {
    return await getOrderWithProducts(widget.ventaId);
  }

  @override
  Widget build(BuildContext context) {
            final screenMax = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        title: const Text('Orden de Venta', style: TextStyle(
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
          future: _ventaData,
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final ventaData = snapshot.data!['order'];
              final productsData = snapshot.data!['products'];
              print("Esto es lo que hay productsData ${snapshot.data}");
              print("esto es ventas data $ventaData");
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
                                       Text(ventaData['numero_referencia'], textAlign: TextAlign.start,),
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
                                       Text(ventaData['fecha']),
                                     ],
                                   ),
                                 ),
                                 const Divider(),
                  
                                 Padding(
                                   padding: const EdgeInsets.all(8.0),
                                   child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Text('Cliente'),
                                        const SizedBox(height: 5,),
                                        Text(widget.nameClient),
                                   
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
                                       Text(ventaData['descripcion']),
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
                            return Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                        Expanded(child: Text('${product['name']}',)),
                                        const SizedBox(width: 50,),
                                        Expanded(child: Text(product['cantidad'].toString())),
                                        Expanded(child: Text(product['price'].toString())),
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
                                
                                Text(' \$ ${ventaData['saldo_neto'].toString()}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Monto', style: TextStyle(fontWeight: FontWeight.bold)),
                                
                                Text(' \$ ${ventaData['monto'].toString()}'),
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
                    color: widget.saldoTotal > 0 ? Colors.green: Colors.grey, // Color verde para el fondo del botón
                  ),
                  child: ElevatedButton(
                    onPressed:widget.saldoTotal > 0 ? () {

                        Navigator.of(context).push(
                         MaterialPageRoute(
                            builder: (context) =>  Cobro(orderId: ventaData['id'],saldoTotal: widget.saldoTotal, loadCobranzas: _loadVentasForId),
                          ),
                         );

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
