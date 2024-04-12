import 'package:femovil/presentation/orden_compra/orden_compra.dart';
import 'package:femovil/presentation/screen/proveedores/edit_providers.dart';
import 'package:flutter/material.dart';

class ProvidersDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> provider;

  const ProvidersDetailsScreen({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
      final screenMax = MediaQuery.of(context).size.width * 0.8;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 25,),
                  Container(
                    width: screenMax ,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                    ),
                    child: const Text('Datos Del Cliente', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),

                const SizedBox(height: 10,),
                _buildTextFormField('Nombre', provider['bpname'].toString()),
                _buildTextFormField('Ruc', provider['tax_id'].toString()),
                _buildTextFormField('Correo', '${provider['email'] != '{@nil=true}' ? provider['email'] : 'Sin registro' }'),
                _buildTextFormField('Telefono', provider['phone'].toString() != '{@nil=true}' ? provider['phone'].toString() : 'Sin registro'),
                _buildTextFormField('Grupo', provider['groupbpname'].toString()), 
                _buildTextFormField('Tipo de Impuesto', provider['tax_id_type_name'].toString()),
                  const SizedBox(height: 10,),
                  Container(
                    width: screenMax ,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                    ),
                    child: const Text('Domicilio Fiscal', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                  ),
                  const SizedBox(height: 10,),
                _buildTextFormField('Direccion', provider['address'].toString() ),
                _buildTextFormField('Ciudad', provider['city'].toString()),
                _buildTextFormField('Pais', provider['country_name'].toString()),
                _buildTextFormField('Codigo Postal', provider['postal'] != '{@nil=true}' ? provider['postal'].toString(): 'Sin codigo postal' ),

                const SizedBox(height: 29,),
               SizedBox(
                
                width: double.infinity, // Ocupa el ancho de la pantalla horizontalmente
                child: ElevatedButton(
                  onPressed: () {
                    // Aquí puedes manejar la acción de agregar orden
                    // Por ejemplo, puedes navegar a una pantalla de agregar orden

                    print('estos son los proveedores $provider');
                   Navigator.push(context,MaterialPageRoute(builder: (context) => OrdenDeCompraScreen(providerId: provider["id"] ,providerName: provider["bpname"], cBPartnerID: provider['c_bpartner_id'], cBPartnerLocationId: provider['c_bpartner_location_id'] )),
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
