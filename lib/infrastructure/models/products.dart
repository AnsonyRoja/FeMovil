class Product {
  final dynamic codProd;
  final String name;
  final dynamic price;
  final dynamic quantity; 
  final dynamic prodCatId;
  final String categoria;
  final dynamic qtySold;
  final dynamic taxId;
  final String taxName;
  final dynamic umId;
  final String umName;


  Product({
    required this.codProd,
    required this.name,
    required this.quantity,
    required this.price,
    required this.prodCatId,
    required this.categoria,
    required this.taxId,
    required this.taxName,
    required this.umId,
    required this.umName,
    required this.qtySold,

  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'cod_product': codProd,
      'name': name,
      'quantity': quantity,
      'price': price,
      'pro_cat_id': prodCatId,
      'categoria': categoria,
      'tax_cat_id': taxId,
      'tax_cat_name':taxName,
      'um_id': umId,
      'um_name':umName,
      'quantity_sold': qtySold, 
    };
  }

    factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      codProd: map['cod_product'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      prodCatId: map['pro_cat_id'],
      categoria: map['categoria'],
      taxId: map['tax_cat_id'],
      taxName: map['tax_cat_name'],
      umId: map['um_id'],
      umName: map['um_name'],
      qtySold: map['quantity_sold'],
    );
  }
}
