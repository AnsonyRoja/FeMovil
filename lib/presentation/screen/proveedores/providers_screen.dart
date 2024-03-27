import 'package:femovil/assets/nav_bottom_menu.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/screen/proveedores/add_proveedor.dart';
import 'package:femovil/presentation/screen/proveedores/filter_dialog_providers.dart';
import 'package:femovil/presentation/screen/proveedores/providers_details.dart';

import 'package:flutter/material.dart';






class Providers extends StatefulWidget {
  const Providers({super.key});

  @override
  State<Providers> createState() => _ProvidersState();
}

class _ProvidersState extends State<Providers> {
 String _filter = "";
  late List<Map<String, dynamic>> providers= [];
  List<Map<String, dynamic>> searchProvider = [];
  TextEditingController searchController = TextEditingController();
  String input = "";

  Future<void> _loadProviders() async {
    final proveedores = await getProviders(); // Obtener todos los productos

    print("Estoy obteniendo proveedores $proveedores");
    setState(() {
      providers = proveedores;
      searchProvider = proveedores;
    });


  }


  void _showFilterOptions(BuildContext context) async {
    final selectedFilter = await showDialog<String>(
      context: context,
      builder: (context) => FilterGroupsProviders(providers: providers,), // Reemplaza YourFilterDialog con tu widget de filtro
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

      _loadProviders();
      super.initState();

  }

  
  @override
  Widget build(BuildContext context) {

     if(input == ""){

        searchProvider = providers.toList();

    }
 
    if (_filter != "" && input == "") {
        setState(() {
          if (_filter == "Todos") {
            print("entre aqui");
            searchController.clear();
            input = "";

            searchProvider = providers.toList();
          } else {
            searchProvider = providers.where((provider) => provider['grupo'] == _filter).toList();
            print("Este es el searchProvider $searchProvider");
          }
          input = ""; // Limpiar el campo de búsqueda al filtrar por categoría
        });
      } else if (input != "") {
        print("Estoy entrando en el input cuando no esta vacio ");
        setState(() {
          searchProvider = providers.where((provider) {
            final name = provider['name'].toString().toLowerCase();
            final ruc = provider['ruc'].toString().toLowerCase();
            final inputLower = input.toLowerCase();
            return name.contains(inputLower) || ruc.contains(inputLower);
          }).toList();
          print("Estos son los proveedores por grupo $searchProvider $input");
        });
      }

      if(_filter != "" && _filter != "Todos"){
          
          searchProvider = providers.where((provider) => provider['grupo'] == _filter).toList();
          searchController.clear();
          input = "";
      }else if(_filter == "Todos"){
          searchController.clear();
          input = "";
    
            searchProvider = providers.toList();
      }


        final screenMax = MediaQuery.of(context).size.width * 0.8;

    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        title: const Text(
          "Proveedores",
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

                searchProvider = providers.where((provider) {
                  final valueLower = value.toLowerCase();
                  if (int.tryParse(valueLower) != null) {
                    // Si el valor se puede convertir a un número entero, buscar por ruc
                    final ruc = provider['ruc'].toString().toLowerCase();
                    return ruc.contains(valueLower);
                  } else {
                    // Si no se puede convertir a un número entero, buscar por nombre
                    final name = provider['name'].toString().toLowerCase();
                    return name.contains(valueLower);
                  }
                }).toList();


                  print("cual es el valor de filteredproducts $searchProvider");
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
                itemCount: searchProvider.length,
                itemBuilder: (context, index) {
      
                  final provider = searchProvider[index];
      
      
      
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
                            child: Text(' RUC ${provider['ruc'].toString()}',
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
                                Text('Nombre: ${provider['name']}'),
                                Text('Ruc: ${provider['ruc'].toString()}'),
                                Text('Correo: ${provider['correo']}'),
                                Text('Telefono: ${provider['telefono'].toString()}'),
                                Text('Grupo: ${provider['grupo']}'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _verMasprovider('${provider['id']}'),
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
      bottomNavigationBar: CustomBottomNavigationBar(
          onAddPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddProvidersForm()),
              );
            },
            onRefreshPressed: () {
              _loadProviders();
            },
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),

    );
  }

    void _verMasprovider(String providerId) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      final provider = await db.query(
        'providers',
        where: 'id = ?',
        whereArgs: [int.parse(providerId)],
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProvidersDetailsScreen(provider: provider.first)),
      );
    } else {
      print('Error: db is null');
    }
  }
}


