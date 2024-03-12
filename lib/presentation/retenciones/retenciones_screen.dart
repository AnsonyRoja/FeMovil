import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/retenciones/crear_retencion.dart';
import 'package:flutter/material.dart';





class Retenciones extends StatefulWidget {

  const Retenciones({super.key});

  @override
  State<Retenciones> createState() => _RetencionesState();
  
}




class _RetencionesState extends State<Retenciones> {

      TextEditingController searchController = TextEditingController();
        List<Map<String, dynamic>> filteredRetenciones = [];

            Future<void>  _loadWithholdings() async{ 

                      List<Map<String, dynamic>> retenciones = await DatabaseHelper.instance.getRetencionesWithProveedorNames();

                  setState(() {
                  filteredRetenciones = retenciones;
                    
                  });

                  print('Estos son las retenciones $retenciones');
            }     


          @override
  void initState() {


      _loadWithholdings();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      final screenSize = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 247, 255),
            appBar: AppBar(title: const Text('Retenciones'),
            backgroundColor: const Color.fromARGB(255, 236, 247, 255)),
            body: GestureDetector(
              onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());

              },
              child:  Column(
                
                children: [
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                              //     if (searchController.text.isNotEmpty) {
                              //       setState(() {
                              //         _filter = "";
                              //       });
                              //     }
                              //     setState(() {
                              //   filteredRetenciones = retencions.where((retencion) {
                              //   final numeroReferencia = retencion['numero_referencia'].toString();
                              //   final nombreCliente = retencion['nombre_cliente'].toString();
                              //   return numeroReferencia.contains(value) || nombreCliente.contains(value);
                              // }).toList();
                              // });
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Buscar por numero, orden de compra',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                      ),
                      Expanded(
                child: ListView.builder(
                  itemCount: filteredRetenciones.length,
                  itemBuilder: (context, index) {
                    final retencion = filteredRetenciones[index];
                    return Column(
                      children: [
                        Container(  

                          width: screenSize,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("N° ${retencion['nro_document']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                        ),
                        const SizedBox(height: 7),
                         Container(
                          width: screenSize,
                           decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10.0), // Radio de borde de 10.0
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Proveedor: ${retencion['nombre_proveedor']}'),
                                Text('Numero de Factura: ${retencion['numero_factura']}'),
                                Text('Fecha:  ${retencion['fecha_transaccion']}'),
                                Text('Tipo de Retencion:  ${retencion['tipo_retencion']}'),
                                Text('Monto: ${retencion['monto']} ')
                                // Text('Descripcion: ${retencion['descripcion']}'),
                                // aqui quiero agregar los dos botones con space betwenn 
                                     
                              ],
                            ),
                          ),
                        ),
                           const SizedBox(height: 5,),
                        //   Container(
                        //     width: screenSize,
                        //     child:  ElevatedButton(
                        //       style: ButtonStyle(
                        //         backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        //         foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        //       ),
                        //       onPressed: () {

                        //           Navigator.of(context).push(
                        //             MaterialPageRoute(
                        //               builder: (context) => RetencionesDetails(retenciones: filteredRetenciones),
                        //             ),
                        //           );
                        //       },
                        //       child: const Text('Ver más'),
                        //     ),

                        // ),  
                                                const SizedBox(height: 5,),

                 
                      ],
                    );
                  },
                ),
              ),
              
                ],
              
              ),
            ),
            bottomNavigationBar: Container(
              width: double.infinity, // Ancho máximo igual al ancho total de la pantalla
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), // Ajusta el radio de los bordes superiores izquierdos según sea necesario
                  topRight: Radius.circular(20), // Ajusta el radio de los bordes superiores derechos según sea necesario
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Color de la sombra
                    spreadRadius: 5, // Radio de expansión de la sombra
                    blurRadius: 15, // Radio de desenfoque de la sombra
                    offset: const Offset(0, 5), // Desplazamiento de la sombra
                  ),
                ],
              ),
              child: BottomAppBar(
                shape:  const CircularNotchedRectangle(), // Utilizamos CircularNotchedRectangle para crear una forma de muesca redondeada

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CrearRetenciones()),
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: "btn3",
                      onPressed: () {
                          _loadWithholdings();
                      },
                      child: const Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 20),
                    FloatingActionButton(
                      heroTag: "btn4",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        child: const Icon(Icons.arrow_back),
                        ),
                      ],
                    ),
                  ),
                ),
      );  
  }
}

