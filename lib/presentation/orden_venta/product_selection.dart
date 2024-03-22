import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:flutter/material.dart';

class ProductSelectionScreen extends StatefulWidget {
  @override
  _ProductSelectionScreenState createState() => _ProductSelectionScreenState();
}

class _ProductSelectionScreenState extends State<ProductSelectionScreen> {
  List<Map<String, dynamic>>? products;  // Lista de productos
  List<Map<String, dynamic>> filteredProducts = []; // Lista de productos filtrados
  List<Map<String, dynamic>> selectedProducts = []; // Lista de productos seleccionados
  Map<String, int> productQuantities = {}; // Mapa para almacenar las cantidades seleccionadas por producto

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final productList = await getProductsAndTaxes(); // Obtener todos los productos

      print('Esto es el productlist $productList');
    setState(() {
      products = productList;
      filteredProducts = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final String? searchText = await showSearch<String>(
                context: context,
                delegate: ProductSearchDelegate(products!),
              );

              if (searchText != null && searchText.isNotEmpty) {
                _filterProducts(searchText);
              }
            },
          ),
        ],
      ),
      body: filteredProducts.isNotEmpty
          ? ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final productName = filteredProducts[index]['name'];
                final productPrice = filteredProducts[index]['price'];
                final isSelected = selectedProducts.any((product) => product['name'] == productName);
                final quantity = productQuantities[productName] ?? 0; // Obtener la cantidad seleccionada o 0 si no hay ninguna
                
                return ListTile(
                  title: Text(productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Precio: \$${productPrice.toStringAsFixed(2)}'),
                      Text('Cantidad disponible: ${filteredProducts[index]['quantity']}'),
                      Text('Cantidad Seleccionada: $quantity'),
                      
                    ],
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.green) // Icono de check si el producto está seleccionado
                      : null,
                  onTap: () async {
                    final selectedQuantity = await _showQuantityPickerDialog(context, productName, quantity);
                    if (selectedQuantity != null) {
                          if (selectedQuantity > 0) {

                      final selectedProductIndex = selectedProducts.indexWhere((product) => product['name'] == productName);
                      final int newQuantity = selectedQuantity; // Sumar la cantidad seleccionada anteriormente con la nueva cantidad seleccionada

                      final selectedProduct = {
                        "id": filteredProducts[index]['id'], // Agregar el ID del producto seleccionado
                        "name": productName,
                        "quantity_avaible" : filteredProducts[index]['quantity'],
                        "quantity": newQuantity, // Usar la nueva cantidad calculada
                        "price": productPrice,
                        "impuesto": filteredProducts[index]['tax_rate']
                      };

                      setState(() {
                        print("que tiene newquantity $newQuantity");
                        if (isSelected) {
                          // Si el producto ya estaba seleccionado, actualiza su cantidad en lugar de eliminarlo
                          selectedProducts[selectedProductIndex] = selectedProduct;
                        } else {
                          if (newQuantity > 0 && newQuantity <= filteredProducts[index]['quantity']) {
                            selectedProducts.add(selectedProduct);
                          } else {
                            // Aquí puedes agregar una notificación o manejar la situación de otra manera
                            print('La cantidad seleccionada es mayor que la cantidad disponible');
                          }
                        }
                        productQuantities[productName] = newQuantity; // Actualizar la cantidad en el mapa de cantidades
                      });
                    } else{

                      setState(() {
                        selectedProducts.removeWhere((product) => product['name'] == productName);
                        productQuantities.remove(productName);
                      });

                    }
                    }
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ), // Muestra un indicador de carga mientras se cargan los productos
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, selectedProducts); // Devuelve los productos seleccionados al presionar el botón de regresar
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Future<int?> _showQuantityPickerDialog(BuildContext context, String productName, dynamic quantity) {
    int selectedQuantity = quantity; // Inicializar selectedQuantity con la cantidad pasada por parámetro

    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true, // Permitir que el contenido haga scroll si es necesario
      builder: (BuildContext context) {
        return SingleChildScrollView( // Envolver el contenido con SingleChildScrollView
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Seleccione la cantidad de $productName',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (selectedQuantity > 0) {
                                selectedQuantity--;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          selectedQuantity.toString(),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              final availableQuantity = filteredProducts.firstWhere((product) => product['name'] == productName)['quantity'];
                              if (selectedQuantity < availableQuantity) {
                                selectedQuantity++;
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   SnackBar(
                                //     content: Text('No se puede incrementar más. No hay suficientes productos disponibles.'),
                                //   ),
                                // );
                              }
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedQuantity);
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _filterProducts(String searchText) {
    setState(() {
      filteredProducts = products!.where((product) => product['name'].toLowerCase().contains(searchText.toLowerCase())).toList();
    });
  }
}

class ProductSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> products;

  ProductSearchDelegate(this.products);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => close(context, ''));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final filteredProducts = products.where((product) => product['name'].toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final productName = filteredProducts[index]['name'];
        return ListTile(
          title: Text(productName),
          onTap: () {
            close(context, productName);
          },
        );
      },
    );
  }
}
