import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/config/url.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:femovil/presentation/screen/ventas/idempiere/create_orden_sales.dart';
import 'package:path_provider/path_provider.dart';




createInvoicedWithholdingIdempiere(retenciones) async {


   dynamic isConnection = await checkInternetConnectivity();

              if(!isConnection){
                return false;
              }
  

        

      
      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true;
        };

      try {
        initV() async {
         
          if (variablesG.isEmpty) {
           
            List<Map<String, dynamic>> response = await getPosPropertiesV();
      
            variablesG = response;
          }
        }

    await initV();

    print('variables globales $variablesG');

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
    dynamic requestBody = {};
    Map<String, dynamic> jsonData = jsonDecode(contenidoActual);


    print("Estas son las retenciones   $retenciones");
   
  
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
          "serviceType": "UCCompositeInvoice",
          "operations": {
            "operation": [
              {
                "TargetPort": "createData",
                "ModelCRUD": {
                  "serviceType": "UCCreateInvoice",
                  "TableName": "C_Invoice",
                  "RecordID": "0",
                  "Action": "CreateUpdate",
                  "DataRow": {
                    "field": [
                      {
                        "@column": "AD_Client_ID",
                        "val": retenciones['ad_client_id']
                      },
                      {"@column": "AD_Org_ID", "val": retenciones['ad_org_id']},
                      {
                        "@column": "C_BPartner_ID",
                        "val": retenciones['c_bpartner_id'],
                      },
                      {
                        "@column": "C_BPartner_Location_ID",
                        "val": retenciones['c_bpartner_location_id'],
                      },
                       {
                        "@column": "DocumentNo",
                        "val": retenciones['documentno'],
                      },
                      {
                        "@column": "C_Currency_ID",
                        "val": "100",
                      },
                      {
                        "@column": "Description",
                        "val": retenciones['description'],
                      },
                      // {
                      //   "@column": "C_ConversionType_ID",
                      //   "val": variablesG[0]['c_conversion_type_id']
                      // },
                      {
                        "@column": "C_DocTypeTarget_ID",
                        "val": retenciones['c_doctypetarget_id']
                      },
                      {
                        "@column": "C_PaymentTerm_ID",
                        "val": retenciones['c_paymentterm_id']
                      },
                      {
                        "@column": "DateInvoiced",
                        "val": retenciones['date_invoiced']
                      },
                      {"@column": "DateAcct", "val": retenciones['date_acct']},
                      {
                        "@column": "M_PriceList_ID",
                        "val": retenciones['m_pricelist_id']
                      },
                      {"@column": "PaymentRule", "val": retenciones['payment_rule']},
                      {
                        "@column": "SalesRep_ID",
                        "val": retenciones['sales_rep_id']
                      },
                      {
                        "@column": "SRI_AuthorizationCode",
                        "val": retenciones['sri_authorization_code']
                      },
                      {
                        "@column": "ING_Establishment",
                        "val": retenciones['ing_establishment']
                      },
                      {
                        "@column": "ING_Emission",
                        "val": retenciones['ing_emission']
                      },
                       {
                        "@column": "ING_Sequence",
                        "val": retenciones['ing_sequence']
                      },
                      {
                        "@column": "ING_TaxSustance",
                        "val": retenciones['ing_taxsustance']
                      },
                      // {"@column": "LVE_PayAgreement_ID", "val": '1000001'},
                      {"@column": "AD_User_ID", "val": retenciones['sales_rep_id']},
                      {
                        "@column": "IsSOTrx",
                        "val": "N"
                      },   
                  
                    ]
                  }
                }
              },
               
            ]
          }
        }
      };

      // Crear las líneas de la orden
  final lines = createLines(retenciones['productos'],retenciones['ad_client_id'], retenciones['ad_org_id']);

  // Agregar las líneas de la orden al JSON de la orden
  for (var line in lines) {
    requestBody['CompositeRequest']['operations']['operation'].add(line);
  }

  dynamic doAction  = {
        "@preCommit": "false",
        "@postCommit": "false",
        "TargetPort": "setDocAction",                      
          "ModelSetDocAction": {
              "serviceType": "completeInvoce",
              "tableName": "C_Invoice",
              "recordIDVariable": "@C_Invoice.C_Invoice_ID",
              "docAction": variablesG[0]['doc_status_invoice_so'],
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

        dynamic documentNo = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][1]['@value'];
        dynamic cOrderId = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][0]['@value'];
        // print(' esto es el client id ${orderPurchaseList['id']} Esto es el document no $documentNo y este es el orderid $cOrderId');
        dynamic isError = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][2]['@IsError'];


                        if(isError){

                          return false;
                        }



                      //   Map<String, dynamic> nuevoDocumentNoAndCOrderId = {

                      //       'documentno': documentNo,
                      //       'c_order_id':cOrderId


                      //   };

                      // String newStatus = 'Enviado';

                      // updateOrderePurchaseForStatusSincronzed(orderPurchaseList['id'], newStatus);

                      // actualizarDocumentNoVendor(orderPurchaseList['id'], nuevoDocumentNoAndCOrderId);

    return parsedJson;

  } catch (e) {
    return 'este es el error e $e';
  }
}




createLines(lines, adClient, orgId) {
  List linea = [];

  lines.forEach((line) => {
        print("line $line"),
        linea.add({
          "@preCommit": "false",
            "@postCommit": "false",
            "TargetPort": "createData",
            "ModelCRUD": {
                "serviceType": "UCCreateInvoiceLine",
                "TableName": "C_InvoiceLine",
                "recordID": "0",
                "Action": "Create",
                "DataRow": {
          "field": [
            {"@column": "AD_Client_ID", "val": adClient},
            {"@column": "AD_Org_ID", "val": orgId},
            {"@column": "C_Invoice_ID", "val": "@C_Invoice.C_Invoice_ID"},
            {"@column": "PriceEntered", "val": line['price']},
            {"@column": "PriceActual", "val": line['price']},
            {"@column": "M_Product_ID", "val": line['m_product_id']},
            {"@column": "QtyInvoiced", "val": line['quantity']},
            {"@column": "QtyEntered", "val": line['quantity']},
    
          ]
         }
        }
        })
      });

  print("estas son las lineas $linea");

  return linea;

}



