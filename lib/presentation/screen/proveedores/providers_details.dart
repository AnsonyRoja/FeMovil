import 'package:femovil/presentation/orden_compra/orden_compra.dart';
import 'package:femovil/presentation/screen/proveedores/edit_providers.dart';
import 'package:flutter/material.dart';

class ProvidersDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> provider;

  const ProvidersDetailsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("Detalles del proveedor", style: TextStyle(
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
          
                _buildTextFormField('Nombre', provider['name'].toString()),
                _buildTextFormField('Ruc', provider['ruc'].toString()),
                _buildTextFormField('Correo', '${provider['correo']}'),
                _buildTextFormField('Telefono', provider['telefono'].toString()),
                _buildTextFormField('Grupo', provider['grupo'].toString()),
                const SizedBox(height: 29,),
               SizedBox(
                
                width: double.infinity, // Ocupa el ancho de la pantalla horizontalmente
                child: ElevatedButton(
                  
                  onPressed: () {
                    // Aquí puedes manejar la acción de agregar orden
                    // Por ejemplo, puedes navegar a una pantalla de agregar orden
                   Navigator.push(context,MaterialPageRoute(builder: (context) => OrdenDeCompraScreen(providerId: provider["id"] ,providerName: provider["name"])),
                  );

                  },
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.green),
                    foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
                  ) ,
                  child: const Text('Agregar Orden'),

                ),
              ),
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
            MaterialPageRoute(builder: (context) => EditProviderScreen(provider: provider)),
          );
        },
        backgroundColor: Colors.green, // Color del botón
        child: const Icon(Icons.edit),
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
