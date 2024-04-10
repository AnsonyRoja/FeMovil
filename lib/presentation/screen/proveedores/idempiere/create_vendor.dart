import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/config/url.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:path_provider/path_provider.dart';

createVendorIdempiere(vendor) async {
  
  HttpClient httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
    
try {

  

   initV() async {
    if (variablesG.isEmpty) {
      await getPosPropertiesInit();
      List<Map<String, dynamic>> response = await getPosPropertiesV();
      print('variables Entre aqui');
        variablesG = response;
    
    }
  }
 
   initV();

    print('variables globales $variablesG');
    print('Esto es Customer ${vendor}');

  var map = await getRuta();
  var variablesLogin = await getLogin();
  final uri = Uri.parse('${map['URL']}ADInterface/services/rest/composite_service/composite_operation');
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
  String encodedName = vendor['bpname'];


  // Configurar el cuerpo de la solicitud en formato JSON

  final requestBody= {

      

          "CompositeRequest":{
              
              "ADLoginRequest": {
              "user": variablesLogin['user'],
              "pass": variablesLogin['password'],
              "lang": language,
              "ClientID": clientId,
              "RoleID": role,
              "OrgID": orgId,
              "WarehouseID":wareHouseId,
              "stage": "9",
            },
          "serviceType": "UCCompositeBPartner",
              "operations":{
                  "operation":[
                      {
                      "TargetPort": "createUpdateData",
                      "ModelCRUD": {
                          "serviceType":"CreateBPAPP",
                          "TableName": "C_BPartner_Tercero",
                          "RecordID": "0",
                          "Action":"CreateUpdate",
                          "DataRow": {
                      "field": [
                           {
                              "@column": "IsCustomer",
                              "val": "N"
                          },
                          {
                              "@column": "IsVendor",
                              "val": "Y"
                          },
                          {
                              "@column": "M_PriceList_ID",
                              "val": variablesG[0]['m_pricelist_id']
                          },
                          {
                              "@column": "TaxID",
                              "val": vendor['tax_id'],
                          },
                          {
                              "@column": "C_BP_Group_ID",
                              "val": vendor['c_bp_group_id']
                          },
                          {
                              "@column": "Name",
                              "val": encodedName
                          },
                          {
                              "@column": "AD_Client_ID",
                              "val": clientId
                          },
                          {
                              "@column": "AD_Org_ID",
                              "val": orgId
                          },
                          {
                              "@column": "LCO_TaxIdType_ID",
                              "val": vendor['lco_tax_id_type_id']
                          },
                          {
                              "@column": "LCO_TaxPayerType_ID",
                              "val": vendor['lco_taxt_payer_type_id']
                          },
                          {
                              "@column": "LVE_PersonType_ID",
                              "val": vendor['lve_person_type_id']
                          },
                          {
                              "@column": "EMail",
                              "val": vendor['email']
                          }
                  
                      ]
                      }

                      }

                      },
                      {
                      "TargetPort": "createUpdateData",
                      "ModelCRUD": {
                      "serviceType" : "CreateLocationAPP",
                      "TableName" : "C_Location",
                      "RecordID" : "0",
                      "Action": "CreateUpdate",
                      "DataRow": {
                      "field": [
                          {
                              "@column": "Address1",
                              "val": vendor['address']
                          },
                          {
                              "@column": "City",
                              "val": vendor['city']
                          },
                          {
                              "@column": "Address2",
                              "val": 0
                          },
                          {
                              "@column": "C_Country_ID",
                              "val": vendor['c_country_id']
                          },
                          {
                              "@column": "Postal",
                              "val": vendor['postal']
                          }
                      
                      ]
                      }


                      }

                      
                      },
                      {
                      "TargetPort": "createUpdateData",
                      "ModelCRUD": {
                      "serviceType" : "CreateBPLocationAPP",
                      "TableName" : "C_BPartner_Location",
                      "RecordID" : "0",
                      "Action": "CreateUpdate",
                      "DataRow": {
                      "field": [
                          {
                              "@column": "C_BPartner_ID",
                              "val": "@C_BPartner.C_BPartner_ID"
                          },
                          {
                              "@column": "IsShipTo",
                              "val": "Y"
                          },
                            {
                              "@column": "IsBillTo",
                              "val": "Y"
                          },
                            {
                              "@column": "Phone",
                              "val": vendor['phone']
                          },
                          {
                              //quisiera que tome el nombre de @C_Location que se genera en createlocationapp
                              "@column": "Name",
                              "val":vendor['city']
                          },
                          {
                              "@column": "C_Location_ID",
                              "val": "@C_Location.C_Location_ID"
                          },
                          {
                              "@column": "IsRemitTo",
                              "val": "Y"
                          },
                          {
                              "@column": "IsPayFrom",
                              "val": "Y"
                          }
                      
                      ]
                      }


                      }

                      
                      
                      }

                  ]
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
