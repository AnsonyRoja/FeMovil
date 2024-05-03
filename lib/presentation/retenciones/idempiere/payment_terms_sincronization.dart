
import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/url.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/sincronization/ExtractData/extract_customers_data.dart';
import 'package:femovil/sincronization/sincronizar.dart';
import 'package:path_provider/path_provider.dart';

sincronizationPaymentTerms() async {
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
  

  var map = await getRuta();
  var variablesLogin = await getLogin();
  final uri = Uri.parse('${map['URL']}ADInterface/services/rest/model_adservice/query_data');
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
        "serviceType": "getPaymentTermApp",
      },
      "ADLoginRequest": {
        "user": variablesLogin['user'],
        "pass": variablesLogin['password'],
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
  final responseBody = await response.transform(utf8.decoder).join();
  dynamic paymentTerms =  extractPaymentTerms(responseBody);
  
  print('Estos son los paymentTerms registrados en idempiere $paymentTerms');

  await syncPaymentTerm(paymentTerms); 

  final parsedJson = jsonDecode(responseBody);
  print("esta es la respuesta $parsedJson");
  return parsedJson;

}



Future<void> syncPaymentTerm( paymentTerms) async {
      final db = await DatabaseHelper.instance.database;
    


      if (db != null) {
        // Itera sobre los datos de los productos recibidos
        for (Map<String, dynamic> paymentTerm in paymentTerms) {
          // Construye un objeto Product a partir de los datos recibidos
          Map<String, dynamic> payments = {

              'c_paymentterm_id': paymentTerm['c_paymentterm_id'],
              'name': paymentTerm['name']
            
          };
      
          
                   




          // Consulta si el producto ya existe en la base de datos local por su nombre
          List<Map<String, dynamic>> existingCustomer= await db.query(
            'payment_term_fr',
            where: 'c_paymentterm_id = ?',
            whereArgs: [payments['c_paymentterm_id']],
          );

          if (existingCustomer.isNotEmpty) {
            // Si el producto ya existe, actualiza sus datos
            await db.update(
              'payment_term_fr',
              payments,
              where: 'c_paymentterm_id = ?',
              whereArgs: [paymentTerm['c_paymentterm_id']],
            );
            print('payment term fr actualizado: ${paymentTerm['name']}');
          } else {
            // Si el producto no existe, inserta un nuevo registro en la tabla de productos
            await db.insert('payment_term_fr', payments);
            print('Payment terms insertado: ${paymentTerm['c_paymentterm_id']}');
          }
        }
        print('Sincronización de Payment terms completada.');
      } else {
        // Manejar el caso en el que db sea null
        print('Error: db is null');
      }
    }






List<Map<String, dynamic>> extractPaymentTerms(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> paymentTermsData = [];

  print('Esto es la respuesta del erp $dataRows');

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {

  
  
  for (var row in dataRows) {

    Map<String, dynamic> paymentTermData = {
      'c_paymentterm_id': row['field'][0]['val'],
      'name': row['field'][1]['val'],
     
    };


    // print('Esto es tax payer type ${row['field'][26]['val']}');
         
             
    // Agrega los datos del producto a la lista
    paymentTermsData.add(paymentTermData);
  }
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}

  print("esto es Payment Terms data $paymentTermsData");

  return paymentTermsData;
}





















