import 'package:femovil/assets/nav_bottom_menu.dart';
import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/clients/add_clients.dart';
import 'package:femovil/presentation/clients/clients_details.dart';
import 'package:femovil/presentation/clients/filter_dialog_clients.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  List<Map<String, dynamic>> filteredClients = [];

  String input = "";

  Future<void> _loadClients() async {
    final clientes = await getClients(); // Obtener todos los productos

    print("Estoy obteniendo Clientes $clientes");
    setState(() {
      clients = clientes;
      searchClient = clientes;
    });
  }

  void _showFilterOptions(BuildContext context) async {
    final selectedFilter = await showDialog<String>(
      context: context,
      builder: (context) => FilterGroups(
        clients: clients,
      ),
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
  void initState() {
    // print("Esto es la variable global ${variablesG[0]['m_pricelist_id']}");
    _loadClients();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (input == "") {
      searchClient = clients.toList();
    }

    if (_filter != "" && input == "") {
      setState(() {
        if (_filter == "Todos") {
          searchController.clear();
          input = "";

          searchClient = clients.toList();
        } else {
          searchClient = clients
              .where((client) => client['group_bp_name'] == _filter)
              .toList();
          print("Este es el searchClient $searchClient");
        }
        input = ""; // Limpiar el campo de búsqueda al filtrar por categoría
      });
    } else if (input != "") {
      print("Estoy entrando en el input cuando no esta vacio ");
      setState(() {
        searchClient = clients.where((client) {
          final name = client['bp_name'].toString().toLowerCase();
          final ruc = client['ruc'].toString().toLowerCase();
          final inputLower = input.toLowerCase();
          return name.contains(inputLower) || ruc.contains(inputLower);
        }).toList();
        print("Estos son los clientes por grupo $searchClient $input");
      });
    }

    if (_filter != "" && _filter != "Todos") {
      searchClient = clients
          .where((client) => client['group_bp_name'] == _filter)
          .toList();
      searchController.clear();
      input = "";
    } else if (_filter == "Todos") {
      searchController.clear();
      input = "";

      searchClient = clients.toList();
    }

    final screenMax = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const AppBars(labelText: 'Clientes'),
            Positioned(
              left: 16,
              right: 16,
              top: 160,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        9.0), // Ajusta el radio de las esquinas
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Color de la sombra
                        spreadRadius: 2, // Extensión de la sombra
                        blurRadius: 3, // Difuminado de la sombra
                        offset:
                            const Offset(0, 2), // Desplazamiento de la sombra
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      if (searchController.text.isNotEmpty) {
                        setState(() {
                          _filter = "";
                        });
                      }

                      setState(() {
                        input = value;
                        filteredClients = clients;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 3.0, horizontal: 20.0),
                      hintText: 'Nombre del Cliente o RUC',
                      labelStyle: const TextStyle(
                          color: Colors.black, fontFamily: 'Poppins Regular'),
                      suffixIcon: Image.asset('lib/assets/Lupa.png'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  // Cierra el teclado tocando en cualquier parte del Stack
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  IconButton(
                    icon: Image.asset(
                      'lib/assets/filtro@3x.png',
                      width: 25,
                      height: 35,
                    ),
                    onPressed: () {
                      _showFilterOptions(context);
                    },
                  ),
                  const SizedBox(
                    height: 10,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 130,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            child: Container(
                                              height: 50,
                                              width: screenMax,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF0EBFC),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  client['bp_name'].toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Poppins Bold',
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 55,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                width: screenMax * 0.9,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'RUC/DNI: ',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins SemiBold'),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    screenMax *
                                                                        0.45,
                                                                child: Text(
                                                                  '${client['ruc']}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Regular'),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ))
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Correo: ',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins SemiBold'),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    screenMax *
                                                                        0.45,
                                                                child: Text(
                                                                  '${!client['email'].toString().contains('{@nil: true}') ? client['email'] : 'Sin Registro'}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Regular'),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                )),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Teléfono: ',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins SemiBold'),
                                                            ),
                                                            SizedBox(
                                                                width:
                                                                    screenMax *
                                                                        0.45,
                                                                child: Text(
                                                                  '${client['phone'] is int ? client['phone'] : 'wqeqweqweqweqweqwwwe'}',
                                                                  style: const TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Regular'),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ))
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        _verMasClient(
                                                            client['id']
                                                                .toString());
                                                      },
                                                      child: Row(
                                                        children: [
                                                          const Text('Ver',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFF7531FF))),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image.asset(
                                                              'lib/assets/Lupa-2@2x.png',
                                                              width: 25),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
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
        MaterialPageRoute(
            builder: (context) => ClientDetailsScreen(client: client.first)),
      );
    } else {
      print('Error: db is null');
    }
  }
}
