




invoke(option, newValue, data){


    switch (option) {
      case 'obtenerNombreCat':

      
        // Buscar la categoría en _categoriesList que coincide con el ID dado
        Map<String, dynamic>? categoria = data.firstWhere(
          (categoria) => categoria['pro_cat_id'] == newValue,
        );

        // Si se encuentra la categoría, devolver su nombre, de lo contrario devolver una cadena vacía
        return categoria != null ? categoria['categoria'] : '';
        
        case 'obtenerNombreProductGroup':

           Map<String, dynamic>? productGroup = data.firstWhere(
            (productGroupList) => productGroupList['product_group_id'] == newValue,
          );

          print("Esto es el nombre umlist $productGroup");

          return productGroup != null ? productGroup['product_group_name'] : '';

        case 'obtenerNombreProductType':

          Map<String, dynamic>? productType = data.firstWhere(
            (productTypeList) => productTypeList['product_type'] == newValue,
          );


          return productType != null ? productType['product_type_name'] : '';        
        case 'obtenerNombreImpuesto': 
          Map<String, dynamic>? impuesto = data.firstWhere(
          (taxlist) => taxlist['tax_cat_id'] == newValue,
         );

        // Si se encuentra la categoría, devolver su nombre, de lo contrario devolver una cadena vacía
        return impuesto != null ? impuesto['tax_cat_name'] : '';
        case 'obtenerNombreUm':
            Map<String, dynamic>? um = data.firstWhere(
            (umList) => umList['um_id'] == newValue,
          );

    
          return um != null ? um['um_name'] : '';
        case  'obtenerNombreCountry':

              Map<String, dynamic>? country = data.firstWhere(
            (countryList) => countryList['c_country_id'] == newValue,
          );

          return country != null ? country['country'] : '';
            case  'obtenerNombreCountryVendor':

            Map<String, dynamic>? country = data.firstWhere(
          (countryList) => countryList['c_country_id'] == newValue,
        );

          return country != null ? country['country_name'] : '';

          case 'obtenerNombreGroup': 
               Map<String, dynamic>? groupTercero = data.firstWhere(
            (group) => group['c_bp_group_id'] == newValue,
          );

          return groupTercero != null ? groupTercero['group_bp_name'] : '';

          case 'obtenerNombreGroupVendor':
            Map<String, dynamic>? groupTercero = data.firstWhere(
            (group) => group['c_bp_group_id'] == newValue,
          );

          return groupTercero != null ? groupTercero['groupbpname'] : '';


          case 'obtenerNombreTax':

            Map<String, dynamic>? nombreTaxType = data.firstWhere(
            (taxType) => taxType['lco_tax_id_typeid'] == newValue,
          );

          return nombreTaxType != null ? nombreTaxType['tax_id_type_name'] : '';

            case 'obtenerNombreTaxVendor':

            Map<String, dynamic>? nombreTaxType = data.firstWhere(
            (taxType) => taxType['lco_tax_id_type_id'] == newValue,
          );

          return nombreTaxType != null ? nombreTaxType['tax_id_type_name'] : '';
          
          case 'obtenerNombreTaxPayerVendor':
              Map<String, dynamic>? nombreTaxPayer = data.firstWhere(
            (taxPayer) => taxPayer['lco_taxt_payer_type_id'] == newValue,
          );

          return nombreTaxPayer != null ? nombreTaxPayer['tax_payer_type_name'] : '';



          case 'obtenerNombreTaxPayer':
              Map<String, dynamic>? nombreTaxPayer = data.firstWhere(
            (taxPayer) => taxPayer['lco_tax_payer_typeid'] == newValue,
          );

          return nombreTaxPayer != null ? nombreTaxPayer['tax_payer_type_name'] : '';

          case 'obtenerNombreTypePerson':

                Map<String, dynamic>? nombreTypePerson = data.firstWhere(
            (typePerson) => typePerson['lve_person_type_id'] == newValue,
          );

          return nombreTypePerson != null ? nombreTypePerson['person_type_name'] : '';

            case 'obtenerNombreBankAccount':

                Map<String, dynamic>? nombreBankAccount = data.firstWhere(
            (typePerson) => typePerson['c_bank_id'] == newValue,
          );

          return nombreBankAccount != null ? nombreBankAccount['bank_name'] : '';



      default:
    }




}