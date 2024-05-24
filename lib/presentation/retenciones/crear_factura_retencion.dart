import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/app_bar_sampler.dart';
import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:femovil/presentation/orden_compra/product_selection.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/retenciones/idempiere/create_factura_retencion.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class CrearRetenciones extends StatefulWidget {
  const CrearRetenciones({super.key});

  @override
  State<CrearRetenciones> createState() => _CrearRetencionesState();
}

class _CrearRetencionesState extends State<CrearRetenciones> {
  TextEditingController totalBdi = TextEditingController();
  TextEditingController numeroDocumentoController = TextEditingController();
  TextEditingController porcentaje = TextEditingController();
  TextEditingController numeroFacturaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaFacturacionController = TextEditingController();
  TextEditingController fechaIdempiereController = TextEditingController();
  final TextEditingController _establishmentController =
      TextEditingController();
  final TextEditingController _searchDialogController = TextEditingController();
  final TextEditingController _textTerceroController = TextEditingController();
  final TextEditingController _emisionController = TextEditingController();
  final TextEditingController _sriAuthorizationCodeController =
      TextEditingController();
  final TextEditingController _sequenceController = TextEditingController();
  final TextEditingController _cbPartnerIdController = TextEditingController();
  final TextEditingController _cbPartnerLocationIdController =
      TextEditingController();
  final TextEditingController _providerIdController = TextEditingController();
  TextEditingController saldoNetoController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  String? tipoRetencionSeleccionado = '';
  String? reglaRetencionSeleccionada = '';
  String? valorSeleccionado = '';
  String? impuestoValue = '';
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  List<Map<String, dynamic>> ordenesSinRetencion = [];
  List<Map<String, dynamic>> selectedProducts = [];

  Future? _terceros;
  List<dynamic>? filteredTerceros;
  String? paymentTypeValue;
  String _selectTypePaymentRule = '';
  String? taxSustance;
  String _selectTaxSutance = "";
  Future<List<Map<String, dynamic>>>? _paymentTermsFuture;
  bool flag = false;
  double? saldoNeto;
  double? totalImpuesto;
  BuildContext? currentContext;
  bool _hasError = false;

  double calcularMontoTotal() {
    double total = 0;
    double totalNeto = 0;
    double suma = 0;

    for (var product in selectedProducts) {
      total +=
          product['price'] * product['quantity'] * (product['impuesto'] / 100);
      totalNeto += product['price'] * product['quantity'];
    }
    saldoNetoController.text = '\$${totalNeto.toStringAsFixed(2)}';
    suma = total + totalNeto;

    print('productos totales $selectedProducts');

    return suma;
  }



  initV() async {
    if (variablesG.isEmpty) {
      List<Map<String, dynamic>> response = await getPosPropertiesV();
      print('variables Entre aqui');
      variablesG = response;
    }
    print('Estas son las variables globales $variablesG');
  }

  double calcularSaldoNetoProducto(cantidadProducts, price) {
    double multi =
        (cantidadProducts as num).toDouble() * (price as num).toDouble();

    saldoNeto = multi;

    return multi;
  }

  double calcularMontoImpuesto(impuesto, monto) {
    double montoImpuesto = monto * impuesto / 100;

    totalImpuesto = montoImpuesto;

    print(
        'El monto $monto y el impuesto $impuesto y el monto impuesto seria $montoImpuesto');
    return montoImpuesto;
  }

  void _addOrUpdateProduct(List<Map<String, dynamic>> products) {
    for (var product in products) {
      int index = selectedProducts
          .indexWhere((element) => element['name'] == product['name']);
      if (index != -1) {
        // Si el producto ya existe, actualizar la cantidad
        setState(() {
          selectedProducts[index]['quantity'] += product['quantity'];
        });
      } else {
        // Si el producto no existe, verificar la disponibilidad antes de agregarlo
        final availableQuantity = product['quantity_avaible'] ??
            0; // Obtener la cantidad disponible del producto
        final selectedQuantity =
            product['quantity']; // Obtener la cantidad seleccionada

        print("cantidad disponible $availableQuantity");

        // Si la cantidad seleccionada es menor o igual que la cantidad disponible, agregar el producto a la lista
        setState(() {
          selectedProducts.add(product);
        });
      }
    }
  }

  void _handlePriceChange(String newValue, int index) {
    final double newPrice = double.tryParse(newValue) ?? 0.0;
    setState(() {
      selectedProducts[index]['price'] = newPrice;
    });
  }

  void _removeProduct(int index) {
    setState(() {
      selectedProducts.removeAt(index);
      montoController.text = calcularMontoTotal().toString();
    });
  }

  @override
  void initState() {

    if (mounted) {
      setState(() {
        _paymentTermsFuture = getPaymentTerms();
        _terceros = getProviders();
      });

      initV();

      fechaIdempiereController.text =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      fechaFacturacionController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
      _focusNode.attach(context);
    }
    super.initState();
  }

  @override
  void dispose() {
    _searchDialogController.clear();
    fechaFacturacionController.clear();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final screenMedia = MediaQuery.of(context).size.width * 0.8;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    setState(() {
      currentContext = context;
    });

    

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50) ,
          child: AppBarSample(label: 'Factura con Retencion')),
        body: Center(
          child: SizedBox(
            width: screenMedia,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(

                  
                  
                  children: [

                      SizedBox(height: screenHeight * 0.03,),
                    
                    Container(
                     height: screenMedia * 0.20,
                      width: screenMedia * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,

                          borderRadius: BorderRadius.circular(15), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              spreadRadius: 2
                            )
                          ]

                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: numeroDocumentoController,
                        decoration:    InputDecoration(
                            labelText: 'Numero de documento',
                            filled: true,
                            fillColor: Colors.white,
                             contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            labelStyle: const TextStyle(
                              fontFamily:
                                  'Poppins Regular', // Reemplaza con el nombre definido en pubspec.yaml
                              fontSize: 15.0, // Tamaño de la fuente
                              // Peso de la fuente (por ejemplo, bold)
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Color del texto
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide.none, // Color del borde
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando está enfocado
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando no está enfocado
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.red))
                            ),
                            
                        onChanged: (value) {
                          if(_hasError == false){

                          setState(() {
                            
                          });
                          }

                          print('Este es el valor $value');
                        },
                        validator: (value) {
                      
                            if(value!.isEmpty){

                                
                      
                                return "Por favor, proporciona un numero de documento.";
                            }
                            return null;
                      
                        },
                        
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02,),
                          Container(
                            height: screenMedia * 0.20,
                      width: screenMedia * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,

                          borderRadius: BorderRadius.circular(15), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              spreadRadius: 2
                            )
                          ]

                      ),
                            child: TextFormField(
                            readOnly: true,
                            controller: fechaFacturacionController,
                            decoration:  InputDecoration(
                            labelText: 'Fecha de Facturacion',
                            fillColor: Colors.white,
                            filled: true,
                             contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            labelStyle: const TextStyle(
                              fontFamily:
                                  'Poppins Regular', // Reemplaza con el nombre definido en pubspec.yaml
                              fontSize: 15.0, // Tamaño de la fuente
                              // Peso de la fuente (por ejemplo, bold)
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Color del texto
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide.none, // Color del borde
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando está enfocado
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando no está enfocado
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.red))
                            ),
                                                    
                            ),
                          ),
                  SizedBox(height: screenHeight * 0.02,),

                    Container(
                         height: screenMedia * 0.30,
                      width: screenMedia * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,

                          borderRadius: BorderRadius.circular(15), 
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              spreadRadius: 2
                            )
                          ]

                      ),
                      child: TextFormField(
                        controller: descripcionController,
                        decoration:  InputDecoration(
                            labelText: 'Descripcion',
                            fillColor: Colors.white,
                            filled: true,
                             contentPadding: const EdgeInsets.symmetric(
                                vertical: 25, horizontal: 20),
                            labelStyle: const TextStyle(
                              fontFamily:
                                  'Poppins Regular', // Reemplaza con el nombre definido en pubspec.yaml
                              fontSize: 15.0, // Tamaño de la fuente
                              // Peso de la fuente (por ejemplo, bold)
                              color: Color.fromARGB(
                                  255, 0, 0, 0), // Color del texto
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide.none, // Color del borde
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando está enfocado
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 25,
                              ), // Color del borde cuando no está enfocado
                            ),
                        
                            ),
                            onChanged: (value) {

                                if(_hasError == false){
                                  print('Entre aqui');
                                  setState(() {
                                    
                                  });
                                }

                            } ,
                        maxLines: 2,
                      ),
                    ),
                

                    SizedBox(height: screenHeight * 0.02,),

                    FutureBuilder<dynamic>(
                      future:
                          _terceros, // Tu Future que devuelve un AsyncSnapshot<dynamic>
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error al cargar los datos');
                        } else {
                          List<dynamic> tercerosData = snapshot
                              .data; // Accedemos a los datos del snapshot

                          filteredTerceros ??= tercerosData;
                     

                          return Container(
                            width: screenMedia * 0.97,
                               
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                            
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              blurRadius: 7,
                                              spreadRadius: 2
                                            )
                                        ]
                                      ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: _hasError == true ? screenHeight * 0.18 : screenHeight * 0.11,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(2)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            blurRadius: 7,
                                            spreadRadius: 2,
                                            offset: Offset(-2, 0)

                                          )
                                        ]
                                      ),
                                      child: IconButton(
                                       
                                        icon:  Icon(Icons.search, color: _hasError  ? Color(0XFFA5F52B): Color(0XFF7531FF),),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return GestureDetector(
                                                onTap: () {
                                                                  
                                                    if(MediaQuery.of(context).viewInsets.bottom > 0){
                                                                  
                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                    }
                                                
                                                },
                                                child: StatefulBuilder(

                                                  builder: (context, setStateDialog) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                          'Buscar Proveedor', style: TextStyle(fontFamily: 'Poppins Semibold',),),
                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          
                                                          children: [
                                                            SizedBox(height: screenHeight * 0.03,),
                                                            Container(
                                                              width: screenMedia* 0.80,
                                                              height: screenHeight * 0.09,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.circular(8),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors.grey.withOpacity(0.3),
                                                                    blurRadius: 7,
                                                                    spreadRadius: 2
                                                                  )
                                                
                                                                ]
                                                              ),
                                                              child: TextField(
                                                                controller:
                                                                    _searchDialogController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                    
                                                                      border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                        borderSide: BorderSide.none
                                                                      ),
                                                                      focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                        borderSide: BorderSide(width: 25, color: Colors.white)
                                                                      ),
                                                                  contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                                                  labelText: 'Buscar',
                                                                  prefixIcon: Icon(
                                                                      Icons.search),
                                                                ),
                                                                onChanged: (value) {
                                                                  if (mounted) {
                                                                    setState(() {
                                                                      filteredTerceros = tercerosData
                                                                          .where((tercero) =>
                                                                              tercero['bpname']
                                                                                  .toLowerCase()
                                                                                  .contains(value
                                                                                      .toLowerCase()) ||
                                                                              tercero['tax_id']
                                                                                  .contains(
                                                                                      value))
                                                                          .toList();
                                                                    });
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 16),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.9,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              child: ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    filteredTerceros!
                                                                        .length,
                                                                itemBuilder:
                                                                    (context, index) {
                                                                  print(
                                                                      'Estos son los filteredTerceros $filteredTerceros');
                                                
                                                                  String bpName =
                                                                      filteredTerceros![
                                                                              index]
                                                                          ['bpname'];
                                                                  int providerId =
                                                                      filteredTerceros![
                                                                              index]
                                                                          ['id'];
                                                                  int cBPartnerID =
                                                                      filteredTerceros![
                                                                              index][
                                                                          'c_bpartner_id'];
                                                                  dynamic
                                                                      cBPartnerLocationID =
                                                                      filteredTerceros![
                                                                              index][
                                                                          'c_bpartner_location_id'];
                                                                  String ruc =
                                                                      filteredTerceros![
                                                                              index]
                                                                          ['tax_id'];
                                                
                                                                          
                                                                  String displayBpName =
                                                                      "${bpName} ";
                                                                  String displayRuc = ruc;
                                                                  return ListTile(
                                                                    title: Container(
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                boxShadow: [
                                                                                  BoxShadow(
                                                                                    color: Colors.grey.withOpacity(0.3),
                                                                                    blurRadius: 7,
                                                                                    spreadRadius: 2
                                                                                  )
                                                                                ]
                                                
                                                                              ),
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          children: [
                                                                             
                                                                                SizedBox(
                                                                                
                                                                                  width: screenMedia ,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                                                                    child: Text(
                                                                                        displayBpName, textAlign: TextAlign.start, style: TextStyle(fontFamily: 'Poppins Bold'),),
                                                                                  ),
                                                                                                                                                  
                                                                                ),
                                                                                        SizedBox(
                                                                                         
                                                                                  width: screenMedia ,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                                                                    child: Text(
                                                                                        displayRuc, textAlign: TextAlign.start, style: TextStyle(fontFamily: 'Poppins Regular'),),
                                                                                  ),
                                                                                                                                                  
                                                                                ),
                                                                                    ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    
                                                                    onTap: () {
                                                                      setState(() {
                                                                        _hasError = false;
                                                                      },);
                                                                    
                                                                      _textTerceroController
                                                                              .text =
                                                                          bpName
                                                                              .toString();
                                                                      _cbPartnerIdController
                                                                              .text =
                                                                          cBPartnerID
                                                                              .toString();
                                                                      _cbPartnerLocationIdController
                                                                              .text =
                                                                          cBPartnerLocationID
                                                                              .toString();
                                                                      _providerIdController
                                                                              .text =
                                                                          providerId
                                                                              .toString();
                                                                      print(
                                                                          'este es el tercero que se elijio  $bpName este es el cbpartnerId ${_cbPartnerIdController.text} y este es el cbpartnerLocationId $cBPartnerLocationID');
                                                                      // Aquí puedes manejar la selección del tercero
                                                                      // Por ejemplo, cerrar el diálogo y usar el tercero seleccionado.
                                                                      Navigator.of(
                                                                              context,)
                                                                          .pop();
                                                                      // Puedes acceder al tercero seleccionado con filteredTerceros[index]
                                                                    },
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text('Cancelar', style: TextStyle(fontFamily: 'Poppins SemiBold', color: Colors.red),),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                                    SizedBox(
                                      width: screenMedia * 0.75,
                                      child: TextFormField(
                                       
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical:25),
                                          disabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            borderSide: BorderSide(width: 25, color: Colors.white)
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                            borderSide: BorderSide(width: 25, color: Colors.white)
                                          ) ,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            borderSide: BorderSide(width: 25, color: Colors.white) 
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15)),
                                            borderSide: BorderSide.none
                                          ),
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            borderSide: BorderSide(width: 1, color: Colors.red )
                                          ),
                                            label: Text('Proveedor')),
                                        controller: _textTerceroController,
                                      validator: (value) {
                                        

                                        if(value!.isEmpty){  

                                            _hasError = true;                                          

                                            return "Debe seleccionar un proveedor";
                                        }
                          
                                        return null;
                                      },
                                      ),
                                    )
                                  ],
                                ),
                                
                              ],
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02,),

                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _paymentTermsFuture,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Error al cargar los datos'));
                        } else if (snapshot.hasData) {
                          // Creando una lista de DropdownMenuItems a partir de los datos
                          var dropdownItems = snapshot.data!
                              .map<DropdownMenuItem<int>>(
                                  (Map<String, dynamic> value) {
                            return DropdownMenuItem<int>(
                              value: value['c_paymentterm_id'],
                              child: Text(value['name'].toString(), style: TextStyle(fontFamily: 'Poppins Regular') ,),
                            );
                          }).toList();

                          return Container(
                            width: screenMedia *0.97,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 7,
                                  spreadRadius: 2,
                                  color: Colors.grey.withOpacity(0.5)
                                )
                              ]

                            ),
                            child: DropdownButtonFormField<int>(
                              icon: Image.asset('lib/assets/Abajo.png'),
                              validator: (value) {

                                    if (value == null) {
                                        return 'Por favor, selecciona un término de pago';
                                      }
                                return null;

                              },
                              decoration: const InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.all(Radius.circular(15)),
                                 borderSide: BorderSide(width: 1, color: Colors.red) 
                                ),
                                errorBorder: OutlineInputBorder(

                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(width: 1, color: Colors.red) 

                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(width: 25, color: Colors.white) 
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide(width: 25, color: Colors.white) 
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide.none
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins Regular' ,
                                  overflow: TextOverflow.ellipsis
                                ),
                                labelText: 'Selecciona un término de pago',
                                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                              ),
                              items: dropdownItems,
                              onChanged: (int? newValue) {
                                // Aquí puedes manejar el valor seleccionado
                                print("Selected value: $newValue");
                                if(_hasError == false){
                                
                                    setState(() {
                                      
                                    });
                                      
                                }
                              },
                            ),
                          );
                        } else {
                          return const Center(
                              child: Text('No hay datos disponibles'));
                        }
                      },
                    ),

                   SizedBox(height: screenHeight * 0.02,),


                    DropdownButtonFormField<String>(
                      value: paymentTypeValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          paymentTypeValue = newValue;
                        });

                        if (newValue == 'Caja de Punto de Venta') {
                          setState(() {
                            _selectTypePaymentRule = 'B';
                          });
                        } else if (newValue == 'Cheque') {
                          setState(() {
                            _selectTypePaymentRule = 'S';
                          });
                        } else if (newValue == "Con Término de Pago") {
                          setState(() {
                            _selectTypePaymentRule = 'P';
                          });
                        } else if (newValue == "Depósito Directo") {
                          setState(() {
                            _selectTypePaymentRule = 'T';
                          });
                        } else if (newValue == 'Multiples Medios de Pago') {
                          setState(() {
                            _selectTypePaymentRule = 'M';
                          });
                        } else if (newValue == 'Tarjeta De Crédito') {
                          setState(() {
                            _selectTypePaymentRule = 'K';
                          });
                        }

                        print(
                            'Este es el valor de paymentTypeValue $paymentTypeValue && este es el valor de $_selectTypePaymentRule');
                      },
                      items: <String>[
                        'Caja de Punto de Venta',
                        'Cheque',
                        'Con Término de Pago',
                        'Depósito Directo',
                        'Multiples Medios de Pago',
                        'Tarjeta De Crédito'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Regla de Pago',
                        labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 0.5),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _sriAuthorizationCodeController,
                      decoration: const InputDecoration(
                          labelText: 'Codigo Autorizado por el SRI',
                          filled: true,
                          fillColor: Colors.white),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _establishmentController,
                      decoration: const InputDecoration(
                          labelText: 'Establecimiento',
                          filled: true,
                          fillColor: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _emisionController,
                      onChanged: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Emisión',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: _sequenceController,
                      decoration: const InputDecoration(
                        labelText: 'Secuencia',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),

                    DropdownButtonFormField<String>(
                      value: taxSustance,
                      onChanged: (String? newValue) {
                        setState(() {
                          taxSustance = newValue;
                        });

                        if (newValue ==
                            'Crédito Tributario para declaración de IVA') {
                          setState(() {
                            _selectTaxSutance = '01';
                          });
                        } else if (newValue ==
                            'Costo o Gasto para declaración de Imp. a la Renta') {
                          setState(() {
                            _selectTaxSutance = '02';
                          });
                        } else if (newValue == "Activo Fijo") {
                          setState(() {
                            _selectTaxSutance = '03';
                          });
                        } else if (newValue == "Activo Fijo - Costo o Gasto") {
                          setState(() {
                            _selectTaxSutance = '04';
                          });
                        } else if (newValue ==
                            'Liquidación de Gastos de Viaje, hospedaje y Alimentación') {
                          setState(() {
                            _selectTaxSutance = '05';
                          });
                        } else if (newValue ==
                            'Inventario - Crédito Tributario para la declaración de IVA') {
                          setState(() {
                            _selectTaxSutance = '06';
                          });
                        } else if (newValue ==
                            'Inventario - Costo o Gasto para declaración de Imp.') {
                          setState(() {
                            _selectTaxSutance = '07';
                          });
                        } else if (newValue ==
                            'Valor pagado para solicitar Reembolso de Gastos') {
                          setState(() {
                            _selectTaxSutance = '08';
                          });
                        } else if (newValue == 'Reembolso por Siniestros') {
                          setState(() {
                            _selectTaxSutance = '09';
                          });
                        } else if (newValue ==
                            'Distribución de Dividendos, Beneficios o Utilidades') {
                          setState(() {
                            _selectTaxSutance = '10';
                          });
                        } else if (newValue ==
                            'Impuestos y retenciones presuntivos') {
                          setState(() {
                            _selectTaxSutance = '11';
                          });
                        } else if (newValue ==
                            'Valores reconocidos por entidades del sector público') {
                          setState(() {
                            _selectTaxSutance = '12';
                          });
                        }

                        print(
                            'Este es el valor de Sustento Tributario $taxSustance && este es el valor de $_selectTaxSutance');
                      },
                      items: <String>[
                        'Crédito Tributario para declaración de IVA',
                        'Costo o Gasto para declaración de Imp. a la Renta',
                        'Activo Fijo',
                        'Activo Fijo - Costo o Gasto',
                        'Liquidación de Gastos de Viaje, hospedaje y Alimentación',
                        'Inventario - Crédito Tributario para la declaración de IVA',
                        'Inventario - Costo o Gasto para declaración de Imp.',
                        'Valor pagado para solicitar Reembolso de Gastos',
                        'Reembolso por Siniestros',
                        'Distribución de Dividendos, Beneficios o Utilidades',
                        'Impuestos y retenciones presuntivos',
                        'Valores reconocidos por entidades del sector público'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: SizedBox(
                              width: screenMedia,
                              child: Text(
                                value,
                                overflow: TextOverflow
                                    .ellipsis, // Para manejar texto largo
                              )),
                        );
                      }).toList(),
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Sustento Tributario',
                        labelStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 0.5),
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Productos:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 300,
                      child: ListView.builder(
                        itemCount: selectedProducts.length,
                        itemBuilder: (context, index) {
                          final product = selectedProducts[index];
                          return Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'].toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Cantidad: ${product["quantity"]}'),
                                    Row(
                                      children: [
                                        const Text('Price: '),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                            initialValue:
                                                '${product['price']}', // Valor inicial del precio
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                            ),

                                            onChanged: (newValue) {
                                              _handlePriceChange(
                                                  newValue, index);

                                              setState(() {
                                                montoController.text =
                                                    '\$${calcularMontoTotal().toStringAsFixed(2)}';
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        child: Text(
                                            'Impuesto: ${product['impuesto']}%')),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Monto Impuesto: ${calcularMontoImpuesto(product['impuesto'], product['quantity'] * product['price'])}',
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Saldo Neto: ${calcularSaldoNetoProducto(product['quantity'], product['price']).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: Text(
                                        'Monto Total: ${(calcularSaldoNetoProducto(product['quantity'], product['price']) + calcularMontoImpuesto(product['impuesto'], product['quantity'] * product['price'])).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        _removeProduct(index);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        // Aquí puedes mostrar un diálogo o pantalla para seleccionar productos y agregarlos a la orden de venta
                        // Puedes usar Navigator.push para navegar a una pantalla de selección de productos
                        // y agregar los productos seleccionados a la lista selectedProducts
                        // Por ejemplo:

                        final selectedProductsResult = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductSelectionComprasScreen()),
                        );
                        print("Cantidad de productos $selectedProductsResult");
                        if (selectedProductsResult != null) {
                          setState(() {
                            _addOrUpdateProduct(selectedProductsResult);

                            montoController.text =
                                '\$${calcularMontoTotal().toStringAsFixed(2)}';
                          });
                        }
                      },
                      child: const Text('Agregar Productos'),
                    ),
                    TextField(
                      readOnly: true,
                      controller: saldoNetoController,
                      decoration:
                          const InputDecoration(labelText: 'Saldo Neto'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      readOnly: true,
                      controller: montoController,
                      decoration: const InputDecoration(labelText: 'Monto'),
                      keyboardType: TextInputType.number,
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    Center(
                      child: SizedBox(
                        width: screenMedia,
                        child: Column(
                          children: [
                            // ...otros widgets aquí
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double
                                  .infinity, // Asegura que el botón ocupe todo el ancho disponible
                              child: ElevatedButton(
                                onPressed: () async {

                                  if(_formKey.currentState!.validate()){
                                  final info =
                                      await getApplicationSupportDirectory();
                                  print("esta es la ruta ${info.path}");

                                  final String filePathEnv =
                                      '${info.path}/.env';
                                  final File archivo = File(filePathEnv);
                                  String contenidoActual =
                                      await archivo.readAsString();
                                  print(
                                      'Contenido actual del archivo:\n$contenidoActual');

                                  // Convierte el contenido JSON a un mapa
                                  Map<String, dynamic> jsonData =
                                      jsonDecode(contenidoActual);
                                  print(
                                      'Esto es cbpartnerId ${_cbPartnerIdController.text} ');
                                  print(
                                      'Esto es provider id ${_providerIdController.text}');
                                  print(
                                      'Esto es el cbpartnerlocationid ${_cbPartnerLocationIdController.text}');
                                  print('Esto es el jsonData $jsonData');

                                  dynamic userId = await getLogin();

                                  Map<String, dynamic> nuevaRetencion = {
                                    'ad_client_id': jsonData['ClientID'],
                                    'ad_org_id': jsonData['OrgID'],
                                    'c_bpartner_id':
                                        _cbPartnerIdController.text,
                                    'c_bpartner_location_id':
                                        _cbPartnerLocationIdController.text,
                                    'c_currency_id': variablesG[0]
                                        ['c_currency_id'],
                                    'c_doctypetarget_id': variablesG[0]
                                        ['c_doc_type_target_fr'],
                                    'c_paymentterm_id': variablesG[0]
                                        ['c_paymentterm_id'],
                                    'description': descripcionController.text,
                                    'documentno':
                                        numeroDocumentoController.text,
                                    'date': fechaFacturacionController.text,
                                    'is_sotrx': 'N',
                                    'm_pricelist_id': variablesG[0]
                                        ['m_pricelist_id'],
                                    'payment_rule': _selectTypePaymentRule,
                                    'date_invoiced':
                                        fechaIdempiereController.text,
                                    'date_acct': fechaIdempiereController.text,
                                    'sales_rep_id': userId['userId'],
                                    'sri_authorization_code':
                                        _sriAuthorizationCodeController.text,
                                    'ing_establishment':
                                        _establishmentController.text,
                                    'ing_emission': _emisionController.text,
                                    'ing_sequence': _sequenceController.text,
                                    'ing_taxsustance': _selectTaxSutance,
                                    'provider_id': _providerIdController.text,
                                    'monto': double.parse(
                                        montoController.text.substring(1)),
                                    'productos': selectedProducts,
                                  };

                                  print('Esto es la factura con retencion $nuevaRetencion');
                                  createInvoicedWithholdingIdempiere(nuevaRetencion);
                                  insertRetencion(nuevaRetencion);
                                  _formKey.currentState?.reset();

                                  totalBdi.clear();
                                  numeroDocumentoController.clear();
                                  porcentaje.clear();

                                  // Mostrar un mensaje al usuario
                                  ScaffoldMessenger.of(currentContext!)
                                      .showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Retención creada exitosamente'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  // Navigator.pop(context);
                                  }else{  

                                   

                                       setState(() {
                                        _hasError = true;
                                         });

                                        
                                  }
                                },
                                child: const Text('Crear retención'),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: double
                                  .infinity, // Asegura que el botón ocupe todo el ancho disponible
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
