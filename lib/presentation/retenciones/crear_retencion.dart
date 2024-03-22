import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class CrearRetenciones extends StatefulWidget {
  const CrearRetenciones({Key? key}) : super(key: key);

  @override
  State<CrearRetenciones> createState() => _CrearRetencionesState();
}

class _CrearRetencionesState extends State<CrearRetenciones> {
  late List<Map<String, dynamic>> ordenesCompra = [];
  late TextEditingController fechaTransaccionController;
  // Variables para almacenar los valores de los campos de entrada
  TextEditingController totalBdi = TextEditingController(); // Reemplaza 0 con el valor deseado
  TextEditingController numeroDocumento = TextEditingController(); // Reemplaza 0 con el valor deseado
  TextEditingController porcentaje = TextEditingController(); // Reemplaza 0.0 con el valor deseado
  TextEditingController totalImpuesto = TextEditingController(); // Reemplaza 0.0 con el valor deseado
  String? tipoRetencionSeleccionado = ''; // Reemplaza '' con el valor deseado
  String? reglaRetencionSeleccionada = ''; // Reemplaza '' con el valor deseado
  String? valorSeleccionado = ''; 
  String? impuestoValue = '';
  final _formKey = GlobalKey<FormState>();
  FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> ordenesSinRetencion = [];






  Future<void> _loadOrders() async {
    ordenesCompra = await getAllOrdenesCompraWithProveedorNames();

    print("Esto es ordenes de compra $ordenesCompra");
      for (Map<String, dynamic> order in ordenesCompra) {
    bool tieneRetencion = await facturaTieneRetencion(order['id']);
    if (!tieneRetencion) {
      ordenesSinRetencion.add(order);
    }
  }
     print("tiene retencion");
    setState(() {
    }); // Update the UI after loading orders
  }

  @override
  void initState() {
    _loadOrders();
    fechaTransaccionController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));  
          _focusNode.attach(context);

    super.initState();
  }

   @override
  void dispose() {
    fechaTransaccionController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenMax = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        appBar: AppBar(
          title: const Text('Crear Retencion'),
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        ),
        body: ordenesCompra.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Center(
              child: SizedBox(
                  width: screenMax,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: const InputDecoration(labelText: 'Número de Factura', filled: true, fillColor: Colors.white),
                            items: ordenesSinRetencion.map((Map<String, dynamic> order) {
                              return DropdownMenuItem<String>(
                                value: order['id'].toString(),// este es el orden_compra_id
                                child: Text('${order['numero_factura'] as String}  (\$${order['monto']})'),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              // Do something with the selected value
                              
                       bool tieneRetencion = await facturaTieneRetencion(int.parse(newValue!));
                            if (tieneRetencion) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Esta orden ya tiene una retención asociada.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              // Continuar con la lógica de seleccionar la factura
                              setState(() {
                                valorSeleccionado = newValue;
                              });
                              print("Este es el nuevo valor $valorSeleccionado y el order ${ordenesCompra[0]['id']}");
                            }
                              setState(() {
                                  valorSeleccionado = newValue;
                              });
                      
                              print("Este es el nuevo valor $valorSeleccionado y el order ${ordenesCompra[0]['id']}");
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor selecciona el número de factura';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 5,),
                           DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(labelText: 'Impuesto', filled: true, fillColor: Colors.white),
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: '1.75', // Use a String value for consistency with DropdownMenuItem
                                    child: Text('1.75 Renta Bienes'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  // Do something with the selected value (if needed)
                                  setState(() {
                                    impuestoValue = newValue;
                                  });
                                  print('Este es el valor de impuesto que se aplicara $impuestoValue');
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor selecciona el número de factura';
                                  }
                                  return null;
                                },
                              ),
                      
                                const SizedBox(height: 5,),
                      
                                TextField(
                                controller: totalBdi ,
                                decoration: const InputDecoration(
                                  labelText: 'Total Base del Impuesto',
                                  filled: true,
                                  fillColor: Colors.white,
                                
                                ),

                              ),
                              const SizedBox(height: 5,),
                               TextField(
                                controller: fechaTransaccionController,
                                decoration:  const InputDecoration(labelText: 'Fecha Transaccion', filled: true, fillColor: Colors.white),
                              ),
                              const SizedBox(height: 5,),
                               DropdownButtonFormField<String>(
                                isExpanded: true,
                                decoration: const InputDecoration(labelText: 'Tipo Retencion', filled: true, fillColor: Colors.white),
                                items: const [
                                  DropdownMenuItem<String>(
                                    value: 'Retencion renta en compras', // Use a String value for consistency with DropdownMenuItem
                                    child: Text('Retencion renta en compras'),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  // Do something with the selected value (if needed)
                      
                                    setState(() {
                                      tipoRetencionSeleccionado = newValue;
                                    });
                                  print('Este es el valor de impuesto que se aplicara $newValue');
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor selecciona el número de factura';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 5,),
                                 TextField(
                                controller:  numeroDocumento ,
                                onChanged: (value) {
                      
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Nro. del documento',
                                  filled: true,
                                  fillColor: Colors.white,
                      
                                ),
                              ),
                                const SizedBox(height: 5,),
                                 TextField(
                                controller: porcentaje,
                                decoration: const InputDecoration(
                                  labelText: 'Porcentaje',
                                  filled: true,
                                  fillColor: Colors.white,
                      
                                ),
                              ),
                              const SizedBox(height: 5,),
                                 TextField(
                                  controller: totalImpuesto ,
                                decoration: const InputDecoration(
                                  labelText: 'Total del impuesto',
                                  filled: true,
                                  fillColor: Colors.white,
                      
                                ),
                              ),
                              const SizedBox(height: 5,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: SizedBox(
                                child: DropdownButtonFormField<String>(
                                  
                                  isExpanded: true, // Permite que el selector se expanda verticalmente
                                  decoration: const InputDecoration(
                                    labelText: 'Regla Retencion',
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  items: const [
                                    DropdownMenuItem<String>(
                                      
                                      value: '312 Retencion 1.75 % transferencia de bienes',
                                      child: Text(
                                        '312 Retencion 1.75 % transferencia de bienes',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14, // Ajusta el tamaño de fuente según sea necesario
                                        ),
                                      ),
                                    ),
                                  ],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      reglaRetencionSeleccionada = newValue;
                                    });
                                    print('Este es el valor de impuesto que se aplicará: $reglaRetencionSeleccionada');
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor selecciona el número de factura';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),  
                          Center(
                          child: SizedBox(
                            width: screenMax,
                            child: Column(
                              children: [
                                // ...otros widgets aquí
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: double.infinity, // Asegura que el botón ocupe todo el ancho disponible
                                  child: ElevatedButton(
                                    onPressed: ()  {
                                      
                      
                                      Map<String, dynamic> nuevaRetencion = {
                                        'total_bdi': totalBdi.text, 
                                        'impuesto':impuestoValue ,
                                        'fecha_transaccion': fechaTransaccionController.text,
                                        'tipo_retencion': tipoRetencionSeleccionado,
                                        'nro_document': numeroDocumento.text, // Reemplaza numeroDocumento con el valor deseado
                                        'porcentaje': porcentaje.text, // Reemplaza porcentaje con el valor deseado
                                        'total_impuesto': totalImpuesto.text, // Reemplaza totalImpuesto con el valor deseado
                                        'regla_retencion': reglaRetencionSeleccionada,
                                        'orden_compra_id': int.parse(valorSeleccionado!), // Reemplaza valorSeleccionado con el valor deseado
                                      };

                                      setState(() {
                                        
                                       _loadOrders();
                                      });
                                        insertRetencion(nuevaRetencion);
                                        _formKey.currentState?.reset();

                                        totalBdi.clear();
                                        numeroDocumento.clear();
                                        porcentaje.clear();
                                        totalImpuesto.clear();
                      
                                        // Mostrar un mensaje al usuario
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Retención creada exitosamente'),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      Navigator.pop(context);
                                                                      
                                    },
                                    child: const Text('Crear retención'),
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                SizedBox(
                                  width: double.infinity, // Asegura que el botón ocupe todo el ancho disponible
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Acción al hacer clic en el botón "Cancelar"
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ],
                      ),
                    ),
                  ),
                ),
            ),
      ),
    );
  }
}
