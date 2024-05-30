
import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/precios/helpers/show_filters.dart';
import 'package:flutter/material.dart';








  class Precios extends StatefulWidget {
    const Precios({super.key});

  @override
  State<Precios> createState() => _PreciosState();
}



class _PreciosState extends State<Precios> {
  late List<Map<String, dynamic>> products = [];
  TextEditingController searchController = TextEditingController();
  int selectedIndex = -1; 



 Future<void> _loadProducts() async {
    final productos = await getProducts(); // Obtener todos los productos

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
    final colorPrimary = Theme.of(context).colorScheme.primary;
    final screenMedia = MediaQuery.of(context).size.width * 0.8;

  return Stack(
    children:[ 
      
      Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            
            const AppBars(labelText: 'Precios'),

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
                              color: Colors.grey
                                  .withOpacity(0.2), // Color de la sombra
                              spreadRadius: 2, // Extensión de la sombra
                              blurRadius: 3, // Difuminado de la sombra
                              offset: const Offset(
                                  0, 2), // Desplazamiento de la sombra
                            ),
                          ],
                        ),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    if (searchController.text.isNotEmpty) {
                      setState(() {
                      
                      });
                    }
                      
                  },
                  decoration:  InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                                  vertical: 3.0, horizontal: 20.0), 
                    hintText: 'Nombre del producto',
                    labelStyle: const TextStyle( color: Colors.black, fontFamily: 'Poppins Regular'),
                    suffixIcon:Image.asset('lib/assets/Lupa.png'),
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
        )

        ) ,
    
      body: GestureDetector(
        onTap: () {

            FocusScope.of(context).requestFocus(FocusNode());
        
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                           const SizedBox(height: 25,),
                                  IconButton(
                                    icon: Image.asset(
                                      'lib/assets/filtro@3x.png',
                                      width: 25,
                                      height: 35,
                                    ),
                                    onPressed: () async {
                                      dynamic productse =  await showFilterOptions(context, products);
                      
                                                          
                                      
                                        setState(() {
                                          products = productse;
                                        });
                                    },
                                  ),
                                          
                          const SizedBox(height: 10,),    
              
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
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = index; // Actualiza el índice del contenedor seleccionado al tocarlo
          });
        },
        child: Container(
          width: screenMedia * 0.9,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: selectedIndex == index ? Color(int.parse('0xFF7531FF')).withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                blurRadius: 7,
                spreadRadius: 2,
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              product['name'],
              style: const TextStyle(fontFamily: 'Poppins SemiBold'),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                     Icon(Icons.category, color: colorPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Categoría: ${product['categoria']}',
                      style: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     Icon(Icons.attach_money, color: colorPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Precio: \$${product['pricelistsales'] is int || product['pricelistsales'] is double ? product['pricelistsales'] : 0}',
                      style: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                     Icon(Icons.inventory, color: colorPrimary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Cantidad disponible: ${product['quantity'] is double || product['quantity'] is int ? product['quantity'] : 0}',
                      style: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ),
),

                ],
              ),
            ],
          ),
        ),
      ),
    ),

  ]
  );
  
  }

}









