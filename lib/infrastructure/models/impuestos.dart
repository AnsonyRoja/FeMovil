class Impuesto {
  final dynamic cTaxId;
  final String taxIndicators;
  final dynamic rate; // Cantidad disponible
  final String name; // Stock mínimo
  final dynamic cTaxCategoryId;
  final String isWithHolding;


  Impuesto({
    required this.cTaxId,
    required this.taxIndicators,
    required this.rate,
    required this.name,
    required this.cTaxCategoryId,
    required this.isWithHolding
  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'c_tax_id': cTaxId,
      'tax_indicator': taxIndicators,
      'rate': rate,
      'name': name,
      'c_tax_category_id': cTaxCategoryId,
      'iswithholding': isWithHolding,
    };
  }
}
