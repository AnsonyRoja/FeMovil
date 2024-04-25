import 'dart:convert';

// Función para procesar la respuesta de iDempiere y extraer los datos de los productos
List<Map<String, dynamic>> extractBankAccountData(String responseData) {
  // Decodifica la respuesta JSON
  Map<String, dynamic> parsedResponse = jsonDecode(responseData);

  // Extrae la lista de DataRow de la respuesta
  List<dynamic> dataRows = parsedResponse['WindowTabData']['DataSet']['DataRow'];

  // Crea una lista para almacenar los datos de los productos
  List<Map<String, dynamic>> bankAccountsData = [];

  print('Esto es la respuesta de las bank accounts $dataRows');


try {

  
  
  for (var row in dataRows) {
    Map<String, dynamic> bankAccountData = {
      'c_bank_id': row['field'][0]['val'],
      'bank_name': row['field'][1]['val'],
      'routing_no': row['field'][2]['val'],
      'c_bank_account_id': row['field'][3]['val'],
      'account_no': row['field'][4]['val'],
      'c_currency_id':row['field'][5]['val'],
      'iso_code': row['field'][6]['val']
     // Asegúrate de convertir la cantidad a un tipo numérico adecuado
      // Añade otros campos que necesites sincronizar

    };

    // Agrega los datos del producto a la lista
    bankAccountsData.add(bankAccountData);
  }
} catch (e) {

  print("ESTE ES EL ERROR $e");
  
}

  print("Estos son los bancos disponibles desde idempiere $bankAccountsData");

  return bankAccountsData;
}