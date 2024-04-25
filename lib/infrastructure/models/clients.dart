
class Customer {
  final dynamic cbPartnerId;
  final dynamic codClient;
  final dynamic bpName; // Cantidad disponible
  final dynamic cBpGroupId; // Stock mínimo
  final dynamic cBpGroupName; 
  final dynamic lcoTaxIdTypeId;
  final dynamic taxIdTypeName;
  final dynamic email;
  final dynamic cBparnetLocationId;
  final dynamic isBillTo;
  final dynamic phone;
  final dynamic cLocationId;
  final dynamic city;
  final dynamic region;
  final dynamic country;
  final dynamic codePostal;
  final dynamic cCityId;
  final dynamic cRegionId;
  final dynamic cCountryId;
  final String ruc;
  final dynamic address;
  final dynamic lcoTaxPayerTypeId;
  final dynamic taxPayerTypeName;
  final dynamic lvePersonTypeId;
  final dynamic personTypeName;

  Customer({
    required this.cbPartnerId,
    required this.codClient,
    required this.bpName,
    required this.cBpGroupId,
    required this.cBpGroupName,
    required this.lcoTaxIdTypeId,
    required this.taxIdTypeName,
    required this.email,
    required this.cBparnetLocationId,
    required this.isBillTo,
    required this.phone,
    required this.cLocationId,
    required this.city,
    required this.region,
    required this.country,
    required this.codePostal,
    required this.cCityId,
    required this.cRegionId,
    required this.cCountryId,
    required this.ruc,
    required this.address,
    required this.lcoTaxPayerTypeId,
    required this.taxPayerTypeName,
    required this.lvePersonTypeId,
    required this.personTypeName


  });

  // Método para convertir un producto a un mapa para ser almacenado en la base de datos
  Map<String, dynamic> toMap() {
    return {
      'c_bpartner_id': cbPartnerId,
      'cod_client': codClient,
      'bp_name': bpName,
      'c_bp_group_id': cBpGroupId,
      'group_bp_name': cBpGroupName,
      'lco_tax_id_typeid': lcoTaxIdTypeId,
      'tax_id_type_name': taxIdTypeName,
      'email':email,
      'c_bpartner_location_id': cBparnetLocationId,
      'is_bill_to': isBillTo,
      'phone': phone,
      'c_location_id': cLocationId,
      'city': city,
      'region': region,
      'country': country,
      'code_postal': codePostal,
      'c_city_id': cCityId,
      'c_region_id':cRegionId,
      'c_country_id':cCountryId,
      'ruc': ruc,
      'address': address,
      'lco_tax_payer_typeid': lcoTaxPayerTypeId,
      'tax_payer_type_name': taxPayerTypeName,
      'lve_person_type_id':lvePersonTypeId,
      'person_type_name': personTypeName

    };
  }
}
