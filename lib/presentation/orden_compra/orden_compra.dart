import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:femovil/presentation/orden_compra/product_selection.dart';
import 'package:femovil/presentation/orden_venta/product_selection.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart'; // Importa la librería de formateo de fechas

class OrdenDeCompraScreen extends StatefulWidget {
  final int providerId;
  final String providerName;
  final int cBPartnerID;
  final int cBPartnerLocationId;

  const OrdenDeCompraScreen(
      {super.key,
      required this.providerId,
      required this.providerName,
      required this.cBPartnerID,
      required this.cBPartnerLocationId});

  @override
  _OrdenDeCompraScreenState createState() => _OrdenDeCompraScreenState();
}

class _OrdenDeCompraScreenState extends State<OrdenDeCompraScreen> {
  TextEditingController numeroReferenciaController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController numeroFacturaController = TextEditingController();
  TextEditingController saldoNetoController = TextEditingController();
  TextEditingController fechaIdempiereController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<Map<String, dynamic>> selectedProducts = [];
  bool _validateDescription = false;
  DateTime selectedDate = DateTime.now();
  double? saldoNeto;
  double? totalImpuesto;
  Map<String, dynamic> infoUserForOrder = {};

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

  initGetUser() async {
    final info = await getApplicationSupportDirectory();
    print("esta es la ruta ${info.path}");

    final String filePathEnv = '${info.path}/.env';
    final File archivo = File(filePathEnv);
    String contenidoActual = await archivo.readAsString();

    Map<String, dynamic> infoLogin = await getLogin();
    Map<String, dynamic> jsonData = jsonDecode(contenidoActual);

    var orgId = jsonData["OrgID"];
    var clientId = jsonData["ClientID"];
    var wareHouseId = jsonData["WarehouseID"];

    print('Esto es infologin $infoLogin');

    // Map<String, dynamic> getUser = await getUsers(username, password);

    setState(() {
      infoUserForOrder = {
        'orgid': orgId,
        'clientid': clientId,
        'warehouseid': wareHouseId,
        'userId': infoLogin['userId']
      };
    });

    print('infouserFororder $infoUserForOrder');
  }

  initV() async {
    if (variablesG.isEmpty) {
     
      List<Map<String, dynamic>> response = await getPosPropertiesV();
      setState(() {
        variablesG = response;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: currentDate,
      lastDate: currentDate,
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        fechaController.text = DateFormat('dd/MM/yyyy')
            .format(selectedDate); // Formato día/mes/año
      });
    }
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
        final selectedQuantity =
            product['quantity']; // Obtener la cantidad seleccionada

        if (selectedQuantity == 0) {
          // Si la cantidad seleccionada es mayor que la cantidad disponible, mostrar un mensaje de error
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Error'),
                content:
                    Text('No hay suficientes ${product['name']} disponibles.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el diálogo
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Si la cantidad seleccionada es menor o igual que la cantidad disponible, agregar el producto a la lista
          setState(() {
            selectedProducts.add(product);
          });
        }
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
      montoController.text = '\$${calcularMontoTotal().toStringAsFixed(2)}';
    });
  }

  @override
  void initState() {
    initV();
    initGetUser();
    fechaController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    fechaIdempiereController.text =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);
    print("Esto es el id ${widget.providerId}");
    print("Esto es el name ${widget.providerName}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orden de Compra'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: numeroReferenciaController,
                decoration:
                    const InputDecoration(labelText: 'Número de Documento'),
              ),
              TextField(
                controller: numeroFacturaController,
                decoration:
                    const InputDecoration(labelText: 'Número de Factura'),
              ),
              TextField(
                controller: fechaController,
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  suffixIcon: IconButton(
                    onPressed: () => _selectDate(context),
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                readOnly: true,
              ),
              TextFormField(
                readOnly: true,
                controller: TextEditingController(text: widget.providerName),
                decoration:
                    const InputDecoration(labelText: 'Nombre del Cliente'),
              ),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  if (value.trim().isEmpty) {
                    setState(() {
                      _validateDescription = true;
                    });
                  } else {
                    setState(() {
                      _validateDescription = false;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              TextField(
                readOnly: true,
                controller: saldoNetoController,
                decoration: const InputDecoration(labelText: 'Saldo Neto'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                readOnly: true,
                controller: montoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
              ),
              const Text(
                'Productos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        _handlePriceChange(newValue, index);

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        builder: (context) => ProductSelectionComprasScreen()),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Aquí puedes realizar la transacción y guardar la orden de venta en la base de datos
                  // con los datos proporcionados
                  // Por ejemplo:

                  //  if (descripcionController.text.isEmpty) {
                  //           setState(() {
                  //             _validateDescription = true; // Marcar como campo inválido si está vacío
                  //           });

                  //                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text('Por favor ingrese una descripción.')));

                  //           return; // Detener el proceso de agregar la orden si el campo está vacío
                  //     }

                  if (selectedProducts.isEmpty) {
                    // Mostrar un diálogo o mensaje indicando que la orden debe tener productos adjuntos
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'La orden debe tener productos adjuntos.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Cerrar el diálogo
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );

                    return;
                  }

                  print('Esto es el monto ${montoController.text}');

                  final order = {
                    'proveedor_id': widget.providerId,
                    'documentno': numeroReferenciaController.text,
                    'c_doc_type_target_id': variablesG[0]
                        ['c_doc_type_order_co'],
                    'ad_client_id': infoUserForOrder['clientid'],
                    'ad_org_id': infoUserForOrder['orgid'],
                    'm_warehouse_id': infoUserForOrder['warehouseid'],
                    'payment_rule': 'B',
                    'dateordered': fechaIdempiereController.text,
                    'sales_rep_id': infoUserForOrder['userId'],
                    'c_bpartner_id': widget.cBPartnerID,
                    'c_bpartner_location_id': widget.cBPartnerLocationId,
                    'm_price_list_id': variablesG[0]['m_pricelist_id'],
                    'c_currency_id': 100,
                    'c_payment_term_id': variablesG[0]['c_paymentterm_id'],
                    'c_conversion_type_id': variablesG[0]
                        ['c_conversion_type_id'],
                    'po_reference': numeroFacturaController.text,
                    'id_factura': 0,
                    'fecha': fechaController.text,
                    'description': descripcionController.text,
                    'monto': double.parse(montoController.text.substring(1)),
                    'saldo_neto':
                        double.parse(saldoNetoController.text.substring(1)),
                    'productos': selectedProducts,
                    'usuario_id': infoUserForOrder['userId'],
                    'status_sincronized': 'Borrador',
                  };

                  // Luego puedes guardar la orden de venta en la base de datos o enviarla al servidor
                  insertOrderCompra(order).then((orderId) {
                    // Limpiar los campos después de guardar la orden
                    if (orderId is Map<String, dynamic> &&
                        orderId.containsKey('failure')) {
                      if (orderId['failure'] == -1) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              orderId['Error'],
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                    } else {
                      print(
                          'orderId no es un mapa válido o no contiene la propiedad "failure"');
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Orden de venta guardada correctamente con ID: $orderId'),
                      ),
                    );

                    numeroReferenciaController.clear();
                    descripcionController.clear();
                    montoController.clear();
                    numeroFacturaController.clear();
                    saldoNetoController.clear();

                    // Limpiar la lista de productos seleccionados después de guardar la orden
                    setState(() {
                      selectedProducts.clear();
                    });

                    // Notificar al usuario que la orden se ha guardado exitosamente
                  });
                },
                child: const Text('Completar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
