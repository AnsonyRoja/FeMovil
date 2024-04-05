import 'package:femovil/config/theme/app_theme.dart';
import 'package:femovil/presentation/perfil/perfil.dart';
import 'package:femovil/presentation/products/products_screen.dart';
import 'package:femovil/presentation/screen/configuracion/config_screen.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:femovil/presentation/screen/informacion/informacion.dart';
import 'package:femovil/presentation/screen/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:shared_preferences/shared_preferences.dart';


class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      prefs.setBool("isFirstTime", false);
    }
    requestPermissions();
    runApp(MyApp(initialRoute: isFirstTime ? '/configuracion' : '/'));
  }
}


void requestPermissions() async {
  // Solicitar permisos de acceso a la cámara y a la galería
  await Permission.camera.request();
  
}



void main() {
    AppInitializer.initialize();

  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: widget.initialRoute,
      debugShowCheckedModeBanner: false,
      title: 'Fe Movil',
      theme: AppTheme(selectedColor: 4).theme(),
      routes: {
        '/' :(context) => const Login(),
        '/configuracion' :(context) => const Configuracion(),
        '/home' :(context) => const Home(),
        '/perfil':(context) =>  const Perfil(),
        '/products':(context) =>  const Products(),

        '/informacion':(context) =>  const Informacion(),
      },
    );
  }
}



