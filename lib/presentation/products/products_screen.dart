import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/products/add_products.dart';
import 'package:femovil/presentation/products/filter_dialog.dart';
import 'package:femovil/presentation/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';






class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
 String _filter = "";
  late List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  TextEditingController searchController = TextEditingController();
  String input = "";

  Future<void> _loadProducts() async {
    final productos = await DatabaseHelper.instance.getProducts(); // Obtener todos los productos

    print("Estoy obteniendo products $products");
    setState(() {
      products = productos;
      filteredProducts = productos;
    });
  }


  Future<void> _deleteBaseDatos() async {
    final productos = await DatabaseHelper.instance.deleteDatabases(); // Obtener todos los productos
      

  }


  void _showFilterOptions(BuildContext context) async {
    final selectedFilter = await showDialog<String>(
      context: context,
      builder: (context) => FilterCategories(products: products,), // Reemplaza YourFilterDialog con tu widget de filtro
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
      _loadProducts();
      // _deleteBaseDatos();
      super.initState();
  }

  
  @override
  Widget build(BuildContext context) {

     if(input == ""){

        filteredProducts = products.toList();

    }
 
    if (_filter != "" && input == "") {
        setState(() {
          if (_filter == "Todos") {
            print("entre aqui");
            searchController.clear();
            input = "";

            filteredProducts = products.toList();
          } else {
            filteredProducts = products.where((product) => product['categoria'] == _filter).toList();
          }
          input = ""; // Limpiar el campo de búsqueda al filtrar por categoría
        });
      } else if (input != "") {
        setState(() {
          filteredProducts = products.where((product) => product['name'].toLowerCase().contains(input.toLowerCase())).toList();
        });
      }

      if(_filter != "" && _filter != "Todos"){
          
          filteredProducts = products.where((product) => product['categoria'] == _filter).toList();
          searchController.clear();
          input = "";
      }else if(_filter == "Todos"){
          searchController.clear();
          input = "";
    
            filteredProducts = products.toList();
      }


        final screenMax = MediaQuery.of(context).size.width * 0.8;

    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(
        title: const Text(
          "Productos",
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
                  filteredProducts = products.where((product) => product['name'].toLowerCase().contains(value.toLowerCase())).toList();
                  print("cual es el valor de filteredproducts $filteredProducts");
                });
      
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
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
      
                  final product = filteredProducts[index];
      
      
      
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
                            child: Text(
                              product['categoria'],
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
                                Text('Nombre: ${product['name']}'),
                                Text('Precio: \$${product['price']}'),
                                Text('Cantidad: ${product['quantity']}'),
                                Text('Stock mínimo: ${product['min_stock']}'),
                                Text('Stock máximo: ${product['max_stock']}'),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _verMasProducto('${product['id']}'),
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
            //esto para abajo es el navbar bottom 
                 
          ],
        ),
      ),
        
      ),
      bottomNavigationBar: Container(
  width: double.infinity, // Ancho máximo igual al ancho total de la pantalla
  decoration: BoxDecoration(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(20), // Ajusta el radio de los bordes superiores izquierdos según sea necesario
      topRight: Radius.circular(20), // Ajusta el radio de los bordes superiores derechos según sea necesario
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5), // Color de la sombra
        spreadRadius: 5, // Radio de expansión de la sombra
        blurRadius: 15, // Radio de desenfoque de la sombra
        offset: const Offset(0, 5), // Desplazamiento de la sombra
      ),
    ],
  ),
  child: BottomAppBar(
    shape:  const CircularNotchedRectangle(), // Utilizamos CircularNotchedRectangle para crear una forma de muesca redondeada

    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductForm()),
            );
          },
          child: const Icon(Icons.add),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: "btn3",
          onPressed: () {
            _loadProducts();
          },
          child: const Icon(Icons.refresh),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          heroTag: "btn4",
              onPressed: () {
                Navigator.pop(context);
              },
             child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    ),
    );
  }

    void _verMasProducto(String productId) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      final product = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [int.parse(productId)],
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product.first)),
      );
      
    } else {
      print('Error: db is null');
    }
  }
}


class ProductFilter {
  final String? category;
  final String? name;

  ProductFilter({this.category, this.name});
}
