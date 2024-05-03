import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/config/url.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/presentation/clients/idempiere/create_customer.dart';
import 'package:femovil/presentation/perfil/perfil_http.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:path_provider/path_provider.dart';








updateAndCreateTercero(orderSalesList) async{

  Map<String, dynamic>? customerIsSincronized = await getClientById(orderSalesList['cliente_id']);


      print('Esto es customer $customerIsSincronized ');

        if(customerIsSincronized!['c_bpartner_id'] == 0 && customerIsSincronized['cod_client'] == 0){
          
            Customer customer = Customer(
                    cbPartnerId: customerIsSincronized['c_bpartner_id'],
                    codClient: customerIsSincronized['cod_client'],
                    isBillTo: 'Y',
                    address: customerIsSincronized['address'],
                    bpName: customerIsSincronized['bp_name'],
                    cBpGroupId: customerIsSincronized['c_bp_group_id'],
                    cBpGroupName: customerIsSincronized['group_bp_name'],
                    cBparnetLocationId: 0,
                    cCityId: customerIsSincronized['c_city_id'],
                    cCountryId: customerIsSincronized['c_country_id'],
                    cLocationId: 0, 
                    cRegionId: 0,
                    city: customerIsSincronized['city'],
                    codePostal: customerIsSincronized['code_postal'],
                    country: customerIsSincronized['country'],
                    email: customerIsSincronized['email'],
                    lcoTaxIdTypeId: customerIsSincronized['lco_tax_id_typeid'],
                    lcoTaxPayerTypeId: customerIsSincronized['lco_tax_payer_typeid'],
                    lvePersonTypeId: customerIsSincronized['lve_person_type_id'],
                    personTypeName: customerIsSincronized['person_type_name'],
                    phone: customerIsSincronized['phone'],
                    region: customerIsSincronized['region'],
                    ruc: customerIsSincronized['ruc'],
                    taxIdTypeName: customerIsSincronized['tax_id_type_name'],
                    taxPayerTypeName: customerIsSincronized['tax_payer_type_name']

                );
 
        print('Entre aqui en la creacion del cliente');
                dynamic result = await createCustomerIdempiere(customer.toMap());
    print('este es el $result');

    final cBParnertId =
        result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']
        ['outputField'][0]['@value'];
    final newCodClient =
        result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']
        ['outputField'][1]['@value'];
    final cLocationId =  result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][1]['outputFields']
        ['outputField']['@value'];
    final cBPartnerLocationId = result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][2]['outputFields']
        ['outputField']['@value'];

    print('Esto es el codigo de partnert id  $cBParnertId, esto es el $newCodClient, esto es el $cLocationId y esto es el cbparnert location id $cBPartnerLocationId');


      
    await updateCustomerCBPartnerIdAndCodClient(
        customerIsSincronized['id'], cBParnertId, newCodClient, cLocationId, cBPartnerLocationId );

        print('Entre aqui 3');

        Map<String, dynamic>? customerIsSincronizedTrue = await getClientById(orderSalesList['cliente_id']);
             final db = await DatabaseHelper.instance.database;


            try {
          if (db != null) {
            print('entre aqui 4');
            int rowsAffected = await db.update(
              'orden_venta',
              {
                'c_bpartner_location_id': customerIsSincronizedTrue!['c_bpartner_location_id'],
                'c_bpartner_id': customerIsSincronizedTrue['c_bpartner_id'],
              },
              where: 'cliente_id = ?',
              whereArgs: [customerIsSincronizedTrue['id']],
            );

            print('Filas afectadas: $rowsAffected');
          }
        } catch (e) {
          print('Error al actualizar la base de datos: $e');
        }
        
        }


  return await obtenerOrdenDeVentaConLineasPorId(orderSalesList['id']);


}




Future<bool> checkInternetConnectivity() async {
  dynamic map = await getRuta();
  try {
    // Desactivar la verificación del certificado SSL
    HttpClient client = HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

    // Realizar la solicitud HTTP con el cliente personalizado
    final response = await client.headUrl(Uri.parse('${map['URL']}'));
    final httpResponse = await response.close();

      print('Esto es http ${httpResponse.statusCode}');
    // Verificar si la respuesta tiene un código de estado exitoso (2xx)
    if (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) {
      // Se recibió una respuesta exitosa, lo que significa que hay conexión a internet
      return true;
    } else {
      // No se recibió una respuesta exitosa, lo que significa que no hay conexión a internet
      return false;
    }
  } catch (e) {
    // Si ocurre algún error durante la solicitud, asumimos que no hay conexión a internet
    print('Error al verificar la conexión a internet: $e');
    return false;
  }
}

// Esta funcion nos ayudara a crear una nueva orden

createOrdenSalesIdempiere(orderSalesList) async {


   dynamic isConnection = await checkInternetConnectivity();

              if(!isConnection){
                return false;
              }
    

          if(orderSalesList!['c_bpartner_id'] == 0 && orderSalesList['c_bpartner_location_id'] == 0){

            orderSalesList = await updateAndCreateTercero(orderSalesList);
          
          }
        






    print('Esto es ordersaleslist actual $orderSalesList');

      HttpClient httpClient = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          return true;
        };

      try {
        initV() async {
          if (variablesG.isEmpty) {
            List<Map<String, dynamic>> response = await getPosPropertiesV();
            print('variables Entre aqui');
            variablesG = response;
          }
        }

   await initV();

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
                        "val": variablesG[0]['c_currency_id'],
                      },
                      {
                        "@column": "Description",
                        "val": orderSalesList['descripcion'],
                      },
                      // {
                      //   "@column": "C_ConversionType_ID",
                      //   "val": variablesG[0]['c_conversion_type_id']
                      // },
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
                        "val": variablesG[0]['m_price_saleslist_id']
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
                      {
                        "@column": "AD_User_ID",
                        "val": orderSalesList['usuario_id']
                      },
                      {
                        "@column": "Bill_User_ID",
                        "val": orderSalesList['usuario_id']
                      },
     
                      // {"@column": "LVE_PayAgreement_ID", "val": '1000001'},
                      {"@column": "IsSOTrx", "val": 'Y'}

                  
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
              "docAction": variablesG[0]['doc_status_order_so'],
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

      print("esta es la respuesta $parsedJson on");

   
          
        // dynamic isErrorTwo = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse']['@IsError'] ?? 0;
        //   if(isErrorTwo == 0){
        //     print('no hay errores');
        //   }else if(isErrorTwo){
        //     return false;
        //   }

        dynamic documentNo = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][1]['@value'];

        dynamic cOrderId = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][0]['outputFields']['outputField'][0]['@value'];

        dynamic isError = parsedJson['CompositeResponses']['CompositeResponse']['StandardResponse'][2]['@IsError'];


                        if(isError){

                          return false;
                        }

                        Map<String, dynamic> nuevoDocumentNoAndCOrderId = {

                            'documentno': documentNo,
                            'c_order_id':cOrderId


                        };
       

                      String newStatus = 'Enviado';
                      await updateOrdereSalesForStatusSincronzed(orderSalesList['id'], newStatus);
                      await actualizarDocumentNo(orderSalesList['id'], nuevoDocumentNoAndCOrderId);


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


