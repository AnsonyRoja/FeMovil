import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/url.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:path_provider/path_provider.dart';

createProductIdempiere(product) async {
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
    
try {
  

    print('Esto es producto ${product}');

  var map = await getRuta();
  var variablesLogin = await getLogin();
  final uri = Uri.parse('${map['URL']}ADInterface/services/rest/model_adservice/create_data');
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
  String encodedName = product['name'];


  // Configurar el cuerpo de la solicitud en formato JSON

  final requestBody= {
    "ModelCRUDRequest": {
        "ModelCRUD": {
            "serviceType": "createProduct",
            "TableName": "M_Product",
            "RecordID": "0",
            "Action": "CreateUpdate",
            "DataRow": {
                "field": [
                    {
                        "@column": "Name",
                        "val": encodedName
                    },
                    {
                        "@column": "C_TaxCategory_ID",
                        "val": product['tax_cat_id']
                    },
                    {
                        "@column": "M_Product_Category_ID",
                        "val": product['pro_cat_id']
                    },
                    {
                        "@column": "FTU_ProductGroup_ID",
                        "val": product['product_group_id']
                    },
                    {
                        "@column": "ProductType",
                        "val": product['product_type']
                    },
                    {
                        "@column": "C_UOM_ID",
                        "val": product['um_id']
                    },
                    {
                        "@column": "SKU",
                        "val": "034619849"
                    },
                    {
                        "@column": "IsStocked",
                        "val": "Y"
                    },
                    {
                        "@column": "IsPurchased",
                        "val": "Y"
                    },
                    {
                        "@column": "IsSold",
                        "val": "Y"
                    }
                ]
            }
        },
        "ADLoginRequest": {
            "user": variablesLogin['user'],
            "pass": variablesLogin['password'],
            "lang": language,
            "ClientID": clientId,
            "RoleID": role,
            "OrgID": orgId,
            "WarehouseID": wareHouseId,
            "stage": "9"
        }
    }
};


  final jsonBody = jsonEncode(requestBody);

    request.headers.set('Content-Type', 'application/json; charset=utf-8');
    request.headers.set('Accept', 'application/json');

    request.write(jsonBody);

  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();


  final parsedJson = jsonDecode(responseBody);


      print("esta es la respuesta $parsedJson");
      return parsedJson;
        } catch (e) {
          return 'este es el error e $e';
      }


}
