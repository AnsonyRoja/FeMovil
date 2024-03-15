import 'package:femovil/presentation/clients/edit_clients.dart';
import 'package:femovil/presentation/orden_venta/orden_venta.dart';
import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> client;


  const ClientDetailsScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(title: const Text("Detalles del Cliente", style: TextStyle(
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
          
                _buildTextFormField('Nombre', client['name'].toString()),
                _buildTextFormField('Ruc', client['ruc'].toString()),
                _buildTextFormField('Correo', '${client['correo']}'),
                _buildTextFormField('Telefono', client['telefono'].toString()),
                _buildTextFormField('Grupo', client['grupo'].toString()),
                const SizedBox(height: 29,),
               SizedBox(
                
                width: double.infinity, // Ocupa el ancho de la pantalla horizontalmente
                child: ElevatedButton(
                  
                  onPressed: () {
                    // Aquí puedes manejar la acción de agregar orden
                    // Por ejemplo, puedes navegar a una pantalla de agregar orden
                   Navigator.push(context,MaterialPageRoute(builder: (context) => OrdenDeVentaScreen(clientId: client["id"] ,clientName: client["name"])),
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
            MaterialPageRoute(builder: (context) => EditClientScreen(client: client)),
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
