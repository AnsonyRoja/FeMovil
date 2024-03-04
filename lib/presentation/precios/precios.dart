import 'dart:io';

import 'package:femovil/database/create_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';







  class Precios extends StatefulWidget {
    const Precios({super.key});

  @override
  State<Precios> createState() => _PreciosState();
}



class _PreciosState extends State<Precios> {
  late List<Map<String, dynamic>> products = [];
  TextEditingController searchController = TextEditingController();



void _showFilterOptions(BuildContext context) {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;

  showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(
        Offset(0, 0), // Punto de inicio en la esquina superior izquierda
        Offset(0, 0), // Punto de fin en la esquina superior izquierda
      ),
      overlay.localToGlobal(Offset.zero) & overlay.size, // Tamaño del overlay
    ),
    items: <PopupMenuEntry>[
      PopupMenuItem(
        child: ListTile(
          title: Text('Filtrar por mayor precio'),
          onTap: () {
            Navigator.pop(context);
            _filterByMaxPrice();
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          title: Text('Filtrar por menor precio'),
          onTap: () {
            Navigator.pop(context);
            _filterByMinPrice();
          },
        ),
      ),
    ],
  );
}



void _filterByMaxPrice() {
  List<Map<String, dynamic>> sortedProducts = List.from(products); // Crear una nueva lista para evitar modificar la original
  sortedProducts.sort((a, b) => b['price'].compareTo(a['price'])); // Ordena de forma descendente por precio
  setState(() {
    products = sortedProducts; // Actualiza la lista original con la lista ordenada
  });
}

void _filterByMinPrice() {
  List<Map<String, dynamic>> sortedProducts = List.from(products); // Crear una nueva lista para evitar modificar la original
  sortedProducts.sort((a, b) => a['price'].compareTo(b['price'])); // Ordena de forma ascendente por precio
  setState(() {
    products = sortedProducts; // Actualiza la lista original con la lista ordenada
  });
}




 Future<void> _loadProducts() async {
    final productos = await DatabaseHelper.instance.getProducts(); // Obtener todos los productos

    print("Estoy obteniendo products $products");
    setState(() {
      products = productos;
    });
  }

@override
  void initState() {

      _loadProducts();

    super.initState();
  }

    @override
Widget build(BuildContext context) {
  return Stack(
    children:[ 
      
      Scaffold(
      appBar: AppBar(leading: IconButton(
                      icon: Image.asset(
                        'lib/assets/Ajustes.png',
                        width: 25,
                        height: 35,
                      ),
                      onPressed: () {
                        _showFilterOptions(context);
                      },
                    ), title: const Text("Lista de precios", style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 102, 102),
            ),),
                    backgroundColor: const Color.fromARGB(255, 236, 247, 255),
    
                    ),
                    backgroundColor: const Color.fromARGB(255, 236, 247, 255),
    
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                 if (searchController.text.isNotEmpty &&
                    !product['name']
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                  return const SizedBox.shrink(); // Oculta el elemento si no coincide con la búsqueda
                }
                return Card(
                  elevation: 4, // Agrega una sombra al Card para un efecto visual
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Margen alrededor del Card
                  child: ListTile(
                    leading: product['image_path'] != "" ? Image.file(File(product['image_path'])) : const Text("Not found"), // Muestra la imagen del producto
                    title: Text(product['name']), // Muestra el nombre del producto
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Categoria: ${product['categoria']}'),
                        Text('Precio: \$${product['price']}'),
                        Text('Cantidad disponible ${product['quantity']}'),
                        const Divider(),
                      ],
                    ), 
                    
                    // Otros detalles del producto...
                  ),
                );
              
              },
            ),
          ),
        ],
      ),
    ),
     Positioned(
        left: 16,
        bottom: 20,
        child: IconButton(
  icon: const Icon(
    FeatherIcons.arrowLeftCircle, // Ícono de flecha hacia atrás de la biblioteca Flutter Feather Icons
    color: Colors.blue, // Cambia el color del ícono
    size: 40, // Cambia el tamaño del ícono
  ),
  onPressed: () {
    Navigator.pop(context);
  },
),)


  ]
  );
  
  }
}









