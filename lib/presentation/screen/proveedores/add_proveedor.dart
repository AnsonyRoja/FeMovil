import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/infrastructure/models/providers.dart';
import 'package:femovil/infrastructure/models/vendors.dart';
import 'package:femovil/presentation/screen/proveedores/select_vendor.dart';
import 'package:flutter/material.dart';





class AddProvidersForm extends StatefulWidget {
  const AddProvidersForm({super.key});

  @override
  _AddProvidersFormState createState() => _AddProvidersFormState();
}

class _AddProvidersFormState extends State<AddProvidersForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
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

      loadList();

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(title: const Text("Agregar Proveedor", style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Color.fromARGB(255, 105, 102, 102),
          ),),
             backgroundColor: const Color.fromARGB(255, 236, 247, 255),
             iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
    
           ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          
          width: 250,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   const ContainerBlue(label:'Datos Del Proveedor',),

                const SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre del Proveedor', filled: true, fillColor: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre del Proveedor';
                      }
                      return null;
                    },
                   keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _rucController,
                    decoration: const InputDecoration(labelText: 'RUC/DNI', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un RUC Valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: 'Correo', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.text,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un correo';
                      }
                      return null;
                    },
                  ),
                   const SizedBox(height: 10,),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(labelText: 'Telefono', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el telefono del Proveedor';
                      }
                      return null;
                    },
                  ),
                   const SizedBox(height: 10,),
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
                // CustomDropdownButtonFormFieldVendor(identifier: 'typePersonVendor', selectedIndex: _selectedPersonTypeIndex, dataList:_typePersonList, text: _personTypeText, onSelected: (newValue, personTypeText) {

                //     setState(() {

                //         _selectedPersonTypeIndex = newValue ?? 0;
                //         _personTypeText = personTypeText;

                //     });

                // },),
               const SizedBox(height: 15,),
               const ContainerBlue(label:'Domicilio Fiscal',),
               const SizedBox(height: 15,),
              CustomDropdownButtonFormFieldVendor(identifier: 'countryVendor', selectedIndex: _selectedCountryIndex, dataList:_countryVendorList, text: _countryTex, onSelected: (newValue, countryText) {

                  setState(() {

                      _selectedCountryIndex = newValue ?? 0;
                      _countryTex = countryText;

                  });

              },),
              const SizedBox(height: 10,),
                TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'Ciudad', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.text,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la ciudad del proveedor';
                      }
                      return null;
                    },
                   
                  ),

              const SizedBox(height: 10,),
              TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Dirección', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.text,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una dirección del Proveedor';
                      }
                      return null;
                    },
                    maxLines: 2,
                  ),
              const SizedBox(height: 10,),
              TextFormField(
                    controller: _codePostalController,
                    decoration: const InputDecoration(labelText: 'Codigo Postal', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el codigo postal del Proveedor';
                      }
                      return null;
                    },
                  ),
           
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Guarda el producto en la base de datos Sqflite
                            _saveProduct();
                          }
                        },
                         style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                         shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(10.0), 
                        ),
                         ),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    // Obtén los valores del formulario
    String bpName = _nameController.text;
    String taxId = _rucController.text;
    String email = _correoController.text;
    int phone = int.parse(_telefonoController.text);
    String address =_addressController.text;
    String city = _cityController.text;
    String codePostal = _codePostalController.text;

    // ID
    int idGroup = _selectedGroupIndex; 
    int taxTypeId = _selectedTaxIndexType;
    int countryId = _selectedCountryIndex;
    int taxPayerVendorId = _selectedTaxPayerIndex;
    int personTypeId = _selectedPersonTypeIndex;
    // Strings
    String groupText = _groupTextVendor;
    String taxIdText = _taxTypeText;
    String countryName = _countryTex;
    String taxPayerName = _taxPayerText;
    String personTypeName = _personTypeText;
    // Crea una instancia del producto

      Vendor provider = Vendor(
        cBPartnerId: 0, 
        cCodeId: 0, 
        bPName: bpName, 
        email: email, 
        cBPGroupId: idGroup, 
        groupBPName: groupText, 
        taxId: taxId, 
        isVendor: 'Y', 
        lcoTaxIdTypeId: taxTypeId, 
        taxIdTypeName: taxIdText, 
        cBPartnerLocationId: 0, 
        isBillTo: 'Y', 
        phone: phone, 
        cLocationId: 0, 
        address: address, 
        city: city, 
        countryName: countryName, 
        postal: codePostal, 
        cCityId: 0, 
        cCountryId: countryId,
        lcoTaxtPayerTypeId: taxPayerVendorId,
        taxPayerTypeName: taxPayerName,
        lvePersonTypeId: personTypeId,
        personTypeName: personTypeName
        
        );

    // Llama a un método para guardar el producto en Sqflite
    await saveProviderToDatabase(provider);

    // Limpia los controladores de texto después de guardar el producto
    _nameController.clear();
    _rucController.clear();
    _correoController .clear();
    _telefonoController.clear();
    _addressController.clear();
    _cityController.clear();
    _codePostalController.clear();


    setState(() {
    
       _selectedGroupIndex = 0; 
       _selectedTaxIndexType = 0;
       _selectedCountryIndex = 0;
       _selectedPersonTypeIndex = 0;
       _selectedTaxPayerIndex = 0;
       
    });


  

    // Muestra un mensaje de éxito o realiza cualquier otra acción necesaria
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Proveedor guardado correctamente'),
    ));


  }

  Future<void> saveProviderToDatabase(Vendor provider) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      int result = await db.insert('providers', provider.toMap());

      if (result != -1) {
        print('El providers se ha guardado correctamente en la base de datos con el id: $result');
      } else {
        print('Error al guardar el providers en la base de datos');
      }
    } else {
      // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
      print('Error: db is null');
    }
  }

  @override
  void dispose() {
    // Limpia los controladores de texto cuando el widget se elimina del árbol

    _nameController.dispose();
    _rucController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();

    super.dispose();
  }
}

class ContainerBlue extends StatelessWidget {
   final String label;
  const ContainerBlue({
    super.key, required this.label,
      
  });

  @override
  Widget build(BuildContext context) {
    return Container(
     width: 300 ,
     decoration: BoxDecoration(
       color: Colors.blue,
       borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
     ),
     child:  Text(label, style:  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                      );
  }
}









































