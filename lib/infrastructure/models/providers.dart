class Proveedor {
  final String name;
  final double ruc;
  final String correo; // Cantidad disponible
  final int telefono; // Stock mínimo
  final String grupo; // Stock máximo


  Proveedor({
    required this.name,
    required this.ruc,
    required this.correo,
    required this.telefono,
    required this.grupo,
  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ruc': ruc,
      'correo': correo,
      'telefono': telefono,
      'grupo': grupo,
    };
  }
}
