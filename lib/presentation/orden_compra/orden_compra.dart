import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/orden_compra/product_selection.dart';
import 'package:femovil/presentation/orden_venta/product_selection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importa la librería de formateo de fechas


class OrdenDeCompraScreen extends StatefulWidget {
  final int providerId;
  final String providerName;

  const OrdenDeCompraScreen({super.key, required this.providerId, required this.providerName});

  @override
  _OrdenDeCompraScreenState createState() => _OrdenDeCompraScreenState();
}

class _OrdenDeCompraScreenState extends State<OrdenDeCompraScreen> {
  TextEditingController numeroReferenciaController = TextEditingController();
  TextEditingController fechaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController numeroFacturaController = TextEditingController();

  List<Map<String, dynamic>> selectedProducts = [];
  bool _validateDescription = false;
  DateTime selectedDate = DateTime.now();

    double calcularMontoTotal() {
    double total = 0;
    for (var product in selectedProducts) {
      total += product['price'] * product['quantity'];
    }
    return total;
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
      fechaController.text = DateFormat('dd/MM/yyyy').format(selectedDate); // Formato día/mes/año
    });
  }
}

void _addOrUpdateProduct(List<Map<String, dynamic>> products) {
  for (var product in products) {
    int index = selectedProducts.indexWhere((element) => element['name'] == product['name']);
    if (index != -1) {
      // Si el producto ya existe, actualizar la cantidad
      setState(() {
        selectedProducts[index]['quantity'] += product['quantity'];
      });
    } else {
      // Si el producto no existe, verificar la disponibilidad antes de agregarlo
      final selectedQuantity = product['quantity']; // Obtener la cantidad seleccionada
  

        

        if (selectedQuantity == 0) {
        // Si la cantidad seleccionada es mayor que la cantidad disponible, mostrar un mensaje de error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text('No hay suficientes ${product['name']} disponibles.'),
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


void _removeProduct(int index) {
  setState(() {
    selectedProducts.removeAt(index);
    montoController.text = calcularMontoTotal().toString();
  });
}

@override
void initState() {
    fechaController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
                decoration: const InputDecoration(labelText: 'Número de Referencia'),
              ),
              TextField(
                controller: numeroFacturaController,
                decoration: const InputDecoration(labelText: 'Número de Factura'),
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
                decoration: const InputDecoration(labelText: 'Nombre del Cliente'),
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
              const Text(
                'Productos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 100,
                child: ListView.builder(
                  itemCount: selectedProducts.length,
                  itemBuilder: (context, index) {
                    final product = selectedProducts[index];
                    return ListTile(
                      title: Text(product['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cantidad: ${product["quantity"]}'),
                          Text('Precio: ${product['price']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                        
                          setState(() {
                                _removeProduct(index);
                        
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
                TextField(
                  readOnly: true,
                controller: montoController,
                decoration: const InputDecoration(labelText: 'Monto'),
                keyboardType: TextInputType.number,
                
              
              ),
              ElevatedButton(
                onPressed: () async {
                  // Aquí puedes mostrar un diálogo o pantalla para seleccionar productos y agregarlos a la orden de venta
                  // Puedes usar Navigator.push para navegar a una pantalla de selección de productos
                  // y agregar los productos seleccionados a la lista selectedProducts
                  // Por ejemplo:
        
                            
                  final  selectedProductsResult = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductSelectionComprasScreen()),
                  );
                  print("Cantidad de productos $selectedProductsResult");
                  if (selectedProductsResult != null) {
                    setState(() {
        
                        _addOrUpdateProduct(selectedProductsResult);
                        
        
                      montoController.text = calcularMontoTotal().toString();
                      
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
        
                             if (descripcionController.text.isEmpty) {
                                      setState(() {
                                        _validateDescription = true; // Marcar como campo inválido si está vacío
                                      });
        
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:  Text('Por favor ingrese una descripción.')));
        
        
                                      return; // Detener el proceso de agregar la orden si el campo está vacío
                                }
        
        
        
                            if (selectedProducts.isEmpty) {
                            // Mostrar un diálogo o mensaje indicando que la orden debe tener productos adjuntos
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text('La orden debe tener productos adjuntos.'),
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
                  final order = {
                    'proveedor_id': widget.providerId,
                    'numero_referencia': numeroReferenciaController.text,
                    'numero_factura': numeroFacturaController.text,
                    'fecha': fechaController.text,
                    'descripcion': descripcionController.text,
                    'monto': double.parse(montoController.text),
                    'productos': selectedProducts, // Esta lista contendría los detalles de los productos seleccionados
                  };
                  // Luego puedes guardar la orden de venta en la base de datos o enviarla al servidor
                       DatabaseHelper.instance.insertOrderCompra(order).then((orderId) {
                   // Limpiar los campos después de guardar la orden
                            if (orderId is Map<String, dynamic> && orderId.containsKey('failure')) {
                              if ( orderId['failure'] == -1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(orderId['Error'],),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } 
                            } else {
                              print('orderId no es un mapa válido o no contiene la propiedad "failure"');
                            }
        
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Orden de venta guardada correctamente con ID: $orderId'),
                                  ),
                                );
                              
                        numeroReferenciaController.clear();
                        descripcionController.clear();
                        montoController.clear();
                        numeroFacturaController.clear();
        
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
