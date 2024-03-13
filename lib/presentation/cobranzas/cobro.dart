import 'package:femovil/database/create_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';






class Cobro extends StatefulWidget {
  final int orderId;
  final double saldoTotal;
  final Function loadCobranzas;
  
  const Cobro({super.key, required this.orderId, required this.saldoTotal, required this.loadCobranzas});

  @override
  State<Cobro> createState() => _CobroState();
}


class _CobroState extends State<Cobro> {
  late Future<Map<String, dynamic>> _ordenVenta;
  TextEditingController numRefController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  String? paymentTypeValue = 'Efectivo';
  String? coinValue = "\$";
  String? typeDocumentValue = "Cobro";
  String? bankAccountValue = "123456";



void _loadCurrentDate() {
  final now = DateTime.now();
  final formattedDate = DateFormat('dd/MM/yyyy').format(now);
  dateController.text = formattedDate; // Asigna la fecha actual al controlador del campo de texto
}


@override
void initState() {

  _ordenVenta =  _loadOrdenVentasForId();
  _loadCurrentDate();
  super.initState();
  
}

 Future<Map<String, dynamic>> _loadOrdenVentasForId() async {
    return await DatabaseHelper.instance.getOrderWithProducts(widget.orderId);
  }
  @override
  Widget build(BuildContext context) {
           final screenMax = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      
            appBar: AppBar(title: const Text("Cobro"),
                  backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      
            ),
      
            body: FutureBuilder(
                    future: _ordenVenta,
                    builder: (context,  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
      
                          } else if (snapshot.hasError) {
                            
                            return Text('Error: ${snapshot.error}');
      
                          }else{
                              final clientData = snapshot.data!['client'][0];
                              final orderData = snapshot.data!['order'];
                              print("Esto es snapshot data ${snapshot.data}");
      
                           return  Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Align(
                                alignment: Alignment.topCenter,
                               child: SingleChildScrollView(
                                 child: Column(
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                  children: [
                                  Container(
                                      width: screenMax ,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                                      ),
                                      child: const Text('Datos De la Orden', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                    ),
                                  const SizedBox(height: 10,),
                                    Column(
                                      children: [
                                        Container(
                                          width: screenMax,
                                          decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          
                                          ),
                                          child:  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                          child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                               CustomTextInfo(
                                                 label: "N°",
                                                 value: orderData['numero_referencia'],
                                               ),
                                               CustomTextInfo(
                                                 label: "Cliente",
                                                 value: clientData['name'],
                                               ),
                                               CustomTextInfo(
                                                 label: "Ruc",
                                                 value: clientData['ruc'].toString(),
                                               ),
                                                CustomTextInfo(
                                                 label: "Saldo Total",
                                                 value: widget.saldoTotal.toString(),
                                               ),
                                            
                                            
                                                                                      ],
                                                                                      ),
                                                                                    ),
                                          ),
                                        ),
                                      const SizedBox(height: 10,),
                                       Container(
                                        width: screenMax ,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                                        ),
                                        child: const Text('Cobranza', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                       ),
                                      const SizedBox(height: 10,),
                                        Container(
                                          width: screenMax,
                                          decoration: BoxDecoration(
                                              color:  Colors.white,
                                              borderRadius:  BorderRadius.circular(8),
                                          ),
                                            child:  Column(
                                 
                                                children: [
                                                  TextFormField(  
                                                      
                                                      controller: numRefController,
                                 
                                                      onChanged: (value) {
                                 
                                                        
                                 
                                                      },
                                                       decoration: const InputDecoration(
                                                      labelText: 'Número de Referencia', // Etiqueta que se muestra sobre el campo
                                                      contentPadding: EdgeInsets.all(15)
                                                      ),
                                 
                                                  ), 
                                                DropdownButtonFormField<String>(
                                                    value: 'Cobro', // Valor predeterminado
                                                    onChanged: (String? newValue) {
                                                      // Aquí puedes realizar alguna acción cuando cambie la selección
                                                            setState(() {
                                                              typeDocumentValue = newValue;
                                                            });

                                                        print("Esto es el valor del select Cobro  $newValue");
                                                    },
                                                    items: <String>['Cobro'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Tipo de Documento', // Etiqueta que se muestra sobre el campo
                                                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5), // Estilo de la etiqueta con un margen inferior
                                                      contentPadding: EdgeInsets.all(15),
                                                    ),
                                                  ),
                                                  DropdownButtonFormField<String>(
                                                    value: 'Efectivo', // Valor predeterminado
                                                    onChanged: (String? newValue) {
                                                      setState(() {
                                                        paymentTypeValue = newValue;
                                                      });
                                                    },
                                                    items: <String>['Efectivo'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Tipo de Pago', // Etiqueta que se muestra sobre el campo
                                                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5), // Estilo de la etiqueta con un margen inferior
                                                      contentPadding: EdgeInsets.all(15),
                                                    ),
                                                  ),

                                              TextFormField(
                                                readOnly: true,
                                                controller: dateController,
                                                decoration: const InputDecoration(
                                                  labelText: "Fecha",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),
                                                 DropdownButtonFormField<String>(
                                                    value: '\$', // Valor predeterminado
                                                    onChanged: (String? newValue) {
                                                      // Aquí puedes realizar alguna acción cuando cambie la selección
                                                    },
                                                    items: <String>['\$'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Moneda', // Etiqueta que se muestra sobre el campo
                                                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5), // Estilo de la etiqueta con un margen inferior
                                                      contentPadding: EdgeInsets.all(15),
                                                    ),
                                                  ),

                                              TextFormField(
                                                controller: montoController,
                                                decoration: const InputDecoration(
                                                  labelText: "Monto",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),

                                                  DropdownButtonFormField<String>(
                                                    value: '123456', // Valor predeterminado
                                                    onChanged: (String? newValue) {
                                                      // Aquí puedes realizar alguna acción cuando cambie la selección

                                                      setState(() {
                                                        bankAccountValue = newValue;
                                                      });
                                                    
                                                    },
                                                    items: <String>['123456'].map((String value) {
                                                      return DropdownMenuItem<String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    decoration: const InputDecoration(
                                                      labelText: 'Cuenta Bancaria', // Etiqueta que se muestra sobre el campo
                                                      labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5), // Estilo de la etiqueta con un margen inferior
                                                      contentPadding: EdgeInsets.all(15),
                                                    ),
                                                  ),

                                                    TextFormField(
                                                controller: observacionController,
                                                decoration: const InputDecoration(
                                                  labelText: "Observacion",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),

            
                                                ],
                                 
                                            ),
                                 
                                        ),  
                                          const SizedBox(height: 10,),
                                        // Aqui va el boton
                                              ElevatedButton(
                                                onPressed:  () async {
                                                  // Aquí puedes agregar la lógica para crear el cobro
                                                           await _createCobro(widget.loadCobranzas);
  
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.green, // Color de fondo verde
                                                  minimumSize: Size(screenMax, 50), // Ancho máximo y altura de 50
                                                ),
                                                child: const Text(
                                                  'Crear Cobro',
                                                  style: TextStyle(fontSize: 16), // Tamaño de fuente 16
                                                ),
                                              ),
                                                                              
                                      ],
                                    ),
                                                            
                                 ],                        
                                                             ),
                               ),
                             ),
                           );
                        }
                    }, 
      
            ),
      
      ),
    );
  }

 Future<void> _createCobro(loadCobranzas) async {
  final int numberReference = int.parse(numRefController.text);
  final String? typeDocument = typeDocumentValue;
  final String? paymentType = paymentTypeValue;
  final String date = dateController.text;
  final String? coin = coinValue;
  final int amount = int.parse(montoController.text);
  final String? bankAccount = bankAccountValue;
  final String observation = observacionController.text;
  final int saleOrderId = widget.orderId;

  // Obtener el saldo total de la orden
  final double saldoTotal = widget.saldoTotal;

  if (amount > saldoTotal) {
    // Si el monto del cobro es mayor al saldo total, mostrar mensaje de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('El cobro no puede ser mayor al saldo total de la orden.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  } else {
    // Si el monto del cobro es menor o igual al saldo total, insertar el cobro en la base de datos
    await DatabaseHelper.instance.insertCobro(
      numberReference: numberReference,
      typeDocument: typeDocument,
      paymentType: paymentType,
      date: date,
      coin: coin,
      amount: amount,
      bankAccount: bankAccount,
      observation: observation,
      saleOrderId: saleOrderId,
    );

    loadCobranzas();

    // Limpiar los campos de texto después de insertar el cobro
    numRefController.clear();
    montoController.clear();
    observacionController.clear();

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cobro creado con éxito')));
  }
}


}




class CustomTextInfo extends StatelessWidget {
  final String label;
  final String value;

  const CustomTextInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5,),
        Text(value),
        const Divider(),
      ],
    );
  }
}
