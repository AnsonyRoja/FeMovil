import 'dart:async';
import 'package:femovil/assets/nav_bar_bottom.dart';
import 'package:femovil/presentation/perfil/perfil.dart';
import 'package:femovil/presentation/clients/clients_screen.dart';
import 'package:femovil/presentation/products/products_screen.dart';
import 'package:femovil/presentation/screen/login/progress_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';

dynamic documentosPorTipo = {};
bool flag = false;
bool processingApproval = false;
bool actualizando = false;
String mensaje = '';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  final scrollController = ScrollController();
  String selectedOperationType = 'Todos';
  bool primeraActualizacion = true;
  bool closeScreen = false;

  var showErrorCon = false;
  String messageErrorCon = "Hay problemas de conexion";
  String mensajeSuc = "Se ha Aprobado correctamente";



  @override
  void initState() {
    super.initState();

    print("me monte");

  }



  @override
  void dispose() {
    print("me desmonte");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 0.8 ;
    final colors = Theme.of(context).colorScheme;


    if (closeScreen == false) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
          title: const Text(
            'Home',
            style: TextStyle(
              fontFamily:
                  'OpenSans', // Reemplaza con el nombre definido en pubspec.yaml
              fontSize: 20.0, // Tamaño de la fuente
              fontWeight:
                   FontWeight.w400, // Peso de la fuente (por ejemplo, bold)
              color: Color.fromARGB(255, 105, 102, 102), // Color del texto
            ),
          ),
          leading: actualizando == false
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    icon: Image.asset(
                      'lib/assets/Ajustes.png',
                      width: 25,
                      height: 35,
                    ),
                    onPressed: () {
                      // _showFilterOptions(context);
                    },
                  ),
                ])
              : CustomProgressIndicator(),
        ),
        body:  Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    GestureDetector(
                      onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder:(context) => const Products(),));

                      },
                      child: Column(
                      
                        children: [
                        const Text("Productos"),
                          Image.network(
                                      'https://thefoodtech.com/wp-content/uploads/2023/04/Productos-nestle.jpg', 
                                        width: 100,
                                        height: 100,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const Text('No se pudo cargar la imagen');
                                      },
                                    ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 100),
                     GestureDetector(
                      onTap: (){

                       Navigator.push(context, MaterialPageRoute(builder:(context) => const Clients(),));


                      },
                       child: Column(
                       
                        children: [
                        const Text("Clientes"),
                          Image.network(
                                      'https://www.clienteindiscreto.com/wp/wp-content/uploads/2018/10/tipos-de-clientes-parte-ii.jpg', 
                                        width: 100,
                                        height: 100,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                        return const Text('No se pudo cargar la imagen');
                                      },
                                    ),
                        ],
                                           ),
                     ),
                  ],
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                       Column(

                      children: [
                      const Text("Precios"),
                        Image.network(
                                    'https://www.fijaciondeprecios.com/wp-content/uploads/2017/01/Puedo-cobrar-un-precio-mas-alto-Conozcalo-por-5-se%C3%B1ales-clave.jpg', 
                                      width: 100,
                                      height: 100,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                                      );
                                    },
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return const Text('No se pudo cargar la imagen');
                                    },
                                  ),
                      ],
                    ),
                    const SizedBox(width: 100),
                    Column(
                      children: [
                        const Text("Ventas"),
                        Image.network('https://www.cloudtalk.io/wp-content/uploads/2021/12/Article-202105-ImproveSalesEfforts-2x-1024x538.png',
                        width: 100,
                        height: 100,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){

                              if(loadingProgress == null){
                                return child;
                              }

                              return CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!: null,);

                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){

                          return const Text("No se pudo cargar la imagen"); 
                        },
                        )
                      ],
                    ),
                  ],
                  
                  
                ),
                   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                    Column(
                      children: [
                        const Text("Compras"),
                        Image.network('https://cdn-3.expansion.mx/dims4/default/5339ade/2147483647/strip/true/crop/8409x5945+0+0/resize/1200x848!/format/webp/quality/60/?url=https%3A%2F%2Fcdn-3.expansion.mx%2Fd8%2F15%2F97756b4a444287dbf850dee43121%2Fistock-1292443598.jpg',
                        width: 100,
                        height: 100,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){

                              if(loadingProgress == null){
                                return child;
                              }

                              return CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!: null,);

                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){

                          return const Text("No se pudo cargar la imagen"); 
                        },
                        )
                      ],
                    ),
                    const SizedBox(width: 100),
                     Column(
                      children: [
                        const Text("Cobranzas"),
                        Image.network('https://www.g-talent.net/cdn/shop/articles/img-1659972637173_d775bd22-cd61-445a-aa42-48c0832b7472.jpg?v=1675217410',
                        width: 100,
                        height: 100,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){

                              if(loadingProgress == null){
                                return child;
                              }

                              return CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!: null,);

                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){

                          return const Text("No se pudo cargar la imagen"); 
                        },
                        )
                      ],
                    ),

                  ],
                  
                  
                ),
                   Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 150),
                     Column(
                      children: [
                        const Text("Retenciones"),
                        Image.network('https://static.wixstatic.com/media/b21422_23a906f84cfc45d5ba8d3a422f0847e7~mv2.jpg/v1/fill/w_640,h_400,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/b21422_23a906f84cfc45d5ba8d3a422f0847e7~mv2.jpg',
                        width: 100,
                        height: 100,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress){

                              if(loadingProgress == null){
                                return child;
                              }

                              return CircularProgressIndicator(value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!: null,);

                        },
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){

                          return const Text("No se pudo cargar la imagen"); 
                        },
                        )
                      ],
                    ),
               
                  ],
                  
                  
                ),

                

              ],
            )
            
            ),
                  bottomNavigationBar: const NavBarBottom(),
      
      );
      
    } else {
      // authenticated.logout();
      // return const Configuracion();
      return CustomProgressIndicator();
    }
  }

  // _showFilterOptions(BuildContext context) {
  //   showFilterOptions(context, documentosPorTipo, selectedOperationType,
  //       (String selectedValue) {
  //     if (mounted) {
  //       setState(() {
  //         selectedOperationType = selectedValue;
  //       });
  //     }
  //   });
  // }
}
