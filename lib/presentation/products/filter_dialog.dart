import 'package:femovil/presentation/products/products_screen.dart';
import 'package:flutter/material.dart';

class FilterCategories extends StatefulWidget {
  final List<Map<String, dynamic>> products;

  const FilterCategories({super.key, required this.products});

  @override
  State<FilterCategories> createState() => _FilterCategoriesState();
  
}



class _FilterCategoriesState extends State<FilterCategories> {
  
  String? scategory; 
 // Ahora scategory es un miembro de la clase State
  @override
  Widget build(BuildContext context) {
    print("Products ${widget.products}");
         List<String> categories = widget.products
        .map<String>((product) => product['categoria'] as String) 
        .toSet() // Elimina duplicados
        .toList(); //
        categories.insert(0, "Todos");

    return AlertDialog(
  backgroundColor: Colors.white, // Cambia el color de fondo del AlertDialog
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16.0), // Da esquinas redondeadas al AlertDialog
  ),
  title: const Text(
    'Filtrar por categoría',
    style: TextStyle(fontFamily: 'Poppins SemiBold'),
  ),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      DropdownButtonFormField<String>(
        decoration: const InputDecoration(
          labelText: 'Categoría',
          hintStyle: TextStyle(fontFamily: 'Poppins SemiBold'),
        ),
        value: scategory,
        onChanged: (selectedCategory) {
          scategory = selectedCategory;
          print("categoria seleccionada $selectedCategory");
        },
        items: categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: SizedBox(
              width: MediaQuery.of(context).size.width *0.5 ,
              child: Text(
                category,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Poppins Regular'),
              ),
            ),
          );
        }).toList(),
      ),
    ],
  ),
  actions: [
    TextButton(
      onPressed: () {
        print("esto es scategory $scategory");
        Navigator.of(context).pop(scategory);
      },
      child: const Text(
        'Filtrar',
        style: TextStyle(fontFamily: 'Poppins SemiBold', color: Color(0xFF7531FF)), // Cambia el color del texto del botón
      ),
    ),
    TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text(
        'Cancelar',
        style: TextStyle(color: Colors.red), // Cambia el color del texto del botón
      ),
    ),
  ],
);

  }
}
