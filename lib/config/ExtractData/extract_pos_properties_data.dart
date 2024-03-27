import 'dart:convert';

// Función para procesar la respuesta de iDempiere y extraer los datos de los productos
List<Map<String, dynamic>> extractGetPosPropertiesData(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> posPropertiesData = [];

  print('Esto es la respuesta del erp $dataRows');

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {

  
  

    Map<String, dynamic> posPropiertieData = {
      'country_id': dataRows[0]['field'][1]['val'],
      'tax_payer_type_natural': dataRows[4]['field'][1]['val'],
      'tax_payer_type_juridic': dataRows[5]['field'][1]['val'],
      'person_type_juridic': dataRows[6]['field'][1]['val'],
      'person_type_natural': dataRows[7]['field'][1]['val'],
      'm_warehouse_id':dataRows[8]['field'][1]['val'], 
      'c_doc_type_order_id': dataRows[9]['field'][1]['val'],
      'c_conversion_type_id': dataRows[10]['field'][1]['val'],
      'c_paymentterm_id': dataRows[11]['field'][1]['val'],
      'c_bankaccount_id': dataRows[12]['field'][1]['val'],
      'c_bpartner_id': dataRows[13]['field'][1]['val'],
      'c_doctypepayment_id': dataRows[14]['field'][1]['val'],
      'c_doctypereceipt_id': dataRows[15]['field'][1]['val'],
      'city': dataRows[16]['field'][1]['val'],
      'address1':dataRows[17]['field'][1]['val'],
      'm_pricelist_id':dataRows[18]['field'][1]['val'],
    
    };
    // Agrega los datos del producto a la lista
    posPropertiesData.add(posPropiertieData);
  
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}

  print("esto es impuestosData $posPropertiesData");

  return posPropertiesData;
}