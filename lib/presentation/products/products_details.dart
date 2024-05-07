import 'dart:io';

import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/presentation/products/edit_product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final double mediaScreen = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(170),
          child: AppBars(
            labelText: 'Detalles del Producto',
          )),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Align(
              alignment: Alignment.center,
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),

                    Container(
                      width: mediaScreen,
                      height: mediaScreen * 1.1,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 7,
                                spreadRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Categoría',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 18),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              product['categoria'].toString(),
                              style: const TextStyle(
                                  fontFamily: 'Poppins Regular'),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            const Text(
                              'Detalles',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 18),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Nombre: ',
                                  style: TextStyle(fontFamily: 'Poppins Bold'),
                                ),
                                Flexible(
                                    child: Text(
                                  product['name'].toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins Regular'),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Stock: ',
                                  style: TextStyle(fontFamily: 'Poppins Bold'),
                                ),
                                Flexible(
                                    child: Text(
                                  product['quantity'].toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins Regular'),
                                )),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Impuesto: ',
                                  style: TextStyle(fontFamily: 'Poppins Bold'),
                                ),
                                Flexible(
                                    child: Text(
                                  product['tax_cat_name'].toString(),
                                  style: const TextStyle(
                                      fontFamily: 'Poppins Regular'),
                                ))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Grupo: ',
                                  style: TextStyle(fontFamily: 'Poppins Bold'),
                                ),
                                Flexible(
                                    child: Text(product['product_group_name']
                                                .toString() ==
                                            '{@nil: true}'
                                        ? 'Sin Registro'
                                        : product['product_group_name']
                                            .toString()))
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Precio',
                                  style: TextStyle(
                                      fontFamily: 'Poppins Bold', fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    '\$ ${product['price'] is double ? product['price'] : 0}')
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // _buildTextFormField('Nombre', product['name'].toString(), mediaScreen),
                    // // _buildTextFormField('Path Image', product['image_path'].toString()),
                    // // _buildImage(product['image_path'].toString()),
                    // _buildTextFormField('Categoría', product['categoria'].toString(), mediaScreen),
                    // _buildTextFormField('Impuesto', product['tax_cat_name'].toString(), mediaScreen),
                    // _buildTextFormField('Grupo de producto', product['product_group_name'].toString() == '{@nil: true}' ? 'Sin Registro' : product['product_group_name'].toString()  , mediaScreen),
                    // _buildTextFormField('Unidad de medida', product['um_name'].toString(), mediaScreen),
                    // _buildTextFormField('Tipo de producto', product['product_type_name'], mediaScreen),
                    // _buildTextFormField('Precio', '\$${product['price'] is double ? product['price']: 0}', mediaScreen),
                    // _buildTextFormField('Cantidad Disponible', product['quantity'].toString(), mediaScreen),

                    SizedBox(
                      height: mediaScreen * 0.34,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 7,
                                  spreadRadius: 2)
                            ]),
                        width: mediaScreen,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProductScreen(product: product)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'Editar',
                            style: TextStyle(
                                fontFamily: 'Poppins Bold', fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, String value, double mediaScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: mediaScreen,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 7,
                  spreadRadius: 2)
            ]),
        child: TextFormField(
          initialValue: value,
          readOnly: true,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: 'Poppins Regular',
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 15)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 15, color: Colors.white)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          ),
        ),
      ),
    );
  }
}

Widget _buildImage(String imagePath) {
  return Image.file(File(
      imagePath)); // Utiliza la ruta de la imagen para cargar la imagen desde el sistema de archivos
}
