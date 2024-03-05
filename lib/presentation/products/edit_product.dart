import 'package:femovil/database/create_database.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  final _maxStockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product details
    _nameController.text = widget.product['name'].toString();
    _categoryController.text = widget.product['categoria'].toString();
    _priceController.text = widget.product['price'].toString();
    _quantityController.text = widget.product['quantity'].toString();
    _minStockController.text = widget.product['min_stock'].toString();
    _maxStockController.text = widget.product['max_stock'].toString();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

       FocusScope.of(context).requestFocus(FocusNode());

      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar Producto",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 102, 102),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _buildTextFormField('Nombre', _nameController),
                  _buildTextFormField('Categoría', _categoryController),
                  _buildTextFormField('Precio', _priceController),
                  _buildTextFormField('Cantidad Disponible', _quantityController),
                  _buildTextFormField('Stock Mínimo', _minStockController),
                  _buildTextFormField('Stock Máximo', _maxStockController),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           String newName = _nameController.text;
    String newCategory = _categoryController.text;
    double newPrice = double.parse(_priceController.text);
    int newQuantity = int.parse(_quantityController.text);
    int newMinStock = int.parse(_minStockController.text);
    int newMaxStock = int.parse(_maxStockController.text);

    // Crear un mapa con los datos actualizados del producto
    Map<String, dynamic> updatedProduct = {
      'id': widget.product['id'], // Asegúrate de incluir el ID del producto
      'name': newName,
      'categoria': newCategory,
      'price': newPrice,
      'quantity': newQuantity,
      'min_stock': newMinStock,
      'max_stock': newMaxStock,
    };

    // Actualizar el producto en la base de datos
    await DatabaseHelper.instance.updateProduct(updatedProduct);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Producto actualizado satisfactoriamente'),
            duration: Duration(seconds: 2), 
            backgroundColor: Colors.green,
          ),
        );

    // Cerrar la pantalla de edición después de actualizar el producto
    Navigator.pop(context);
          },
          backgroundColor: Colors.blue, // Color del botón
          child: const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }
}
