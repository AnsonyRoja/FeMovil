import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';

Future<void> saveClientToDatabase(Customer client) async {


    print('Client ${client.toMap()}');

    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      int result = await db.insert('clients', client.toMap());

      if (result != -1) {
        print(
            'El Cliente se ha guardado correctamente en la base de datos con el id: $result');
      } else {
        print('Error al guardar el Cliente en la base de datos');
      }
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
    }
  }