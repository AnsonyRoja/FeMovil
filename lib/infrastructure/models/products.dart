class Product {
  final dynamic codProd;
  final dynamic mProductId;
  final String name;
  final dynamic productType;
  final dynamic productTypeName;
  final dynamic price;
  final dynamic quantity; 
  final dynamic prodCatId;
  final dynamic categoria;
  final dynamic qtySold;
  final dynamic taxId;
  final String taxName;
  final dynamic umId;
  final String umName;
  final dynamic productGroupId;
  final String produtGroupName;
  final dynamic priceListSales;

  Product({
    required this.codProd,
    required this.mProductId,
    required this.name,
    required this.productType,
    required this.productTypeName,
    required this.quantity,
    required this.price,
    required this.prodCatId,
    required this.categoria,
    required this.taxId,
    required this.taxName,
    required this.umId,
    required this.umName,
    required this.qtySold,
    required this.productGroupId,
    required this.produtGroupName,
    required this.priceListSales,
  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'cod_product': codProd,
      'm_product_id':mProductId,
      'name': name,
      'quantity': quantity,
      'price': price,
      'product_type': productType,
      'product_type_name': productTypeName,
      'pro_cat_id': prodCatId,
      'categoria': categoria,
      'product_group_id': productGroupId,
      'product_group_name':produtGroupName,
      'tax_cat_id': taxId,
      'tax_cat_name':taxName,
      'um_id': umId,
      'um_name':umName,
      'quantity_sold': qtySold, 
      'pricelistsales': priceListSales
    };
  }

    factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      codProd: map['cod_product'],
      mProductId: map['m_product_id'],
      productType: map['product_type'],
      productTypeName: map['prodyct_type_name'],
      name: map['name'],
      quantity: map['quantity'],
      price: map['price'],
      prodCatId: map['pro_cat_id'],
      categoria: map['categoria'],
      productGroupId: map['product_group_id'],
      produtGroupName: map['product_group_name'],
      taxId: map['tax_cat_id'],
      taxName: map['tax_cat_name'],
      umId: map['um_id'],
      umName: map['um_name'],
      qtySold: map['quantity_sold'],
      priceListSales: map['pricelistsales'],
    );
  }
}
