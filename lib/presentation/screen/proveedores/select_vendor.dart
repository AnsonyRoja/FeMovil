import 'package:femovil/presentation/products/utils/switch_generated_names_select.dart';
import 'package:flutter/material.dart';


class CustomDropdownButtonFormFieldVendor extends StatelessWidget {
    final String identifier;
   final int selectedIndex;
   final String text;
   final List<Map<String, dynamic>> dataList; 
    final Function(int?, String) onSelected;

  const CustomDropdownButtonFormFieldVendor({super.key, required this.identifier, required this.selectedIndex, required this.dataList, required this.text, required this.onSelected});


  @override
  Widget build(BuildContext context) {

      switch (identifier) {
      case 'groupTypeVendor':
         return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((groupList) => groupList['c_bp_group_id'] is int && groupList['groupbpname'] != '')
                        .map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['c_bp_group_id'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(group['groupbpname'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print('esto es el taxList ${dataList}');
                      String nameGroup =
                          invoke('obtenerNombreGroupVendor', newValue, dataList);
                      print("esto es el nombre de los grupos de proveedores $nameGroup");
                      onSelected(newValue, nameGroup);
                   
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un grupo';
                      }
                      return null;
                    },
                  );
        case 'taxTypeVendor' : 

        return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((groupList) => groupList['lco_tax_id_type_id'] is int && groupList['tax_id_type_name'] != '')
                        .map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['lco_tax_id_type_id'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(group['tax_id_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print('esto es el taxList ${dataList}');
                      String nameGroup =
                          invoke('obtenerNombreTaxVendor', newValue, dataList);
                      print("esto es el nombre del tipo de contribuyente proveedor $nameGroup");
                      onSelected(newValue, nameGroup);
                   
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un grupo';
                      }
                      return null;
                    },
                  );
       case 'countryVendor' : 

         return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((groupList) => groupList['c_country_id'] is int && groupList['country_name'] != '')
                        .map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['c_country_id'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(group['country_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print('esto es el taxList ${dataList}');
                      String nameGroup =
                          invoke('obtenerNombreCountryVendor', newValue, dataList);
                      print("esto es el nombre del pais $nameGroup");
                      onSelected(newValue, nameGroup);
                   
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un grupo';
                      }
                      return null;
                    },
                  );
        case 'taxPayerVendor' : 

         return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((groupList) => groupList['lco_taxt_payer_type_id'] is int && groupList['tax_payer_type_name'] != '')
                        .map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['lco_taxt_payer_type_id'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(group['tax_payer_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print('esto es el taxList ${dataList}');
                      String nameGroup =
                          invoke('obtenerNombreTaxPayerVendor', newValue, dataList);
                      print("esto es el nombre del tipo de contribuyente $nameGroup");
                      onSelected(newValue, nameGroup);
                   
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un grupo';
                      }
                      return null;
                    },
                  );

          case 'typePersonVendor' :

             return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((groupList) => groupList['lve_person_type_id'] is int && groupList['person_type_name'] != '')
                        .map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['lve_person_type_id'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(group['person_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      print('esto es el taxList ${dataList}');
                      String nameGroup =
                          invoke('obtenerNombreTypePerson', newValue, dataList);

                      print("esto es el nombre del tipo de persona $nameGroup");
                      onSelected(newValue, nameGroup);
                   
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un grupo';
                      }
                      return null;
                    },
                  );


        
      default:  return    DropdownButtonFormField<int>(
                    value: selectedIndex,
                    items: dataList
                        .where((defaults) => defaults['key'] is int)
                        .map<DropdownMenuItem<int>>((defaults) {
                      return DropdownMenuItem<int>(
                        value: defaults['key'] as int,
                        child: Text(defaults['value'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                
                        onSelected(newValue, 'Nada');

                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor crea el idenficiador del select';
                      }
                      return null;
                    },
                  );
    }


  }
}

