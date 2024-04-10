import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/presentation/screen/proveedores/add_proveedor.dart';
import 'package:femovil/presentation/screen/proveedores/select_vendor.dart';
import 'package:flutter/material.dart';

class EditProviderScreen extends StatefulWidget {
  final Map<String, dynamic> provider;

  const EditProviderScreen({super.key, required this.provider});

  @override
  _EditProviderScreenState createState() => _EditProviderScreenState();
}

class _EditProviderScreenState extends State<EditProviderScreen> {
  final _nameController = TextEditingController();
  final _rucController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();

   // List
  final List<Map<String, dynamic>> _groupVendorList = [];
  final List<Map<String, dynamic>> _taxTypeVendorList = [];
  final List<Map<String, dynamic>> _countryVendorList = [];
  final List<Map<String, dynamic>> _taxPayerList = [];
  final List<Map<String, dynamic>> _typePersonList = [];

  //SELECTED 
   int _selectedGroupIndex = 0;
   int _selectedTaxIndexType = 0;
   int _selectedCountryIndex = 0;
   int _selectedTaxPayerIndex = 0;
   int _selectedPersonTypeIndex = 0;

  //Text o String

   String _groupTextVendor = '';
   String _taxTypeText = '';
   String _countryTex = '';
   String _taxPayerText = '';
   String _personTypeText = '';


    loadList() async {
      

        List<Map<String, dynamic>> getGroupVendor = await  listarTypeGroupVendor();
        List<Map<String, dynamic>> getTaxTypeVendor = await listarTypeTaxVendor();
        List<Map<String, dynamic>> getCountryVendor = await listarCountryVendor();
        List<Map<String, dynamic>> getTaxPayerVendor = await listarTaxPayerVendors();
        List<Map<String, dynamic>> getTypePerson = await listarPersonTypeVendors();

          print('Value de getGroupVendor $getGroupVendor ');
          print('Value de getTaxTypeVendor $getTaxTypeVendor');

          _groupVendorList.add({'c_bp_group_id': 0, 'groupbpname': 'Selecciona un Grupo'});
          _taxTypeVendorList.add({'lco_tax_id_type_id': 0, 'tax_id_type_name': 'Selecciona un tipo de impuesto'});
          _countryVendorList.add({'c_country_id': 0, 'country_name': 'Selecciona un Pais'});
          _taxPayerList.add({'lco_taxt_payer_type_id': 0, 'tax_payer_type_name': 'Selecciona un tipo de contribuyente' });
          _typePersonList.add({'lve_person_type_id': 0, 'person_type_name': 'Selecciona un tipo de persona'});


        setState(() {
          
          _groupVendorList.addAll(getGroupVendor);
          _taxTypeVendorList.addAll(getTaxTypeVendor);
          _countryVendorList.addAll(getCountryVendor);
          _taxPayerList.addAll(getTaxPayerVendor);
          _typePersonList.addAll(getTypePerson);
        });

    }


  @override
  void initState() {
    super.initState();
    loadList();
    // Initialize controllers with existing product details
    _nameController.text = widget.provider['bpname'].toString();
    _rucController.text = widget.provider['tax_id'].toString();
    _correoController.text = widget.provider['email'].toString() != '{@nil=true}' ? widget.provider['email'].toString() : 'Sin registro' ;
    _telefonoController.text = widget.provider['phone'].toString() != '{@nil=true}' ? widget.provider['phone'].toString() : 'Sin registro' ;
    _groupTextVendor = widget.provider['groupbpname'].toString();
    _taxPayerText = widget.provider['tax_payer_type_name'].toString();
    _taxTypeText = widget.provider['tax_id_type_name'].toString();
    _personTypeText = widget.provider['person_type_name'].toString();
    _countryTex = widget.provider['country_name'].toString();
    _selectedGroupIndex = widget.provider['c_bp_group_id'];
    _selectedTaxIndexType = widget.provider['lco_tax_id_type_id'];
    _selectedTaxPayerIndex = widget.provider['lco_taxt_payer_type_id'];
    _selectedPersonTypeIndex = widget.provider['lve_person_type_id'];
    _selectedCountryIndex = widget.provider['c_country_id'];
    _addressController.text = widget.provider['address'].toString();
    _cityController.text = widget.provider['city'].toString();
    _codePostalController.text = widget.provider['postal'].toString() != '{@nil=true}' ? widget.provider['postal'].toString(): 'Sin Codigo Postal';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

       FocusScope.of(context).requestFocus(FocusNode());

      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Editar Proveedor",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 102, 102),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  const ContainerBlue(label: 'Datos Personales'),
                  const SizedBox(height: 10,),
                  _buildTextFormField('Nombre', _nameController,1),
                  _buildTextFormField('Ruc', _rucController,1),
                  _buildTextFormField('Correo', _correoController, 1),
                  _buildTextFormField('Telefono', _telefonoController,1),
                 CustomDropdownButtonFormFieldVendor(identifier: 'groupTypeVendor', selectedIndex: _selectedGroupIndex, dataList: _groupVendorList, text: _groupTextVendor, onSelected: (newValue, groupText) {

                    setState(() {

                        _selectedGroupIndex = newValue ?? 0;
                        _groupTextVendor = groupText;

                    });

                },),
                   const SizedBox(height: 10,),
                CustomDropdownButtonFormFieldVendor(identifier: 'taxTypeVendor', selectedIndex: _selectedTaxIndexType, dataList:_taxTypeVendorList, text: _taxTypeText, onSelected: (newValue, taxTex) {

                    setState(() {

                        _selectedTaxIndexType = newValue ?? 0;
                        _taxTypeText = taxTex;

                    });

                },),
                       const SizedBox(height: 10,),
                CustomDropdownButtonFormFieldVendor(identifier: 'taxPayerVendor', selectedIndex: _selectedTaxPayerIndex, dataList:_taxPayerList, text: _taxPayerText, onSelected: (newValue, taxPayerText) {

                    setState(() {

                        _selectedTaxPayerIndex = newValue ?? 0;
                        _taxPayerText = taxPayerText;

                    });

                },),
                   const SizedBox(height: 10,),
                CustomDropdownButtonFormFieldVendor(identifier: 'typePersonVendor', selectedIndex: _selectedPersonTypeIndex, dataList:_typePersonList, text: _personTypeText, onSelected: (newValue, personTypeText) {

                    setState(() {

                        _selectedPersonTypeIndex = newValue ?? 0;
                        _personTypeText = personTypeText;

                    });

                },),
              const SizedBox(height: 10,),

               const ContainerBlue(label: 'Domicilio Fiscal'),
               const SizedBox(height: 10,),
                CustomDropdownButtonFormFieldVendor(identifier: 'countryVendor', selectedIndex: _selectedCountryIndex, dataList:_countryVendorList, text: _countryTex, onSelected: (newValue, countryText) {

                  setState(() {

                      _selectedCountryIndex = newValue ?? 0;
                      _countryTex = countryText;

                  });

              },),
                const SizedBox(height: 10,),
               _buildTextFormField('Ciudad', _cityController, 1 ),
              _buildTextFormField('Direccion', _addressController, 2),
              _buildTextFormField('Codigo Postal', _codePostalController, 1)


                ],

              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
           String newName = _nameController.text;
    String newRuc = _rucController.text;
    String newCorreo = _correoController.text;
    String newTelefono = _telefonoController.text;
    String addressD = _addressController.text;
    String ciudad = _cityController.text;
    String codigoPostal = _codePostalController.text;

    //Selected Id 
    int selectGroupId = _selectedGroupIndex;
    int selectTaxId = _selectedTaxIndexType;
    int selectCountry = _selectedCountryIndex;
    int selectTaxPayerId = _selectedTaxPayerIndex;
    int selectTypePerson= _selectedPersonTypeIndex;
    //Strings
    String groupText = _groupTextVendor;
    String typeTaxText = _taxTypeText;
    String countryText = _countryTex;
    String taxPayerText = _taxPayerText;
    String typePersonText = _personTypeText;

    // Crear un mapa con los datos actualizados del producto
    Map<String, dynamic> updatedprovider = {
      'id': widget.provider['id'], // Asegúrate de incluir el ID del producto
      'c_bpartner_id': widget.provider['c_bpartner_id'],
      'c_code_id': widget.provider['c_code_id'],
      'bpname': newName,
      'email': newCorreo,
      'c_bp_group_id': selectGroupId,
      'groupbpname': groupText,
      'tax_id': newRuc,
      'is_vendor': widget.provider['is_vendor'],
      'lco_tax_id_type_id': selectTaxId,
      'tax_id_type_name': typeTaxText,
      'c_bpartner_location_id': widget.provider['c_bpartner_location_id'],
      'is_bill_to' : widget.provider['is_bill_to'],
      'phone': newTelefono,
      'c_location_id': widget.provider['c_location_id'],
      'address': addressD,
      'city': ciudad,
      'country_name': countryText,
      'postal': codigoPostal,
      'c_city_id' : widget.provider['c_city_id'],
      'c_country_id': selectCountry,
      'lco_taxt_payer_type_id': selectTaxPayerId,
      'tax_payer_type_name': taxPayerText,
      'lve_person_type_id': selectTypePerson,
      'person_type_name': typePersonText,
    };

    // Actualizar el producto en la base de datos
    await updateProvider(updatedprovider);

        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Proveedor actualizado satisfactoriamente'),
          duration: Duration(seconds: 2), 
          backgroundColor: Colors.green,
        ),
      );

    // Cerrar la pantalla de edición después de actualizar el producto
    Navigator.pop(context);
          },
          backgroundColor: Colors.blue, // Color del botón
          child: const Icon(Icons.save),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, int lines) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        maxLines: lines,
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _rucController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }
}
