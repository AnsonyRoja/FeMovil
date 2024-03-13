import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/cobranzas/cobro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';




class Cobranzas extends StatefulWidget {
  const Cobranzas({super.key});

  @override
  State<Cobranzas> createState() => _CobranzasState();
}

class _CobranzasState extends State<Cobranzas> {
  String _filter = "";
  DateTimeRange? _selectedDateRange; // Declare and initialize to null

  late List<Map<String, dynamic>> Cobranzas = [];
  List<Map<String, dynamic>> filteredCobranzas = [];
  TextEditingController searchController = TextEditingController();
    TextEditingController inputValue = TextEditingController();

  String input = "";
  int? searchValue;

      Future<void> _loadCobranzas() async {
        final CobranzasData = await DatabaseHelper.instance.getAllOrdersWithClientNames(); // Cambiar a la función de obtener Cobranzas

            print("Esto es la venta Data $CobranzasData");

            setState(() {
              Cobranzas = CobranzasData;
              // filteredCobranzas = CobranzasData;
              filteredCobranzas = Cobranzas.where((venta) => venta['saldo_total'] > 0).toList();

              
            });
      }

  @override
  void initState() {
    _loadCobranzas();
    super.initState();
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
          title: const Text('Filtrar Por Ordenes con saldo abierto'),
          onTap: () {
            Navigator.pop(context);
            
              setState(() {
                
              filteredCobranzas = Cobranzas.where((venta) => venta['saldo_total'] > 0).toList();
              });


          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          title: const Text('Filtrar Por Ordenes con saldo pagado'),
          onTap: () {
            Navigator.pop(context);
            setState(() {
              
             filteredCobranzas = Cobranzas.where((venta) => venta['saldo_total'] == 0).toList();
            });

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

      appBar: AppBar(title: const Text("Cobranzas", style: TextStyle(
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
          }, icon: const Icon(Icons.arrow_back))
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
                  filteredCobranzas = Cobranzas.where((venta) {
                  final numeroReferencia = venta['numero_referencia'].toString();
                  final nombreCliente = venta['nombre_cliente'].toString();
                  return numeroReferencia.contains(value) || nombreCliente.contains(value);
                }).toList();
                });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Buscar por número de referencia o nombre',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCobranzas.length,
                  itemBuilder: (context, index) {
                  
                    final venta = filteredCobranzas[index];
                    return  Column(
                      children: [
                        Container(  

                          width: screenMax,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("N° ${venta['numero_referencia']}",
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
                                Text('Nombre: ${venta['nombre_cliente']}'),
                                Text('Fecha:  ${venta['fecha']}'),
                                Text('Monto: ${venta['monto']}'),
                                Text('Descripcion: ${venta['descripcion']}'),
                                // aqui quiero agregar los dos botones con space betwenn 
                                     
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: screenMax,
                          child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [                             
                              SizedBox(
                                width: screenMax,
                                height: 50,
                                child: GestureDetector(
                                  onTap: venta['saldo_total'] > 0 ?   () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                          builder: (context) =>  Cobro(orderId: venta['id'],saldoTotal: venta['saldo_total'], loadCobranzas: _loadCobranzas),
                                        ),
                                      );

                                  }:null ,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10), // Radio de los bordes redondeados
                                    child: Container(
                                      color: venta['saldo_total'] > 0 ? Colors.green : const Color.fromARGB(255, 194, 190, 190),
                                      child: const Center(
                                        child: Text('Cobrar', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              

                            ],
                          ),

                        ),  
                            const SizedBox(height: 10,),
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
