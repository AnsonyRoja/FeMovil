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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                const SizedBox( height: 25,),
                  Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Datos Personales",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                 const SizedBox(height: 10,),
                _buildTextFormField('Nombre', client['bp_name'].toString(), 1),
                _buildTextFormField('Ruc', client['ruc'].toString(), 1),
                _buildTextFormField('Correo', '${client['email'] != '{@nil: true}' ? client['email'] : 'Sin registro' }', 1),
                _buildTextFormField('Telefono', client['phone'] != '{@nil: true}' ? client['phone'].toString() : 'Sin registro', 1),
                _buildTextFormField('Grupo', client['group_bp_name'].toString(), 1),
                // _buildTextFormField('Tipo de cliente', client['person_type_name'], 1),
                _buildTextFormField('Tipo de contribuyente', client['tax_payer_type_name'] != '{@nil: true}' ? client['tax_payer_type_name'] : 'Sin registro' , 1),
                _buildTextFormField('Tipo de impuesto', client['tax_id_type_name'], 1),
                const SizedBox(height: 10,),
               Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Domicilio Fiscal",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox( height: 10,),
                _buildTextFormField('Dirección', client['address'].toString() != '{@nil: true}' ? client['address'].toString() : 'Sin registro', 2),
                _buildTextFormField('Pais', client['country'] != '{@nil: true}' ? client['country'] : 'Sin registro' , 1),
                _buildTextFormField('Ciudad', client['city'] != '{@nil: true}' ?  client['city'].toString() : 'Sin registro' , 1),
                _buildTextFormField('Codigo Postal', client['code_postal'].toString() == '{@nil=true}' ? 'Sin registro': client['code_postal'].toString() , 1),

                const SizedBox(height: 29,),
               SizedBox(
                
                width: double.infinity, // Ocupa el ancho de la pantalla horizontalmente
                child: ElevatedButton(
                  
                  onPressed: () {
                    // Aquí puedes manejar la acción de agregar orden
                    // Por ejemplo, puedes navegar a una pantalla de agregar orden
                   Navigator.push(context,MaterialPageRoute(builder: (context) => OrdenDeVentaScreen(clientId: client["id"] ,clientName: client["bp_name"], cBPartnerId: client['c_bpartner_id'], cBPartnerLocationId: client['c_bpartner_location_id'], )),
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

  Widget _buildTextFormField(String label, String value, int maxLin) {
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
        maxLines: maxLin,
      ),
    );
  }
}
