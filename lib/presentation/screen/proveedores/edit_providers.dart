import 'package:femovil/database/create_database.dart';
import 'package:flutter/material.dart';

class EditProviderScreen extends StatefulWidget {
  final Map<String, dynamic> provider;

  const EditProviderScreen({super.key, required this.provider});

  @override
  _EditProviderScreenState createState() => _EditProviderScreenState();
}

class _EditProviderScreenState extends State<EditProviderScreen> {
  final _nameController = TextEditingController();
  final _rucController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _grupoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product details
    _nameController.text = widget.provider['name'].toString();
    _rucController.text = widget.provider['ruc'].toString();
    _correoController.text = widget.provider['correo'].toString();
    _telefonoController.text = widget.provider['telefono'].toString();
    _grupoController.text = widget.provider['grupo'].toString();

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
            "Editar Proveedor",
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
                  _buildTextFormField('Ruc', _rucController),
                  _buildTextFormField('Correo', _correoController),
                  _buildTextFormField('Telefono', _telefonoController),
                  _buildTextFormField('Grupo', _grupoController),
              
                ],

              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           String newName = _nameController.text;
    int newRuc = int.parse(_rucController.text);
    String newCorreo = _correoController.text;
    int newTelefono = int.parse(_telefonoController.text);
    String newGrupo = _grupoController.text;

    // Crear un mapa con los datos actualizados del producto
    Map<String, dynamic> updatedprovider = {
      'id': widget.provider['id'], // Asegúrate de incluir el ID del producto
      'name': newName,
      'Ruc': newRuc,
      'Correo': newCorreo,
      'Telefono': newTelefono,
      'Grupo': newGrupo,

    };

    // Actualizar el producto en la base de datos
    await DatabaseHelper.instance.updateProvider(updatedprovider);

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proveedor actualizado satisfactoriamente'),
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
    _rucController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _grupoController.dispose();
    super.dispose();
  }
}
