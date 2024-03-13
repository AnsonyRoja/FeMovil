import 'package:femovil/assets/nav_bottom_menu.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/clients/add_clients.dart';
import 'package:femovil/presentation/clients/clients_details.dart';
import 'package:femovil/presentation/clients/filter_dialog_clients.dart';
import 'package:flutter/material.dart';






class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
 String _filter = "";
  late List<Map<String, dynamic>> clients = [];
  List<Map<String, dynamic>> searchClient = [];
  TextEditingController searchController = TextEditingController();
  String input = "";

  Future<void> _loadClients() async {
    final clientes = await DatabaseHelper.instance.getClients(); // Obtener todos los productos

    print("Estoy obteniendo Clientes $clientes");
    setState(() {
      clients = clientes;
      searchClient = clientes;
    });


  }


  void _showFilterOptions(BuildContext context) async {
    final selectedFilter = await showDialog<String>(
      context: context,
      builder: (context) => FilterGroups(clients: clients,), // Reemplaza YourFilterDialog con tu widget de filtro
    );

    print("Esto es el valor del select $selectedFilter");

    if (selectedFilter != null) {
      setState(() {
        _filter = selectedFilter;
        print("Esto es el filter $_filter");
      });
    }
  }


  

  @override
  void initState(){

      _loadClients();
      super.initState();

  }

  
  @override
  Widget build(BuildContext context) {

     if(input == ""){

        searchClient = clients.toList();

    }
 
    if (_filter != "" && input == "") {
        setState(() {
          if (_filter == "Todos") {
            print("entre aqui");
            searchController.clear();
            input = "";

            searchClient = clients.toList();
          } else {
            searchClient = clients.where((client) => client['grupo'] == _filter).toList();
            print("Este es el searchClient $searchClient");
          }
          input = ""; // Limpiar el campo de búsqueda al filtrar por categoría
        });
      } else if (input != "") {
        print("Estoy entrando en el input cuando no esta vacio ");
        setState(() {
          searchClient = clients.where((client) {
            final name = client['name'].toString().toLowerCase();
            final ruc = client['ruc'].toString().toLowerCase();
            final inputLower = input.toLowerCase();
            return name.contains(inputLower) || ruc.contains(inputLower);
          }).toList();
          print("Estos son los clientes por grupo $searchClient $input");
        });
      }

      if(_filter != "" && _filter != "Todos"){
          
          searchClient = clients.where((client) => client['grupo'] == _filter).toList();
          searchController.clear();
          input = "";
      }else if(_filter == "Todos"){
          searchController.clear();
          input = "";
    
            searchClient = clients.toList();
      }


        final screenMax = MediaQuery.of(context).size.width * 0.8;

    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        title: const Text(
          "Clientes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 102, 102),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
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
      ),
      body:  Padding(
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
                    print("esto es lo que tiene ${_filter}");
      
                    if (searchController.text.isNotEmpty) {
                    setState(() {
                         _filter = "";
                        print("ESto es la categoria en blanco ${_filter}");
                    });
                  }
                  
               setState(() {
                input = value;
              print("Este es el valor $value");

                searchClient = clients.where((client) {
                  final valueLower = value.toLowerCase();
                  if (int.tryParse(valueLower) != null) {
                    // Si el valor se puede convertir a un número entero, buscar por ruc
                    final ruc = client['ruc'].toString().toLowerCase();
                    return ruc.contains(valueLower);
                  } else {
                    // Si no se puede convertir a un número entero, buscar por nombre
                    final name = client['name'].toString().toLowerCase();
                    return name.contains(valueLower);
                  }
                }).toList();


                  print("cual es el valor de filteredproducts $searchClient");
                });
      
                },
                decoration: const InputDecoration(
                  labelText: 'Buscar por nombre o Ruc',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: searchClient.length,
                itemBuilder: (context, index) {
      
                  final client = searchClient[index];
      
      
      
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenMax,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(' RUC ${client['ruc'].toString()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          width: screenMax,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nombre: ${client['name']}'),
                                Text('Ruc: ${client['ruc'].toString()}'),
                                Text('Correo: ${client['correo']}'),
                                Text('Telefono: ${client['telefono'].toString()}'),
                                Text('Grupo: ${client['grupo']}'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _verMasClient('${client['id']}'),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.white,
                                fixedSize: Size(screenMax, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Ver más'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
           

          ],
        ),
      ),
        
      ),
      bottomNavigationBar:  CustomBottomNavigationBar(
          onAddPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddClientsForm()),
              );
            },
            onRefreshPressed: () {
              _loadClients();
            },
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
    );
  }

    void _verMasClient(String clientId) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      final client = await db.query(
        'clients',
        where: 'id = ?',
        whereArgs: [int.parse(clientId)],
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientDetailsScreen(client: client.first)),
      );
    } else {
      print('Error: db is null');
    }
  }
}



