import 'package:flutter/material.dart';




class CrearRetencions extends StatefulWidget {
  const CrearRetencions({super.key});

  @override
  State<CrearRetencions> createState() => _CrearRetencionsState();
}

class _CrearRetencionsState extends State<CrearRetencions> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

          FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 247, 255),
            appBar:  AppBar(  
            title: const Text('Crear Retencion'),
            backgroundColor: const Color.fromARGB(255, 236, 247, 255),
            ),
            body: TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre del producto', filled: true, fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre del producto';
                        }
                        return null;
                      },
                    ),
            
      
      ),
    );
  }
}