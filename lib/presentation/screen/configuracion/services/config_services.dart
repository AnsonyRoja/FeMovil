import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/url.dart';
import 'package:femovil/presentation/screen/configuracion/config_screen.dart';
import 'package:path_provider/path_provider.dart';

Future crearVariablesEntorno(
    clientId, roleId, orgId, wareHouseId, language) async {
  final info = await getApplicationSupportDirectory();

  print('Esto es temporal $info');
  final String filePath = '${info.path}/.env';

  print(filePath);

  final File configFile = File(filePath);

  await configFile.create();

  final Map<String, dynamic> jsonData = {
    "ClientID": clientId,
    "RoleID": roleId,
    "OrgID": orgId,
    "WarehouseID": wareHouseId,
    "Language": language,
  };

  final String newContent = json.encode(jsonData);

  // final Map nuevo = json.decode(newContent);

  final String content = await configFile.readAsString();

  print(content);

  try {
    await configFile.writeAsString(newContent);

    print('Contenido actualizado exitosamente en la ubicación de documentos.');
  } catch (e) {
    print('Error al escribir el archivo JSON: $e');
  }
}


Future<void> verificarDatosDeAcceso() async {
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };

  var map = await getRuta();
  
  final uri = Uri.parse(
      '${map['URL']}ADInterface/services/rest/model_adservice/query_data');

  print("esto es el token ${map['TOKEN']}");
  final request = await httpClient.postUrl(uri);

  final requestBody = {
    "ModelCRUDRequest": {
      "ModelCRUD": {
        "serviceType": "testConn",
        "DataRow": {
          "field": [
            {
              "@column": "Value",
              "val": map['TOKEN'],
            }
          ]
        }
      },
      "ADLoginRequest": {
        "user": "ERPDocApproved",
        "pass": "3rp2023**",
        "lang": "en_US",
        "ClientID": 0,
        "RoleID": "50000",
        "OrgID": "0",
        "stage": 9
      }
    }
  };

  final jsonBody = jsonEncode(requestBody);

  // Establecer las cabeceras de la solicitud
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Accept', 'application/json');

  request.write(jsonBody);

  final response = await request.close();

  if (response.statusCode == 200) {
    // La solicitud fue exitosa, puedes procesar la respuesta aquí.

    final responseBody = await response.transform(utf8.decoder).join();

    final parsedJson = jsonDecode(responseBody);
    print(parsedJson);

    final windowTabData = parsedJson['WindowTabData'];
    print('esto es windowTabDate $windowTabData');

    if (windowTabData['@TotalRows'] > 0) {
      await crearVariablesEntorno(
          windowTabData['DataSet']['DataRow']['field'][0]['val'],
          windowTabData['DataSet']['DataRow']['field'][2]['val'],
          windowTabData['DataSet']['DataRow']['field'][1]['val'],
          windowTabData['DataSet']['DataRow']['field'][3]['val'],
          windowTabData['DataSet']['DataRow']['field'][4]['val']);
    } else {
      final info = await getApplicationSupportDirectory();

      print('Esto es temporal $info');
      final String filePath = '${info.path}/.env';

      print(filePath);

      final File configFile = File(filePath);

      await configFile.create();

      final Map<String, dynamic> jsonData = {
        "ClientID": 'Null',
        "RoleID": 'Null',
        "OrgID": 'Null',
        "WarehouseID": 'Null',
        "Language": 'Null',
      };

      final String newContent = json.encode(jsonData);

      // final Map nuevo = json.decode(newContent);

      final String content = await configFile.readAsString();

      print(content);

      try {
        await configFile.writeAsString(newContent);

        print(
            'Contenido actualizado exitosamente en la ubicación de documentos.');
      } catch (e) {
        print('Error al escribir el archivo JSON: $e');
      }
    }
  }
}





verificarConexion(url, token, setState) async {
  print("esto es la url y el token: $url $token");
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    }
    ..idleTimeout =
        const Duration(microseconds: 2); // Tiempo de espera de 2 segundos

  url.endsWith('/') ? url = url : url = '$url/';

  final urls = Uri.parse(
      '${url}ADInterface/services/rest/model_adservice/query_data'); // URL a la que quieres realizar la prueba de conexión

  try {
    final request = await httpClient.postUrl(urls);

    final requestBody = {
      "ModelCRUDRequest": {
        "ModelCRUD": {
          "serviceType": "testConn",
          "DataRow": {
            "field": [
              {
                "@column": "Value",
                "val": token,
              }
            ]
          }
        },
        "ADLoginRequest": {
          "user": "ERPDocApproved",
          "pass": "3rp2023**",
          "lang": "en_CO",
          "ClientID": 0,
          "RoleID": "50000",
          "OrgID": "0",
          "stage": 9
        }
      }
    };

    final jsonBody = jsonEncode(requestBody);

    // Establecer las cabeceras de la solicitud
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'application/json');

    request.write(jsonBody);
    print("esto es la respuesta $json");

       


    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      final parsedJson = jsonDecode(responseBody);

      print("esto es la respuesta $parsedJson");

     
      
      if (parsedJson['WindowTabData']['@TotalRows'] > 0) {
        return true;
      } else {
        return false;
      }
    }
  } catch (e) {
    print('Error: $e');

    return false;
  }
}