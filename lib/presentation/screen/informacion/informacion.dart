import 'package:femovil/assets/nav_bar_bottom.dart';
import 'package:femovil/config/url.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Informacion extends StatelessWidget {
  const Informacion({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(null),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  'lib/assets/LogoFemovil.png',
                  height: 160,
                  width: 160,
                ),
                const SizedBox(height: 10),
               // Color del texto


                FutureBuilder(
                  future: getRuta(), // Llama a la función para obtener la promesa
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return const Text('Error al cargar la ruta');
                    } else {
                      final ruta = snapshot.data['URL'];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'URL Server',
                                  style: TextStyle(
                                    fontFamily:
                                        'OpenSans', // Reemplaza con el nombre definido en pubspec.yaml
                                    fontSize: 15.0, // Tamaño de la fuente
                                    fontWeight:
                                        FontWeight.w400, // Peso de la fuente (por ejemplo, bold)
                                    color: Color(0xFF000000), // Color del texto
                                  ),
                                  
                                ),
                                const SizedBox(height: 10),
                                 Container(
                                  alignment: Alignment.centerLeft,
                                  width: 300,
                                  height: 50,
                                   decoration: BoxDecoration(
                                      color: const Color(0xFFFFFFFF),
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1), // Color y opacidad de la sombra
                                                blurRadius: 5.0, // Radio de difuminado de la sombra
                                                offset: const Offset(0, 3), // Desplazamiento de la sombra
                                              ),
                                            ],
                                    ),
                            padding: const EdgeInsets.all(
                                8.0), // Ajusta el valor según tu preferencia
                            child: Text(
                              ruta ?? 'Ruta no disponible',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 105, 102, 102)), // Cambia el color del texto si es necesario
                            ),
                          )
                              ],
                            ),
                          ),
                         
                        ],
                      );
                    }
                  },
                ),
                Column(
                  mainAxisSize: MainAxisSize.min, // Alinear contenido al centro
                  children: [
                    const SizedBox(height: 15),
                    const Text('Contáctanos', style: TextStyle(
                      fontFamily:
                          'OpenSans', // Reemplaza con el nombre definido en pubspec.yaml
                      fontSize: 18.0, // Tamaño de la fuente
                      fontWeight:
                          FontWeight.w500, // Peso de la fuente (por ejemplo, bold)
                      color:Colors.black, // Color del texto
                    )),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            const url = 'https://www.wa.link/rm9cdg';
      
                            await launchUrlString(
                                url); // Reemplaza con la URL deseada.
                          },
                          child: Image.asset(
                        'lib/assets/WhatsApp.png',
                        height: 45,
                        width: 50,
                      ),
                        ),
                       
                      ],
                    ),
                    const SizedBox(height: 15,),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                          
                          const Text("Siguenos en nuestras redes Sociales:", style: TextStyle(
                                  fontFamily:
                                      'OpenSans', // Reemplaza con el nombre definido en pubspec.yaml
                                  fontSize: 14.0, // Tamaño de la fuente
                                  fontWeight:
                                      FontWeight.w400, // Peso de la fuente (por ejemplo, bold)
                                  color:Colors.black, // Color del texto
                                ),),
                          const SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos en el eje principal (horizontal)
                            children: [
                              GestureDetector(
                                  onTap: () async {
                                    const url = 'https://www.facebook.com/Frontuari/';
                                            
                                    await launchUrlString(url); // Reemplaza con la URL deseada.
                                  },
                                  child: Image.asset(
                                    'lib/assets/FB@3x.png',
                                    height: 35,
                                    width: 50,
                                  ),
                                ),
                                 GestureDetector(
                                  onTap: () async {
                                    const url = 'https://www.instagram.com/frontuari?igsh=ZXRjaG0yYm44Z3oy';
                                            
                                    await launchUrlString(url); // Reemplaza con la URL deseada.
                                  },
                                  child: Image.asset(
                                    'lib/assets/IG@3x.png',
                                    height: 35,
                                    width: 50,
                                  ),
                                ),
                            ],
                          ),
                       const SizedBox(height: 20,),

                      
                          
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Desarrollado por:', style: TextStyle(
                                  fontFamily:
                                      'OpenSans', // Reemplaza con el nombre definido en pubspec.yaml
                                  fontSize: 16.0, // Tamaño de la fuente
                                  fontWeight:
                                      FontWeight.w400, // Peso de la fuente (por ejemplo, bold)
                                  color:Colors.black, // Color del texto
                                )),
                                
                                GestureDetector(
                                  onTap: () async {
                                    const url = 'https://frontuari.net/';
                                      
                                    await launchUrlString(url);
                                  },
                                  child: Image.asset(
                                    'lib/assets/Logo_Frontuari.png',
                                    height: 50,
                                    width: 150,
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                      
                  ],
                ),
               
              
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBarBottom(),
    );
  }
}
