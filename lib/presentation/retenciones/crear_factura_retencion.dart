import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  TextEditingController totalBdi = TextEditingController(); 
  TextEditingController numeroDocumentoController = TextEditingController(); 
  TextEditingController porcentaje = TextEditingController(); 
  TextEditingController totalImpuesto = TextEditingController(); 
  TextEditingController numeroFacturaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaFacturacionController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? tipoRetencionSeleccionado = ''; 
  String? reglaRetencionSeleccionada = ''; 
  String? valorSeleccionado = ''; 
  String? impuestoValue = '';
  final _formKey = GlobalKey<FormState>();
 final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> ordenesSinRetencion = [];
    int? _selectedTercero; 
  Future? _terceros ;
  AsyncSnapshot<dynamic>? _tercerosSnapshot;
   List<dynamic>? filteredTerceros;





  @override
  void initState() {

setState(() {
  
   _terceros =  getClients();
});



    fechaTransaccionController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(DateTime.now()));  
          _focusNode.attach(context);
    fechaFacturacionController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
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
          title: const Text('Factura con Retencion'),
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        ),
        body: Center(
              child: SizedBox(
                  width: screenMax,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [

                              TextField(
                                  controller: numeroDocumentoController,
                                  decoration: const InputDecoration(labelText: 'Numero de documento', filled: true, fillColor: Colors.white ) ,
                              ),
                              const SizedBox(height: 10,),
                              TextField(
                                controller: numeroFacturaController,
                                decoration:  const InputDecoration(labelText: 'Numero de Factura', fillColor: Colors.white, filled: true),
                              ),  
                              const SizedBox(height: 10,),
                              TextField(
                                  controller: descripcionController ,
                                  decoration: const InputDecoration(labelText: 'Descripcion', fillColor: Colors.white, filled: true),
                                  maxLines: 2,
                              ),
                              const SizedBox(height: 10,),
                              TextField(
                                  controller: fechaFacturacionController,
                                  decoration: const InputDecoration(labelText: 'Fecha de Facturacion', fillColor: Colors.white, filled: true),
                      
                              ),

                              const SizedBox(height: 10,),

                              FutureBuilder<dynamic>(
                                      future: _terceros, // Tu Future que devuelve un AsyncSnapshot<dynamic>
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          return const Text('Error al cargar los datos');
                                        } else {
                                          _tercerosSnapshot = snapshot; // Asignamos el snapshot para accederlo fuera del builder
                                          List<dynamic> tercerosData = snapshot.data; // Accedemos a los datos del snapshot

                                                    filteredTerceros ??= tercerosData;

                                          List<int> nombresTerceros =
                                              tercerosData.map((tercero) => tercero['c_bpartner_id'] as int).toList();
                                                bool isSelectedValuePresent = filteredTerceros!.any((tercero) => tercero['c_bpartner_id'] == _selectedTercero);


                                          return Column(
                                            children: [
                                                 Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: TextField(
                                                    controller: _searchController,
                                                    decoration: const InputDecoration(
                                                      labelText: 'Buscar Tercero',
                                                      suffixIcon: Icon(Icons.search),
                                                    ),
                                                    onChanged: (value) {
                                                      print('este es el value $value');
                                                      setState(() {
                                                        filteredTerceros = tercerosData.where((tercero) =>
                                                          
                                                          tercero['bp_name'].toLowerCase().contains(value.toLowerCase()) ||
                                                          tercero['ruc'].contains(value)).toList();

                                                           if (!filteredTerceros!.any((tercero) => tercero['c_bpartner_id'] == _selectedTercero)) {
                                                            _selectedTercero = null; // Resetea el valor seleccionado si ya no es válido
                                                          }

                                                          if (filteredTerceros!.length == 1) {
                                                            // Si hay exactamente un tercero, seleccionarlo automáticamente.
                                                            _selectedTercero = filteredTerceros!.first['c_bpartner_id'];
                                                          } else if (!filteredTerceros!.any((tercero) => tercero['c_bpartner_id'] == _selectedTercero)) {
                                                            _selectedTercero = null; // Resetea el valor seleccionado si ya no es válido
                                                          }

                                                      });
                                                      
                                                      print('Este es el valor de filteredTerceros ${filteredTerceros}');
                                                    },
                                                  ),
                                                ),
                                              Container(
                                                width: 400,
                                                height: 50,
                                                color: Colors.white,
                                                child: DropdownButton<int>(
                                                  value: isSelectedValuePresent ? _selectedTercero : null, // Valor seleccionado, inicialmente null
                                                  hint: const Text('Selecciona un tercero'),
                                                  items: filteredTerceros?.map((dynamic value) {
                                                     String bpName = value['bp_name'];
                                                     String ruc = value['ruc'];
                                                     String displayText = "${bpName.length > 15 ? bpName.substring(0, 15) + '...' : bpName} - $ruc";
                                                    return DropdownMenuItem<int>(
                                                      value: value['c_bpartner_id'] as int,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(10.0),
                                                        child:Container(width: 270, child:Text(displayText)),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (dynamic selectedValue) {
                                                    print('Esto es el valor del select $selectedValue');
                                                    // Aquí puedes manejar la selección del usuario y obtener los ids correspondientes
                                                    int index = nombresTerceros.indexOf(selectedValue);
                                                    dynamic selectedTercero = tercerosData[index];
                                                    print('Este es el tercero $selectedTercero');
                                                    int cBPartnerId = selectedTercero['c_bpartner_id'] as int;
                                                    int cBPartnerLocationId =
                                                        selectedTercero['c_bpartner_location_id'] is int ? selectedTercero['c_bpartner_location_id'] : 0;
                                                        
                                                        setState(() {
                                                          
                                                          _selectedTercero = selectedValue;
                                                
                                                        });
                                                
                                                    print('c_bpartner_id: $cBPartnerId, c_bpartner_location_id: $cBPartnerLocationId');
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                        }
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
                                controller:  numeroDocumentoController ,
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
                                        'nro_document': numeroDocumentoController.text, // Reemplaza numeroDocumento con el valor deseado
                                        'porcentaje': porcentaje.text, // Reemplaza porcentaje con el valor deseado
                                        'total_impuesto': totalImpuesto.text, // Reemplaza totalImpuesto con el valor deseado
                                        'regla_retencion': reglaRetencionSeleccionada,
                                        'orden_compra_id': int.parse(valorSeleccionado!), // Reemplaza valorSeleccionado con el valor deseado
                                      };

                                    
                                        insertRetencion(nuevaRetencion);
                                        _formKey.currentState?.reset();

                                        totalBdi.clear();
                                        numeroDocumentoController.clear();
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