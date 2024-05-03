import 'package:femovil/assets/nav_bar_bottom.dart';
import 'package:femovil/config/banner_app.dart';
import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/info_perfil.dart';
import 'package:femovil/presentation/cobranzas/cobranzas_list.dart';
import 'package:femovil/presentation/clients/clients_screen.dart';
import 'package:femovil/presentation/precios/precios.dart';
import 'package:femovil/presentation/products/products_screen.dart';
import 'package:femovil/presentation/retenciones/factura_retenciones_screen.dart';
import 'package:femovil/presentation/screen/compras/compras.dart';
import 'package:femovil/presentation/screen/login/progress_indicator.dart';
import 'package:femovil/presentation/screen/proveedores/providers_screen.dart';
import 'package:femovil/presentation/screen/ventas/ventas.dart';
import 'package:femovil/sincronization/sincronization_screen.dart';
import 'package:flutter/material.dart';

bool flag = false;
bool processingApproval = false;
bool actualizando = false;
String mensaje = '';
InfPerfil? perfilData;
List<Map<dynamic, dynamic>> variablesG = [];



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
    DatabaseHelper.instance.initDatabase();
     print('Esto es la variable global de country_id ${variablesG}');
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
    double screenWidth = MediaQuery.of(context).size.width * 0.8;
    final colors = Theme.of(context).colorScheme;

    if (closeScreen == false) {
      return Scaffold(
        appBar: PreferredSize(
      preferredSize: const Size.fromHeight(170), // Altura del AppBar
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50), // Radio del borde redondeado
        ),
        child: AppBar(
         automaticallyImplyLeading: false,
          flexibleSpace: Stack(
            children: [
              CustomPaint(
                painter: CirclePainter(),
              ),
               Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35), // Ajuste de la posición vertical
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      
                      Image.asset('lib/assets/Bande ECU@3x.png', width: 55,),

                      const SizedBox(width: 15,),

                      const Text(
                        'Inicio',
                        style: TextStyle(
                          fontFamily: 'Poppins ExtraBold',
                          color: Colors.white,
                          fontSize: 30, // Tamaño del texto
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 3.0,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                   
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF7531FF), // Color hexadecimal
        ),
      ),
    ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 45,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Products(),
                              ));
                        },
                        child: Column(
                          children: [
                          Container(
                            width: 100,
                            height: 80,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 218, 248, 219), // Establece el color de fondo verde
                                borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                            child: Center( // Centra la imagen dentro del contenedor
                              child: Image.asset(
                                'lib/assets/Productos@3x.png',
                                width: 45,
                                height: 45,
                                fit: BoxFit.contain, // Ajusta la imagen para que quepa dentro del contenedor
                              ),
                            ),
                          ),
                            const SizedBox(height: 5,),
                            const Text("Productos", style:  TextStyle(fontFamily: 'Poppins SemiBold'),),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Clients(),
                              ));
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 211, 210, 253), // Establece el color de fondo verde
                                borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                              child: Center(
                                child: Image.asset('lib/assets/clientes@3x.png', width: 45, height: 45,
                                fit: BoxFit.contain
                                ),
                              )),
                            const SizedBox(height: 5,),
                            const Text("Clientes", style: TextStyle(fontFamily: 'Poppins SemiBold'),),
                       
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                       GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Precios(),
                                  ));
                            },
                            child: Column(
                              children: [
                               
                                Container(
                                   width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 253, 238, 192), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                                    ),
                                  child: Center(
                                    child: Image.asset('lib/assets/Precios@3x.png', width: 45, height: 45,
                                    fit: BoxFit.contain,
                                    ),
                                  )),
                                const SizedBox(height: 5,),
                                const Text("Precios", style: TextStyle(fontFamily: 'Poppins SemiBold') ,),
                              
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 120),
                     
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Ventas(),
                              ));
                        },
                        child: Column(
                          children: [

                            Container(
                               width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 224, 211, 249), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                                    ),
                              child: Center(child: Image.asset('lib/assets/Ventas@3x.png', width: 45, height: 45, fit: BoxFit.contain, ))),
                            const SizedBox(height:  5,),
                            const Text("Ventas", style: TextStyle(fontFamily: 'Poppins SemiBold'),),
                           
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Providers(),
                              ));
                        },
                        child: Column(
                          children: [
                            Container(  
                               width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 245, 208, 171), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                                    ),
                              child: Center(child: Image.asset("lib/assets/proveedores.png", width: 45, height: 45, fit: BoxFit.contain,))),
                            const SizedBox(height: 5,),
                            const Text("Proveedores", style: TextStyle(fontFamily: 'Poppins SemiBold'),),
                        
                          ],
                        ),
                      ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Compras(),
                              ));
                        },
                        child:  Column(
                          children: [

                            Container(
                                width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 212, 245, 246), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                              child: Center(child: Image.asset('lib/assets/Compras@3x.png', width: 45, height: 45,))),
                            const SizedBox(height: 5,),
                            const Text("Compras", style: TextStyle(fontFamily: 'Poppins SemiBold'),),
                          
                          ],
                        ),
                      ),
                    ],
                  ),
                 const SizedBox(height: 25,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                       GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Cobranzas(),
                              ));
                        },
                        child:  Column(
                          children: [

                            Container(
                                width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 246, 205, 205), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                              child: Center(
                                
                                child: Image.asset('lib/assets/Cobranzas@3x.png', width: 45, height: 45, fit: BoxFit.contain,))),
                              const SizedBox(height: 5,),
                              const Text("Cobranzas", style: TextStyle(fontFamily: 'Poppins SemiBold'), ),
                           
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),

                       GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Retenciones(),
                              ));
                        },
                        child: Column(
                          children: [
                            
                            Container(
                                width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 250, 201, 249), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                              child: Center(child: Image.asset('lib/assets/Retenciones@3x.png', width: 45, height: 45, fit: BoxFit.contain,))),
                            const SizedBox(height: 5,),
                            const Text("Retenciones", style: TextStyle(fontFamily: 'Poppins SemiBold' ), ),
                         
                          ],
                        ),
                      ),

                      const SizedBox(height: 25, width: 10,),
                    
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SynchronizationScreen(),
                              ));
                        },
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Container(
                               width: 100,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 217, 247, 255), // Establece el color de fondo verde
                                      borderRadius: BorderRadius.circular(20), // Establece bordes redondeados
                              ),
                              child: Center(child: Image.asset('lib/assets/Sincro@3x.png', width: 45, height:  45, fit: BoxFit.contain , ))),
                            const SizedBox(height: 5,)
,                            const Text("Sincronización", style: TextStyle(fontFamily: 'Poppins SemiBold'),),
                        
                          ],
                        ),
                      ),
                      
                   
                    ],
                  ),
           
                ],
              ),
            )),
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
