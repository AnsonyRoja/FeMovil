import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/config/url.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:path_provider/path_provider.dart';





// Esta funcion nos ayudara a crear una nueva orden


createOrdenSalesIdempiere(orderSalesList) async {


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

    var map = await getRuta();
    var variablesLogin = await getLogin();
    final uri = Uri.parse(
        '${map['URL']}ADInterface/services/rest/composite_service/composite_operation');

    final request = await httpClient.postUrl(uri);

    final info = await getApplicationSupportDirectory();
    print("esta es la ruta ${info.path}");

    final String filePathEnv = '${info.path}/.env';
    final File archivo = File(filePathEnv);
    String contenidoActual = await archivo.readAsString();
    print('Contenido actual del archivo:\n$contenidoActual');

    // Convierte el contenido JSON a un mapa
    dynamic requestBody = {};
    Map<String, dynamic> jsonData = jsonDecode(contenidoActual);

    var role = jsonData["RoleID"];
    var orgId = jsonData["OrgID"];
    var clientId = jsonData["ClientID"];
    var wareHouseId = jsonData["WarehouseID"];
    var language = jsonData["Language"];
    print("Esto es orderSales List nuevo $orderSalesList");
   
  
       requestBody = {
        "CompositeRequest": {
          "ADLoginRequest": {
            "user": variablesLogin['user'],
            "pass": variablesLogin['password'],
            "lang": jsonData["Language"], 
            "ClientID": jsonData["ClientID"],
            "RoleID": jsonData["RoleID"],
            "OrgID": jsonData["OrgID"],
            "WarehouseID": jsonData["WarehouseID"],
            "stage": "9",
          },
          "serviceType": "UCCompositeOrder",
          "operations": {
            "operation": [
              {
                "@preCommit": "false",
                "@postCommit": "false",
                "TargetPort": "createData",
                "ModelCRUD": {
                  "serviceType": "UCCreateOrder",
                  "TableName": "C_Order",
                  "RecordID": "0",
                  "Action": "CreateUpdate",
                  "DataRow": {
                    "field": [
                      {
                        "@column": "AD_Client_ID",
                        "val": orderSalesList['ad_client_id']
                      },
                      {"@column": "AD_Org_ID", "val": orderSalesList['ad_org_id']},
                      {
                        "@column": "C_BPartner_ID",
                        "val": orderSalesList['c_bpartner_id'],
                      },
                      {
                        "@column": "C_BPartner_Location_ID",
                        "val": orderSalesList['c_bpartner_location_id'],
                      },
                      {
                        "@column": "C_Currency_ID",
                        "val": "100",
                      },
                      {
                        "@column": "Description",
                        "val": orderSalesList['descripcion'],
                      },
                      {
                        "@column": "C_ConversionType_ID",
                        "val": variablesG[0]['c_conversion_type_id']
                      },
                      {
                        "@column": "C_DocTypeTarget_ID",
                        "val": orderSalesList['c_doctypetarget_id']
                      },
                      {
                        "@column": "C_PaymentTerm_ID",
                        "val": variablesG[0]['c_paymentterm_id']
                      },
                      {
                        "@column": "DateOrdered",
                        "val": orderSalesList['date_ordered']
                      },
                      {"@column": "IsTransferred", "val": 'Y'},
                      {
                        "@column": "M_PriceList_ID",
                        "val": variablesG[0]['m_pricelist_id']
                      },
                      {
                        "@column": "M_Warehouse_ID",
                        "val": orderSalesList['m_warehouse_id']
                      },
                      {"@column": "PaymentRule", "val": 'B'},
                      {
                        "@column": "SalesRep_ID",
                        "val": orderSalesList['usuario_id']
                      },
                      {"@column": "LVE_PayAgreement_ID", "val": '1000001'}
                  
                    ]
                  }
                }
              },
               
            ]
          }
        }
      };

      // Crear las líneas de la orden
  final lines = createLines(orderSalesList['lines'], orderSalesList['usuario_id']);

  // Agregar las líneas de la orden al JSON de la orden
  for (var line in lines) {
    requestBody['CompositeRequest']['operations']['operation'].add(line);
  }

  dynamic doAction  = {
        "@preCommit": "false",
        "@postCommit": "false",
        "TargetPort": "setDocAction",                      
          "ModelSetDocAction": {
              "serviceType": "completeOrder",
              "tableName": "C_Order",
              "recordIDVariable": "@C_Order.C_Order_ID",
              "docAction": "PR",
          }
      };
                
   requestBody['CompositeRequest']['operations']['operation'].add(doAction);


      // Configurar el cuerpo de la solicitud en formato JSON

      final jsonBody = jsonEncode(requestBody);

      request.headers.set('Content-Type', 'application/json; charset=utf-8');
      request.headers.set('Accept', 'application/json');

      request.write(jsonBody);

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      final parsedJson = jsonDecode(responseBody);

      print("esta es la respuesta $parsedJson");

        String documentNo = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][1]['@value'];
        dynamic cOrderId = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][0]['@value'];
        print(' esto es el client id ${orderSalesList['id']} Esto es el document no $documentNo y este es el orderid $cOrderId');

                        Map<String, dynamic> nuevoDocumentNoAndCOrderId = {

                            'documentno': documentNo,
                            'c_order_id':cOrderId


                        };

                      String newStatus = 'Enviado';

                      updateOrdereSalesForStatusSincronzed(orderSalesList['id'], newStatus);

                      actualizarDocumentNo(orderSalesList['id'], nuevoDocumentNoAndCOrderId);


    return parsedJson;

  } catch (e) {
    return 'este es el error e $e';
  }
}




createLines(lines, rePId) {
  List linea = [];

  lines.forEach((line) => {
        print("line $line"),
        linea.add({
          "@preCommit": "false",
            "@postCommit": "false",
            "TargetPort": "createData",
            "ModelCRUD": {
                "serviceType": "UCCreateOrderLine",
                "TableName": "C_OrderLine",
                "recordID": "0",
                "Action": "Create",
                "DataRow": {
          "field": [
            {"@column": "AD_Client_ID", "val": line['ad_client_id']},
            {"@column": "AD_Org_ID", "val": line['ad_org_id']},
            {"@column": "C_Order_ID", "val": "@C_Order.C_Order_ID"},
            {"@column": "PriceEntered", "val": line['price_entered']},
            {"@column": "PriceActual", "val": line['price_entered']},
            {"@column": "M_Product_ID", "val": line['m_product_id']},
            {"@column": "QtyOrdered", "val": line['qty_entered']},
            {"@column": "QtyEntered", "val": line['qty_entered']},
            {"@column": "SalesRep_ID", "val": rePId}
          ]
         }
        }
        })
      });

  print("estas son las lineas $linea");

  return linea;
}


