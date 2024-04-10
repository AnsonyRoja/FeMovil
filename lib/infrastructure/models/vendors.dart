






 class Vendor {

    final dynamic id;
    final dynamic cBPartnerId;
    final dynamic cCodeId;
    final dynamic bPName;
    final dynamic email;
    final dynamic cBPGroupId;
    final dynamic groupBPName;
    final dynamic taxId;
    final dynamic isVendor;
    final dynamic lcoTaxIdTypeId;
    final dynamic taxIdTypeName;
    final dynamic cBPartnerLocationId;
    final dynamic isBillTo;
    final dynamic phone;
    final dynamic cLocationId;
    final dynamic address;
    final dynamic city;
    final dynamic countryName;
    final dynamic postal;
    final dynamic cCityId;
    final dynamic cCountryId;
    final dynamic lcoTaxtPayerTypeId;
    final dynamic taxPayerTypeName;
    final dynamic lvePersonTypeId;
    final dynamic personTypeName;

  Vendor({
   this.id,
   required this.cBPartnerId, 
   required this.cCodeId , 
   required this.bPName, 
   required this.email,
   required this.cBPGroupId, 
   required this.groupBPName,
   required this.taxId,
   required this.isVendor,
   required this.lcoTaxIdTypeId,
   required this.taxIdTypeName,
   required this.cBPartnerLocationId,
   required this.isBillTo,
   required this.phone,
   required this.cLocationId,
   required this.address,
   required this.city, 
   required this.countryName,
   required this.postal,
   required this.cCityId,
   required this.cCountryId,
   required this.lcoTaxtPayerTypeId,
   required this.taxPayerTypeName,
   required this.lvePersonTypeId,
   required this.personTypeName,

   });


  Map<String, dynamic> toMap() {


      return {

        
          'c_bpartner_id': cBPartnerId,
          'c_code_id': cCodeId,
          'bpname': bPName,
          'email': email,
          'c_bp_group_id': cBPGroupId,
          'groupbpname': groupBPName,
          'tax_id': taxId,
          'is_vendor' : isVendor,
          'lco_tax_id_type_id': lcoTaxIdTypeId,
          'tax_id_type_name': taxIdTypeName,
          'c_bpartner_location_id': cBPartnerLocationId,
          'is_bill_to' : isBillTo,
          'phone' : phone,
          'c_location_id': cLocationId,
          'address': address,
          'city': city,
          'country_name': countryName,
          'postal': postal,
          'c_city_id': cCityId,
          'c_country_id': cCountryId,
          'lco_taxt_payer_type_id': lcoTaxtPayerTypeId,
          'tax_payer_type_name': taxPayerTypeName,
          'lve_person_type_id': lvePersonTypeId,
          'person_type_name': personTypeName,
      };

  }



 }








