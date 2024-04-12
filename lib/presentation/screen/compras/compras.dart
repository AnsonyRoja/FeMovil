import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/cobranzas/cobro.dart';
import 'package:femovil/presentation/screen/compras/compras_details.dart';
import 'package:femovil/presentation/screen/ventas/ventas_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class Compras extends StatefulWidget {
  const Compras({super.key});

  @override
  State<Compras> createState() => _ComprasState();
}

class _ComprasState extends State<Compras> {
  String _filter = "";
  DateTimeRange? _selectedDateRange; // Declare and initialize to null

  late List<Map<String, dynamic>> compras = [];
  List<Map<String, dynamic>> filteredCompras = [];
  TextEditingController searchController = TextEditingController();
    TextEditingController inputValue = TextEditingController();

  String input = "";
  int? searchValue;

      Future<void> _loadCompras() async {
        final comprasData = await getAllOrdersWithVendorsNames(); // Cambiar a la función de obtener ventas

            print("Esto es la venta Data $comprasData");

            setState(() {
              compras = comprasData;
              filteredCompras = comprasData;
            });
      }

  @override
  void initState() {
    _loadCompras();
    super.initState();
  }

void _filterByMaxPrice(double maxPrice) {
  setState(() {
    filteredCompras = compras.where((venta) => venta['monto'] <= maxPrice).toList();
    filteredCompras.sort((a, b) => b['monto'].compareTo(a['monto'])); // Ordena las ventas de mayor a menor monto
  });
}

void _showDateRangePicker(BuildContext context) async {
    // Enhanced user experience with custom date range and better initial selection
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: DateTime.now().subtract(const Duration(days: 7)), // Default to past week
        end: DateTime.now(),
      ),
      firstDate: DateTime(2010), // Adjust minimum year based on your requirements
      lastDate: DateTime.now().add(const Duration(days: 365)), // Extend to a year from now
    );

    print("esto es picked $picked");
    if (picked != null) {
      print("Entre aqui");
      setState(() {
        _selectedDateRange = picked;
        _sortByDateRange(picked.start, picked.end);
      });
    }
  }

void _sortByDateRange(DateTime start, DateTime end) {
  // Guardar start y end en variables locales
  final startDate = start;
  final endDate = end;

  print("fecha start $start y fecha end $end");
  setState(() {
    filteredCompras = compras.where((venta) {
      final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
          try {
            if (venta['fecha'] != null && venta['fecha'] != '') {
              print("ventas  ${venta['fecha']}");
              final ventaDate = dateFormat.parse(venta['fecha']);
              return ventaDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
                    ventaDate.isBefore(endDate.add(const Duration(days: 1)));
            } else {
              // La fecha está en blanco, por lo tanto, no cumple con la condición
              return false;
            }
          } catch (e) {
            print('Error al parsear la fecha: $e');
            return false; // O maneja el error de otra manera
          }
    }).toList();
      print("entre aqui para el sort o algoritmo de ordenamiento");
      print("FItered Ventas $filteredCompras " );
    // Ordena las ventas dentro del rango de fechas seleccionado
        filteredCompras.sort((a, b) {
          final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
          final DateTime dateA = inputFormat.parse(a['fecha']);
          final DateTime dateB = inputFormat.parse(b['fecha']);
          
          // Formatea las fechas como "yyyy-mm-dd" antes de compararlas
          final String formattedDateA = '${dateA.year}-${dateA.month.toString().padLeft(2, '0')}-${dateA.day.toString().padLeft(2, '0')}';
          final String formattedDateB = '${dateB.year}-${dateB.month.toString().padLeft(2, '0')}-${dateB.day.toString().padLeft(2, '0')}';
          
          return formattedDateA.compareTo(formattedDateB);
        });
    
      });
}

void _showMaxPriceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Ingrese el monto máximo'),
        content: TextField(
          controller: inputValue, // Controlador para el campo de entrada
          keyboardType: TextInputType.number, // Teclado numérico para ingresar el monto
          decoration: const InputDecoration(hintText: 'Ingrese el monto máximo'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              // Obtener el valor ingresado por el usuario
              
              final double maxPrice = double.tryParse(inputValue.text) ?? 0.0; // Convertir a double
              print("esto es el maxprice ${inputValue.text}");
              _filterByMaxPrice(maxPrice);
              Navigator.of(context).pop();
            },
            child: const Text('Aceptar'),
          ),
        ],
      );
    },
  );
}


void _showFilterOptions(BuildContext context) {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        const Offset(0, 0), // Punto de inicio en la esquina superior izquierda
        const Offset(0, 0), // Punto de fin en la esquina superior izquierda
      ),
      overlay.localToGlobal(Offset.zero) & overlay.size, // Tamaño del overlay
    ),
    items: <PopupMenuEntry>[
      PopupMenuItem(
        child: ListTile(
          title: const Text('Filtrar Por el monto Mayor'),
          onTap: () {
            Navigator.pop(context);
            _showMaxPriceDialog(context);
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          title: const Text('Ordenar por un rango de fecha'),
          onTap: () {
            Navigator.pop(context);
              _showDateRangePicker(context);
        
        },
        ),
      ),
 
    ],
  );
}

  @override
  Widget build(BuildContext context) {
        
        final screenMax = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 247, 255),

      appBar: AppBar(title: const Text("Compras", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 102, 102),
            
          ),),
            backgroundColor: const Color.fromARGB(255, 236, 247, 255),
       leading: IconButton(
                    icon: Image.asset(
                      'lib/assets/Ajustes.png',
                      width: 25,
                      height: 35,
                    ),
                    onPressed: () {
                      _showFilterOptions(context);
                    },
                  ),
       actions: [
            IconButton(onPressed: () {
                Navigator.pop(context);
            }, icon:const Icon(Icons.arrow_back_sharp) )
       ],
       iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    if (searchController.text.isNotEmpty) {
                      setState(() {
                        _filter = "";
                      });
                    }
                    setState(() {
                  filteredCompras = compras.where((compra) {
                  final numeroReferencia = compra['id'].toString();
                  final nombreProveedor = compra['nombre_proveedor'].toString().toLowerCase();
                  final orderSale = compra['documentno'].toString();
                  return numeroReferencia.contains(value) || nombreProveedor.contains(value.toLowerCase()) || orderSale.contains(value) ;
                }).toList();
                });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Buscar por número de documento o nombre',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCompras.length,
                  itemBuilder: (context, index) {
                    final compra = filteredCompras[index];
                    
                    print('esto es ventas $compra');

                    return Column(
                      children: [
                        Container(  

                          width: screenMax,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("N° ${compra['documentno'] != '' ? compra['documentno'] : compra['id']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          
                        ),
                        const SizedBox(height: 7),
                         Container(
                          width: screenMax,
                           decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10.0), // Radio de borde de 10.0
                        ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${compra['nombre_proveedor']}'),
                                Text('Fecha:  ${compra['fecha']}'),
                                Text('Monto: ${compra['monto']}'),
                                Text('Descripcion: ${compra['description']}'),
                                // aqui quiero agregar los dos botones con space betwenn 
                                         
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Container(
                          width: screenMax,
                          child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                      style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    onPressed: () {
                                      // Acción al presionar el botón "Ver más"
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ComprasDetails(compraId: compra['id'], nameProveedor: compra['nombre_proveedor']),
                                          ),
                                        );
                                    },
                                    child: const Text('Ver más'),
                                  ),
                                  ElevatedButton(
                                      style: ButtonStyle(
                                      backgroundColor:compra['status_sincronized'] == 'Completado' ? MaterialStateProperty.all<Color>(Colors.green) : MaterialStateProperty.all<Color>(Colors.grey),
                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                    ),
                                    onPressed: compra['status_sincronized'] == 'Completado' ? () {
                                      // Acción al presionar el botón "Cobrar"
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => Cobro(orderId: compra['id'], loadCobranzas: _loadCompras ,saldoTotal: compra['saldo_total'], ),
                                          ),
                                        );
                                    }: null,
                                    child: const Text('Cobrar'),
                                  ),
                                ],
                              ),
                            ),  
                          const SizedBox(height: 5,),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
