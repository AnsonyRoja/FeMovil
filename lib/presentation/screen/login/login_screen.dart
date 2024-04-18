import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:femovil/config/banner_app.dart';
import 'package:flutter/material.dart';
import 'package:femovil/presentation/perfil/perfil.dart';
import 'package:femovil/presentation/screen/configuracion/config_screen.dart';
import 'package:femovil/presentation/screen/login/login_info.dart';
import 'package:femovil/presentation/screen/login/login_success.dart';
import 'package:femovil/presentation/screen/login/progress_indicator.dart';
import 'package:path_provider/path_provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool showError =
      false; // Variable para controlar la visibilidad del mensaje de error
  bool showErrorCon = false;
  bool showErrorReg = false;
  String errorMessageCon = 'Problemas de conexion';
  String errorMessageReg = 'No se encontro datos de registros de usuario';
  String errorMessage = 'Usuario o Contrasena Incorrectos';
  bool isLoading = false;
  String user = '';
  String password = '';
  bool auth = false;

  @override
  void initState() {
    super.initState();
    initializeAsyncData();
  }

  Future<void> initializeAsyncData() async {
    final infoLog = await getApplicationSupportDirectory();
    final String filePath = '${infoLog.path}/.login.json';
    final File configFile = File(filePath);

        if (await configFile.exists()) {
          try {
            final content = await configFile.readAsString();

            // Verifica si el contenido no está vacío antes de intentar decodificarlo
            if (content.isNotEmpty) {
              final Map<String, dynamic> jsonData = json.decode(content);

              // Asigna los valores a las variables globales
              user = jsonData['user'] as String;
              password = jsonData['password'] as String;
              if (jsonData.containsKey('auth') && jsonData['auth'] != null) {
                auth = jsonData['auth'] as bool;
                // Ahora puedes trabajar con 'auth' sabiendo que no es nulo.
              }

              setState(() {
                isLoading = false; // Cuando todas las operaciones asincrónicas hayan terminado.
              });
            } else {
              print('El contenido del archivo JSON está vacío.');
            }
          } catch (e) {
            print('Error al decodificar JSON: $e');
          }
        }


    
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (user.isNotEmpty && password.isNotEmpty && auth == true) {
      // Realiza la navegación a la pantalla '/home' cuando isLoading es false
      Future.delayed(Duration.zero, () {
        Navigator.pushReplacementNamed(context, '/home');
      });

      return Scaffold(
        body: Center(
          child:CustomProgressIndicator(),
        ),
      );
    } else if (user.isEmpty && password.isEmpty && auth == false) {
      return GestureDetector(
        onTap: () {
          // Cierra el teclado cuando se toca fuera de los campos de texto
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20), // Ajuste de la posición vertical
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                   

                      Text(
                        'Login',
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
                      SizedBox(height: 10,),
                              Text(
                        'Inicio de sesión',
                        style: TextStyle(
                          fontFamily: 'Poppins Regular',
                          color: Colors.white,
                          fontSize: 12, // Tamaño del texto
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20,),
                    Image.asset(
                      'lib/assets/LogoFemovil.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            width: 340,
                            height: 50,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Color de la sombra
                                spreadRadius: 3, // Extensión de la sombra
                                blurRadius: 4, // Desenfoque de la sombra
                                offset: const Offset(
                                    0, 3), // Desplazamiento de la sombra
                              ),
                            ]),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: const InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 2.0,
                                    horizontal:
                                        18.0), // Ajusta el padding interno
                                labelStyle: TextStyle(
                                  fontFamily:
                                      'Poppins Regular', // Reemplaza con el nombre definido en pubspec.yaml
                                  fontSize: 15.0, // Tamaño de la fuente
                                  // Peso de la fuente (por ejemplo, bold)
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Color del texto
                                ), // Ajusta el tamaño del texto del label

                                labelText: 'Nombre de Usuario',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black), // Color del borde
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors
                                          .blue), // Color del borde cuando está enfocado
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(158, 157, 157,
                                          0.2)), // Color del borde cuando no está enfocado
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese un nombre de usuario';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: 340,
                            height: 50,
                            decoration: BoxDecoration(boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.1), // Color de la sombra
                                spreadRadius: 3, // Extensión de la sombra
                                blurRadius: 4, // Desenfoque de la sombra
                                offset: const Offset(
                                    0, 3), // Desplazamiento de la sombra
                              ),
                            ]),
                            child: TextFormField(
                              onFieldSubmitted: (value) {
                                onTouch();
                              },
                              controller: passwordController,
                              obscureText:
                                  !isPasswordVisible, // Mostrar u ocultar la contraseña
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelStyle: const TextStyle(
                                  fontFamily:
                                      'Poppins Regular', // Reemplaza con el nombre definido en pubspec.yaml
                                  fontSize: 15.0, // Tamaño de la fuente
                                  // Peso de la fuente (por ejemplo, bold)
                                  color: Color.fromARGB(
                                      255, 0, 0, 0), // Color del texto
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 2.0, horizontal: 18.0),
                                labelText: 'Contraseña',
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Colors.black), // Color del borde
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xFF7531FF)), // Color del borde cuando está enfocado
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(158, 157, 157,
                                          0.2)), // Color del borde cuando no está enfocado
                                ),
                                suffixIcon: IconButton(
                                  icon: isPasswordVisible
                                  ? ImageIcon(
                                      const AssetImage('lib/assets/Ojos Activado@3x.png'),
                                      size: 24,
                                      color: colors.primary,
                                    )
                                  : const ImageIcon(
                                      AssetImage('lib/assets/Ojo Desactivado@3x.png'),
                                      size: 24,
                                      color: Color(0xFFA7A7A7),
                                    ),
                                  onPressed: () {
                                    setState(() {
                                      isPasswordVisible = !isPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, ingrese una contraseña';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (isLoading && showError == false)
                            CustomProgressIndicator(),
                          Column(
                            children: [
                              if (showError)
                                Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              if (showErrorCon)
                                Text(errorMessageCon,
                                    style: const TextStyle(color: Colors.red)),
                              if (showErrorReg)
                                Text(errorMessageReg,
                                    style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Ajusta el radio de las esquinas

                                child: ElevatedButton(
                                  onPressed: () {
                                    onTouch();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(340, 50),
                                    backgroundColor: colors
                                        .primary, // Color de fondo del botón
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15.0), // Ajusta el radio de las esquinas
                                      side: const BorderSide(
                                        color: Color.fromARGB(255, 134, 77, 247), // Color del borde con opacidad
                                        width: 2.0, // Ancho del borde
                                      ),
                                    ),
                                  ),
                                  child: const Text(
                                    'Iniciar Sesión',
                                    
                                    style: TextStyle(color: Colors.white,fontFamily: 'Poppins Bold', fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const Configuracion(),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: colors.primary,
                                      ), // Icono de configuración
                                      const SizedBox(
                                          width:
                                              8), // Espacio entre el icono y el texto
                                      Text(
                                        'Configuración',
                                        style: TextStyle(color: colors.primary),
                                      ), // Texto del botón de configuración
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7,),
                              Image.asset('lib/assets/Bande ECU@3x.png', width: 50,),
                              const SizedBox(height: 15),
                              const Text('Desarrollado Por:'),
                              Image.asset(
                                'lib/assets/Logo_Frontuari.png',
                                width: 120,
                                height: 35,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return const Perfil();
    }
  }

  void onTouch() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Realizar la lógica de inicio de sesión aquí
      final username = usernameController.text;
      final password = passwordController.text;
      print('Usuario: $username, Contraseña: $password');
      infoLogin(username, password);
      loginLoad(username, password);
      setState(() {
        isLoading = true;
        showError = false;
        showErrorCon = false;
        showErrorReg = false;
      });
    }
  }

  loginLoad(usuario, password) {
    final authService = AuthenticationService();

    setState(() {
      isLoading = true;
    });

    authService
        .login(username: usuario, password: password)
        .then((loginExitoso) {
      if (loginExitoso == "hay problemas con el internet") {
        setState(() {
          isLoading = false;
          showErrorCon = true;
        });
        // No se encontro datos de registros de usuario
      } else if (loginExitoso ==
          "No se encontro datos de registros de usuario") {
        setState(() {
          isLoading = false;
          showErrorReg = true;
        });
      } else if (loginExitoso) {
        setState(() {
          isLoading = false;
        });

        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        // Muestra un mensaje de error o realiza otras acciones en caso de falla.
        setState(() {
          showError = true;
          print("este es el valor de loginExitoso $loginExitoso");
        });
        // Timer(const Duration(seconds: 5), () {
        //   setState(() {
        //     showError = false;
        //   });
        // });
      }
    });
  }
}
