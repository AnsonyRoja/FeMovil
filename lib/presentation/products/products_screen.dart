import 'package:femovil/assets/nav_bottom_menu.dart';
import 'package:femovil/config/banner_app.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/presentation/products/add_products.dart';
import 'package:femovil/presentation/products/filter_dialog.dart';
import 'package:femovil/presentation/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  late List<Map<String, dynamic>> taxes =
      []; // Lista para almacenar los impuestos

  Future<void> _loadProducts() async {
    final productos = await getProducts(); // Obtener todos los productos
    // final inserccion = await DatabaseHelper.instance.insertTaxData(); // Obtener todos los productos
    print("Estoy obteniendo products $products");

    setState(() {
      products = productos;
      filteredProducts = productos;
    });
  }

  Future<void> _deleteBaseDatos() async {
    await DatabaseHelper.instance.deleteDatabases();
  }

  void _showFilterOptions(BuildContext context) async {
    final selectedFilter = await showDialog<String>(
      context: context,
      builder: (context) => FilterCategories(
        products: products,
      ), // Reemplaza YourFilterDialog con tu widget de filtro
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
    _loadProducts();

    // _deleteBaseDatos();
    super.initState();
    // sincronizationProducts();
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();
  _loadProducts();
}

  @override
  Widget build(BuildContext context) {
    if (input == "") {
      filteredProducts = products.toList();
    }

    if (_filter != "" && input == "") {
      setState(() {
        if (_filter == "Todos") {
          searchController.clear();
          input = "";

          filteredProducts = products.toList();
        } else {
          filteredProducts = products
              .where((product) => product['categoria'] == _filter)
              .toList();
        }
        input = ""; // Limpiar el campo de búsqueda al filtrar por categoría
      });
    } else if (input != "") {
      setState(() {
        filteredProducts = products
            .where((product) =>
                product['name'].toLowerCase().contains(input.toLowerCase()))
            .toList();
      });
    }

    if (_filter != "" && _filter != "Todos") {
      filteredProducts =
          products.where((product) => product['categoria'] == _filter).toList();
      searchController.clear();
      input = "";
    } else if (_filter == "Todos") {
      searchController.clear();
      input = "";

      filteredProducts = products.toList();
    }

    final screenMax = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(170),
        child: Stack(
          clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50), // Radio del borde redondeado
            ),
            child: GestureDetector(
             
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFF7531FF), // Color hexadecimal
                flexibleSpace: Stack(
                  children: [
                    CustomPaint(
                      painter: CirclePainter(),
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 55,),
                          Text(
                            'Productos',
                            style: TextStyle(
                              fontFamily: 'Poppins ExtraBold',
                              color: Colors.white,
                              fontSize: 30, // Tamaño del texto
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2, 2),
                                  blurRadius: 3.0,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      
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
                        _filter = "";
                      });
                    }
                      
                    setState(() {
                      input = value;
                      filteredProducts = products
                          .where((product) =>
                              product['name'].toLowerCase().contains(value.toLowerCase()))
                          .toList();
                    });
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
      ),
    ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
            const SizedBox(height: 25,),

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

              const SizedBox(height: 10,),
             
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
                              color: const Color(0xFFF0EBFC),
                              borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5), // Color de la sombra
                                  spreadRadius: 2, // Extensión de la sombra
                                  blurRadius: 5, // Difuminado de la sombra
                                  offset: const Offset(0, 3), // Desplazamiento de la sombra
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                product['categoria'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins SemiBold' ,
                                    fontSize: 18,
                                    color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Container(
                            width: screenMax,
                            decoration: BoxDecoration(
                             color: const Color(0xFFFFFFFF),

                                  boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5), // Color de la sombra
                                    spreadRadius: 2, // Extensión de la sombra
                                    blurRadius: 5, // Difuminado de la sombra
                                    offset: const Offset(0, 3), // Desplazamiento de la sombra
                                  ),
                                ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Nombre: ${product['name']}'),
                                      Text(
                                          'Precio: \$${product['price'] is double ? product['price'] : 0}'),
                                      Text(
                                          'Cantidad: ${product['quantity'] is int ? product['quantity'] : 0}'),
                                    ],
                                  ),
                                 GestureDetector(
                                    onTap: () {
                                      
                                 _verMasProducto('${product['id']}');


                                    },
                                    child: Row(
                                      children: [
                                        const Text('Ver', style: TextStyle(color:  Color(0xFF7531FF)),),
                                        const SizedBox(width: 10,),
                                        Image.asset('lib/assets/Lupa-2@2x.png', width: 25,),
                                      ],
                                    ),
                                  )


                                ],
                              ),
                            ),
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
      bottomNavigationBar: CustomBottomNavigationBar(
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductForm()),
          );
        },
        onRefreshPressed: () {
          _loadProducts();
        },
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _verMasProducto(String productId) async {
    print('productId: $productId'); // Añade esta línea para depurar

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      final product = await db.query(
        'products',
        where: 'id = ?',
        whereArgs: [int.parse(productId)],
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product.first)),
      );
    } else {
      print('Error: db is null');
    }
  }
}
