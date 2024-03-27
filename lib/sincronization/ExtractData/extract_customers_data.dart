import 'dart:convert';

// Función para procesar la respuesta de iDempiere y extraer los datos de los productos
List<Map<String, dynamic>> extractCustomersData(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> customersData = [];

  print('Esto es la respuesta del erp $dataRows');

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {

  
  
  for (var row in dataRows) {
    Map<String, dynamic> customerData = {
      'c_bpartner_id': row['field'][0]['val'],
      'cod_client': row['field'][1]['val'],
      'bp_name': row['field'][2]['val'],
      'c_bp_group_id': row['field'][5]['val'],
      'group_bp_name': row['field'][6]['val'],
      'lco_tax_id_typeid':row['field'][7]['val'],
      'tax_id_type_name': row['field'][8]['val'],
      'email': row['field'][11]['val'],
      'c_bpartner_location_id': row['field'][12]['val'],
      'is_bill_to':row['field'][13]['val'],
      'phone': row['field'][14]['val'],
      'c_location_id': row['field'][15]['val'],
      'city': row['field'][16]['val'],
      'region': row['field'][17]['val'],
      'country': row['field'][18]['val'],
      'codigo_postal': row['field'][19]['val'],
      'c_city_id': row['field'][20]['val'],
      'c_region_id': row['field'][21]['val'],
      'c_country_id': row['field'][22]['val'],
      'ruc': row['field'][23]['val'],
      'address' : row['field'][24]['val'],
      'lco_tax_payer_typeid': row['field'][25]['val'],
      'tax_payer_type_name': row['field'][26]['val'],
      'lve_person_type_id': row['field'][27]['val'],
      'person_type_name': row['field'][28]['val'],


     // Asegúrate de convertir la cantidad a un tipo numérico adecuado
      // Añade otros campos que necesites sincronizar
    };


    print('Esto es tax payer type ${row['field'][26]['val']}');
         
             
    // Agrega los datos del producto a la lista
    customersData.add(customerData);
  }
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}

  print("esto es impuestosData $customersData");

  return customersData;
}