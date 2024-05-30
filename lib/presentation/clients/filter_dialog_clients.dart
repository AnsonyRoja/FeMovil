import 'package:femovil/presentation/products/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class FilterGroups extends StatefulWidget {
  final List<Map<String, dynamic>> clients;

  const FilterGroups({super.key, required this.clients});

  @override
  State<FilterGroups> createState() => _FilterGroupsState();
}

class _FilterGroupsState extends State<FilterGroups> {
  String? sgrupo;
  // Ahora scategory es un miembro de la clase State
  @override
  Widget build(BuildContext context) {
    print("clients ${widget.clients}");
    List<String> clients = widget.clients
        .map<String>((clients) => clients['group_bp_name'] as String)
        .toSet() // Elimina duplicados
        .toList(); //
    clients.insert(0, "Todos");

    return AlertDialog(
      title: const Text('Filtrar por Grupo'),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lista desplegable para mostrar las categorías disponibles
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Grupo'),
            value: sgrupo, // Valor inicial vacío
            onChanged: (selectedGrupo) {
              // Aquí puedes manejar la selección de la categoría
              // Puedes actualizar el estado del diálogo y almacenar la categoría seleccionada
              sgrupo = selectedGrupo;
              print("categoria seleccionada $selectedGrupo");
            },
            items: clients.map((group) {
              return DropdownMenuItem<String>(
                value: group,
                child: Text(
                  group,
                  style: const TextStyle(fontFamily: 'Poppins Regular'),
                ),
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
          child: const Text(
            'Filtrar',
            style: TextStyle(
                fontFamily: 'Poppins SemiBold', color: Color(0xFF7531FF)),
          ),
        ),
        TextButton(
          onPressed: () {
            // Aquí puedes implementar la lógica para cerrar el diálogo sin aplicar el filtro
            Navigator.of(context).pop();
          },
          child: const Text(
            'Cancelar',
            style: TextStyle(fontFamily: 'Poppins SemiBold', color: Colors.red),
          ),
        ),
      ],
    );
  }
}
