import 'dart:io';

import 'package:femovil/presentation/products/edit_product.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("Detalles del Producto", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 102, 102),
          ),),
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
                const SizedBox( height: 25,),
                
          
                _buildTextFormField('Nombre', product['name'].toString()),
                // _buildTextFormField('Path Image', product['image_path'].toString()),
                // _buildImage(product['image_path'].toString()),
                _buildTextFormField('Categoría', product['categoria'].toString()),
                _buildTextFormField('Impuesto', product['tax_cat_name'].toString()),
                _buildTextFormField('Grupo de producto', product['product_group_name'].toString()),
                _buildTextFormField('Unidad de medida', product['um_name'].toString()),
                _buildTextFormField('Tipo de producto', product['product_type_name']),
                _buildTextFormField('Precio', '\$${product['price'] is double ? product['price']: 0}'),
                _buildTextFormField('Cantidad Disponible', product['quantity'].toString()),
          
              ],
            ),
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          heroTag: "btn1",
        onPressed: () {
          // Aquí puedes manejar la acción de edición del producto
          // Por ejemplo, puedes navegar a una pantalla de edición de productos
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EditProductScreen(product: product)),
          );
        },
        child: const Icon(Icons.edit),
        backgroundColor: Colors.green, // Color del botón
      ),
    
    );
  }

  Widget _buildTextFormField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
      ),
    );
  }
}

Widget _buildImage(String imagePath) {
  return Image.file(File(imagePath)); // Utiliza la ruta de la imagen para cargar la imagen desde el sistema de archivos
}
