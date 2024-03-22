




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
        
      
      default:
    }




}