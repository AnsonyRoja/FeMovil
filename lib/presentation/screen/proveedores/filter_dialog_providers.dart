import 'package:femovil/presentation/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FilterGroupsProviders extends StatefulWidget {
  final List<Map<String, dynamic>> providers;

  const FilterGroupsProviders({super.key, required this.providers});

  @override
  State<FilterGroupsProviders> createState() => _FilterGroupsProvidersState();
  
}



class _FilterGroupsProvidersState extends State<FilterGroupsProviders> {
  
  String? sgrupo; 
 // Ahora scategory es un miembro de la clase State
  @override
  Widget build(BuildContext context) {
    print("Products ${widget.providers}");
         List<String> providers = widget.providers
        .map<String>((providers) => providers['grupo'] as String) 
        .toSet() // Elimina duplicados
        .toList(); //
        providers.insert(0, "Todos");

    return AlertDialog(
      title: const Text('Filtrar por Grupo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lista desplegable para mostrar las categorías disponibles
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Grupo'),
            value:sgrupo, // Valor inicial vacío
            onChanged: (selectedGrupo) {
              // Aquí puedes manejar la selección de la categoría
              // Puedes actualizar el estado del diálogo y almacenar la categoría seleccionada
              sgrupo = selectedGrupo;
              print("categoria seleccionada $selectedGrupo" );
            },
            items: providers.map((category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            print("esto es sgrupo $sgrupo");
            // Aquí puedes implementar la lógica para aplicar el filtro y cerrar el diálogo
            // Por ejemplo, puedes enviar la categoría seleccionada de vuelta a la pantalla principal para que se aplique el filtro
            Navigator.of(context).pop(sgrupo);
          },
          child: const Text('Filtrar'),
        ),
        TextButton(
          onPressed: () {
            // Aquí puedes implementar la lógica para cerrar el diálogo sin aplicar el filtro
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
