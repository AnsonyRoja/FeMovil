import 'dart:io';
import 'dart:convert';
import 'package:femovil/config/get_users.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:path_provider/path_provider.dart';

class AuthenticationService {
  bool isAuthenticated = false; // Inicialmente, el usuario no está autenticado.

  Future login({required String username, required String password}) async {
    dynamic response;
    try {
      final info = await getApplicationSupportDirectory();
      final String filePath = '${info.path}/.login.json';
      final File configFile = File(filePath);
      print('Esto es temporal $info');

      // Simula una solicitud de autenticación a un servidor o base de datos.
      await Future.delayed(
          const Duration(seconds: 2)); // Simulación de tiempo de espera.

      // Configurar el cuerpo de la solicitud en formato JSON
      response = await getUsers(username, password);

      if (response.statusCode == 200) {
        // La solicitud fue exitosa, puedes procesar la respuesta aquí.

        final responseBody = await response.transform(utf8.decoder).join();

        final parsedJson = jsonDecode(responseBody);

        final windowTabData = parsedJson['WindowTabData'];
        print('esto es el windowTabData $windowTabData');

        // String windowTabData = responseBody;

        if (windowTabData['@NumRows'] == 1 &&
            windowTabData['Success'] == true) {
          isAuthenticated = true; // Usuario autenticado.

          final Map<String, dynamic> jsonData = {
            "user": username,
            "password": password,
            "auth": true,
            "userId": windowTabData['DataSet']['DataRow']['field'][0]['val'],
          };
          print('este es el json data $jsonData');
          final String newContent = json.encode(jsonData);
          await configFile.writeAsString(newContent);

          //  name TEXT,
          //         password INTEGER,
          //         ad_user_id TEXT,
          //         email TEXT,
          //         phone TEXT

          Map<String, dynamic> user = {
            "name": username,
            "password": password,
            "ad_user_id": windowTabData['DataSet']['DataRow']['field'][0]
                ['val'],
            "email": windowTabData['DataSet']['DataRow']['field'][2]['val'],
            "phone": windowTabData['DataSet']['DataRow']['field'][3]['val']
          };

          await insertUser(user);

          return true; // Inicio de sesión exitoso.
        } else {
          isAuthenticated = false;
          final Map<String, dynamic> jsonData = {
            "user": username,
            "password": password,
            "auth": false,
          }; // Usuario o contraseña incorrectos.

          final String newContent = json.encode(jsonData);
          await configFile.writeAsString(newContent);

          return false;
        }
      } else {
        // La solicitud falló con un código de estado diferente de 200.
        print('Error en la solicitud: ${response.statusCode}');

        return "No se encontro datos de registros de usuario";
      }
    } catch (e) {
      print("este es el error de login $e");
      print('esto es el user $username && password $password');
      response = await getUserByLogin(username, password);

      print('Esto es la respuesta del user $response');
      if (response is! Map<String, dynamic>) {
        // No se pudo obtener una respuesta válida ni de la red ni de la base de datos local
        return "hay problemas con el internet";
      }

      if (response['name'] == username && response['password'] == password) {
        // Usuario autenticado
        final info = await getApplicationSupportDirectory();
        final String filePath = '${info.path}/.login.json';
        final File configFile = File(filePath);
        final Map<String, dynamic> jsonData = {
          "user": username,
          "password": password,
          "auth": true,
          "userId": response['ad_user_id'],
        }; // Usuario o contraseña incorrectos.

        final String newContent = json.encode(jsonData);
        await configFile.writeAsString(newContent);
        isAuthenticated = true;

        // Resto del código...
        return true;
      }

      print(
          'Error en la solicitud: ${e.toString().contains("Cannot open file")}');
      if (e.toString().contains('SocketException') ||
          e.toString().contains("No host specified")) {
        return "hay problemas con el internet";
      } else if (e.toString().contains("Cannot open file")) {
        return "No se encontro datos de registros de usuario";
      } else {
        print("Este es el error al loguearse: $e");
      }
    }
  }

  void logout() async {
    try {
      final info = await getApplicationSupportDirectory();
      final String filePath = '${info.path}/.login.json';
      final File configFile = File(filePath);

      // Lee el contenido actual del archivo JSON
      String contenidoActual = await configFile.readAsString();

      // Convierte el contenido JSON a un mapa
      Map<String, dynamic> jsonData = jsonDecode(contenidoActual);

      // Realiza las modificaciones necesarias en los datos
      jsonData["user"] = '';
      jsonData["password"] = '';
      jsonData["auth"] = false;

      // Convierte el mapa actualizado a formato JSON
      String newContent = jsonEncode(jsonData);

      // Vuelve a escribir el contenido actualizado en el archivo JSON
      await configFile.writeAsString(newContent);

      // Resto del código...
      isAuthenticated = false;
      // ... (otros cambios necesarios)
    } catch (error) {
      print('Error en la función logout: $error');
      // Manejo de errores...
    }
  }
}
