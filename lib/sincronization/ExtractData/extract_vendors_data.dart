import 'dart:convert';

// Función para procesar la respuesta de iDempiere y extraer los datos de los productos
List<Map<String, dynamic>> extractVendorsData(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> vendorsData = [];

  print('Esto es la respuesta del erp $dataRows');

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {

  
  
  for (var row in dataRows) {
    Map<String, dynamic> vendorsDatas = {
      'c_bpartner_id': row['field'][0]['val'],
      'c_code_id': row['field'][1]['val'],
      'bpname': row['field'][2]['val'],
      'email': row['field'][8]['val'],
      'c_bp_group_id': row['field'][4]['val'],
      'groupbpname':row['field'][5]['val'],
      'tax_id': row['field'][19]['val'],
      'is_vendor': row['field'][3]['val'],
      'lco_tax_id_type_id': row['field'][6]['val'],
      'tax_id_type_name':row['field'][7]['val'],
      'c_bpartner_location_id': row['field'][9]['val'],
      'is_bill_to': row['field'][10]['val'],
      'phone': row['field'][11]['val'],
      'c_location_id': row['field'][12]['val'],
      'address': row['field'][13]['val'],
      'city': row['field'][14]['val'],
      'country_name': row['field'][15]['val'],
      'postal': row['field'][16]['val'],
      'c_city_id': row['field'][17]['val'],
      'c_country_id': row['field'][18]['val'],
      'lco_taxt_payer_type_id': row['field'][20]['val'],
      'tax_payer_type_name': row['field'][21]['val'],
      'lve_person_type_id': row['field'][22]['val'],
      'person_type_name': row['field'][23]['val'],

     // Asegúrate de convertir la cantidad a un tipo numérico adecuado
      // Añade otros campos que necesites sincronizar
    };


    // print('Esto es tax payer type ${row['field'][26]['val']}');
         
             
    // Agrega los datos del producto a la lista
    vendorsData.add(vendorsDatas);
  }
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}

  print("esto es vendorData $vendorsData");

  return vendorsData;
}