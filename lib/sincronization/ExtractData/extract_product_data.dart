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

  // Itera sobre cada DataRow y extrae los datos relevantes de los productos

try {
  
  for (var row in dataRows) {
    Map<String, dynamic> productData = {
      'name': row['field'][1]['val'],
      'price':row['field'][10]['val'],
      'quantity':row['field'][9]['val'],
      'categoria':row['field'][4]['val'],
      'total_sold': 0,
      'tax_id':row['field'][5]['val'],
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