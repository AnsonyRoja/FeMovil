import 'dart:convert';

// Supongamos que tienes la clase Product definida como antes

// Función para procesar la respuesta de iDempiere y extraer los datos de los productos
List<Map<String, dynamic>> extractProductData(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> productsData = [];

  print('Esto es la respuesta del erp $dataRows');

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {

  
  
  for (var row in dataRows) {
    Map<String, dynamic> productData = {
      'cod_product': row['field'][0]['val'],
      'm_product_id': row['field'][11]['val'],
      'name': row['field'][1]['val'],
      'price':row['field'][10]['val'],
      'quantity':row['field'][9]['val'] is int ? row['field'][9]['val'] : 0,
      'pro_cat_id':row['field'][3]['val'],
      'categoria':row['field'][4]['val'],
      'product_type':row['field'][7]['val'],
      'product_type_name':row['field'][8]['val'],
      'total_sold': 0,
      'tax_cat_id':row['field'][5]['val'],
      'tax_cat_name': row['field'][6]['val'],
      'product_group_id':row['field'][15]['val'],
      'product_group_name': row['field'][16]['val'],
      'um_id':row['field'][12]['val'],
      'um_name':row['field'][14]['val'],
      'quantity_sold': 0,
      'pricelistsales': row['field'][17]['val'],
     // Asegúrate de convertir la cantidad a un tipo numérico adecuado
      // Añade otros campos que necesites sincronizar
    };

    // Agrega los datos del producto a la lista
    productsData.add(productData);
  }
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}


  print("esto es productsData $productsData");

  return productsData;
}