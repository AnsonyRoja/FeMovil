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
      title: Text('Filtrar por categoría'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lista desplegable para mostrar las categorías disponibles
          DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: 'Categoría'),
            value:scategory, // Valor inicial vacío
            onChanged: (selectedCategory) {
              // Aquí puedes manejar la selección de la categoría
              // Puedes actualizar el estado del diálogo y almacenar la categoría seleccionada
              scategory = selectedCategory;
              print("categoria seleccionada $selectedCategory" );
            },
            items: categories.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child:  Container(
                      width: 220, // Ancho máximo deseado para el texto
                          child: Text(
                            category,
                            overflow: TextOverflow.clip,
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
            // Aquí puedes implementar la lógica para aplicar el filtro y cerrar el diálogo
            // Por ejemplo, puedes enviar la categoría seleccionada de vuelta a la pantalla principal para que se aplique el filtro
            Navigator.of(context).pop(scategory);
          },
          child: Text('Filtrar'),
        ),
        TextButton(
          onPressed: () {
            // Aquí puedes implementar la lógica para cerrar el diálogo sin aplicar el filtro
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),
      ],
    );
  }
}
