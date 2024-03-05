class Product {
  final String name;
  final double price;
  final int quantity; // Cantidad disponible
  final double minStock; // Stock mínimo
  final double maxStock; // Stock máximo
  final String categoria;
  final String imagePath;
  final int qtySold;


  Product({
    required this.name,
    required this.price,
    required this.quantity,
    required this.minStock,
    required this.maxStock,
    required this.categoria,
    required this.imagePath,
    required this.qtySold,

  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image_path':imagePath,
      'min_stock': minStock,
      'max_stock': maxStock,
      'categoria': categoria,
      'quantity_sold': qtySold, 
    };
  }
}
