


import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/url.dart';
import 'package:path_provider/path_provider.dart';


getUsers(username, password) async {


    HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
  var map = await getRuta();

  final uri = Uri.parse(
      '${map['URL']}ADInterface/services/rest/model_adservice/query_data');

  final request = await httpClient.postUrl(uri);
      final info = await getApplicationSupportDirectory();
    
      print("esta es la ruta ${info.path}");

   final String filePathEnv = '${info.path}/.env';
          final File archivo = File(filePathEnv);

           String contenidoActual = await archivo.readAsString();
    print('Contenido actual del archivo:\n$contenidoActual');

    // Convierte el contenido JSON a un mapa
    Map<String, dynamic> jsonData = jsonDecode(contenidoActual);

    var role = jsonData["RoleID"];
    var orgId = jsonData["OrgID"];
    var clientId = jsonData["ClientID"];
    var wareHouseId = jsonData["WarehouseID"];
    var language = jsonData["Language"];

 

  // Configurar el cuerpo de la solicitud en formato JSON
  final requestBody = {
    "ModelCRUDRequest": {
      "ModelCRUD": {
        "serviceType": "getUser",
        "DataRow": {
          "field": [
            {"@column": "Name", "val": username}
          ]
        }
      },
      "ADLoginRequest": {
        "user": username,
        "pass": password,
        "lang": language,
        "ClientID": clientId,
        "RoleID": role,
        "OrgID": orgId,
        "WarehouseID": wareHouseId,
        "stage": 9
      }
    }
  };



  // Convertir el cuerpo a JSON
  final jsonBody = jsonEncode(requestBody);

  // Establecer las cabeceras de la solicitud
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Accept', 'application/json');

  // Escribir el cuerpo en la solicitud
  request.write(jsonBody);

  final response = await request.close();
  print("esta es la respuesta $response");
  return response;

}