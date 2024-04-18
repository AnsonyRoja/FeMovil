import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/presentation/clients/select_customer.dart';
import 'package:flutter/material.dart';

class AddClientsForm extends StatefulWidget {
  const AddClientsForm({super.key});

  @override
  _AddClientsFormState createState() => _AddClientsFormState();
}

class _AddClientsFormState extends State<AddClientsForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rucController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController(); 
  final TextEditingController _codePostalController = TextEditingController();
 
//List
  final List<Map<String, dynamic>> _countryList = [];
  final List<Map<String, dynamic>> _groupList = [];
  final List<Map<String, dynamic>> _taxTypeList = [];
  final List<Map<String, dynamic>> _taxPayerList = [];
  final List<Map<String, dynamic>> _typePersonList =[];

  // SELECTED
  int _selectedCountryIndex = 0;
  int _selectedGroupIndex = 0;
  int _selectedTaxType = 0;
  int _selectedTaxPayer = 0;
  int _seletectedTypePerson = 0;
// Text

  String _countryText = '';
  String _groupText = '';
  String _taxTypeText = '';
  String _taxPayerText = '';
  String _typePersonText = '';

  loadList() async {
    List<Map<String, dynamic>> getCountryGroup = await listarCountryGroup();
    List<Map<String, dynamic>> getGroupTercero = await listarGroupTercero();
    List<Map<String, dynamic>> getTaxType = await listarTaxType();
    List<Map<String, dynamic>> getTaxPayer = await listarTaxPayer();
    List<Map<String, dynamic>> getTypePerson = await listarTypePerson();
    print('Esta es la respuesta $getCountryGroup');
    print('Esta es la respuesta de getGroupTercero $getGroupTercero');
    print('Esto es getTaxType $getTaxType');
    print('Estos son los taxPayers $getTaxPayer');
    print('Estos son los type person $getTypePerson');
    _countryList.add({'c_country_id': 0, 'country': 'Selecciona un País'});
    _groupList
        .add({'c_bp_group_id': 0, 'group_bp_name': 'Selecciona un Grupo'});
    _taxTypeList.add({
      'lco_tax_id_typeid': 0,
      'tax_id_type_name': 'Selecciona un tipo de impuesto'
    });
    _taxPayerList.add({
      'lco_tax_payer_typeid': 0,
      'tax_payer_type_name': 'Selecciona un tipo de contribuyente'
    });
    _typePersonList.add({
      'lve_person_type_id': 0,
      'person_type_name': 'Selecciona un tipo de Persona'
    });

    setState(() {
      _countryList.addAll(getCountryGroup);
      _groupList.addAll(getGroupTercero);
      _taxTypeList.addAll(getTaxType);
      _taxPayerList.addAll(getTaxPayer);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        appBar: AppBar(
          title: const Text(
            "Agregar Cliente",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 105, 102, 102),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 236, 247, 255),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Datos Personales",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                          labelText: 'Nombre Completo',
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre del Cliente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _rucController,
                      decoration: const InputDecoration(
                          labelText: 'Ruc/Dni',
                          filled: true,
                          fillColor: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un Ruc/Dni Valido';
                        }
                        return null;
                      },
                    ),
              
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdownButtonFormField(identifier: 'groupBp', selectedIndex:_selectedGroupIndex, dataList: _groupList, text: _groupText, onSelected: (newValue, selected) {

                        setState(() {
                            _selectedGroupIndex = newValue ?? 0; 
                            _groupText = selected;
                        });

                    },),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdownButtonFormField(identifier: 'taxType', selectedIndex: _selectedTaxType, dataList: _taxTypeList, text: _taxTypeText, onSelected: (newValue, taxTex) {

                        setState(() {
                          _selectedTaxType = newValue ?? 0;
                          _taxTypeText = taxTex;

                        });

                    },),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropdownButtonFormField(identifier: 'taxPayer', selectedIndex: _selectedTaxPayer, dataList: _taxPayerList, text: _taxPayerText, onSelected: (newValue, payerText) {

                        setState(() {
                          _selectedTaxPayer= newValue ?? 0;
                          _taxPayerText = payerText;
                        });

                    },),
                    const SizedBox(height: 10,),
                    // CustomDropdownButtonFormField(identifier: 'typePerson', selectedIndex: _seletectedTypePerson, dataList: _typePersonList, text: _typePersonText, onSelected: (newValue, tyPersonText) {
                    //     setState(() {
                    //       _seletectedTypePerson = newValue ?? 0;
                    //       _typePersonText = tyPersonText;

                    //     });

                    // },),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _correoController,
                      decoration: const InputDecoration(
                          labelText: 'Correo',
                          filled: true,
                          fillColor: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa un correo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                          labelText: 'Telefono',
                          filled: true,
                          fillColor: Colors.white),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el telefono del cliente';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                      Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Dirección Fiscal",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                          const SizedBox(
                      height: 10,
                    ),

                    CustomDropdownButtonFormField(identifier: 'selectCountry', selectedIndex: _selectedCountryIndex, dataList: _countryList, text: _countryText, onSelected: (newValue, countryTex) {
                        setState(() {
                            _selectedCountryIndex = newValue ?? 0;
                            _countryText = countryTex;
                        });
                    },),
                    
                       const SizedBox(
                      height: 10,
                    ),
                     TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la Ciudad';
                        }
                        return null;
                      },
                    ),

                     const SizedBox(
                      height: 10,
                    ),
                     TextFormField(
                      controller: _direccionController,
                      decoration: const InputDecoration(
                          labelText: 'Direccion',
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la direccion del cliente';
                        }
                        return null;
                      },
                      maxLines: 2,
                    ),
                   
                    const SizedBox(height: 10,),
                          TextFormField(
                      controller: _codePostalController,
                      decoration: const InputDecoration(
                          labelText: 'Codigo Postal',
                          filled: true,
                          fillColor: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el codigo postal de su dirección';
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
      ),
    );
  }


  void _saveProduct() async {
    // Obtén los valores del formulario
    String name = _nameController.text;
    String ruc = _rucController.text;
    String correo = _correoController.text;
    String telefono = _telefonoController.text;
    String address = _direccionController.text;
    String city = _cityController.text;
    String codePostal = _codePostalController.text;

    // Selected DropdownButtonFormField

    int selectlcoTaxPayerTypeId = _selectedTaxPayer;
    int selectlveTypePerson = _seletectedTypePerson;
    int selectGoupBp = _selectedGroupIndex;
    int selectCountryId = _selectedCountryIndex;
    int selectTaxTypeId = _selectedTaxType;

   // Text Selected
   String personTypeText = _typePersonText; 
   String payerTypeName = _taxPayerText;
   String countryTextName = _countryText;
   String taxTypeName = _taxTypeText;
   String groupBpName = _groupText;

    // Crea una instancia del producto
    Customer client = Customer(
      bpName: name,
      ruc: ruc,
      address: address,
      cBpGroupId: selectGoupBp,
      cBparnetLocationId: 0,
      lcoTaxPayerTypeId: selectlcoTaxPayerTypeId,
      lvePersonTypeId: selectlveTypePerson,
      personTypeName: personTypeText,
      taxPayerTypeName: payerTypeName,
      cCityId: 0,
      cCountryId: selectCountryId,
      cLocationId: 0,
      cRegionId: 0,
      cbPartnerId: 0,
      city: city ,
      codClient: 0,
      codePostal: codePostal ,
      country: countryTextName,
      isBillTo: 'Y',
      lcoTaxIdTypeId: selectTaxTypeId,
      region: 0,
      taxIdTypeName: taxTypeName,
      email: correo,
      phone: telefono,
      cBpGroupName: groupBpName,
    );

    // Llama a un método para guardar el producto en Sqflite
    await saveClientToDatabase(client);

    // Limpia los controladores de texto después de guardar el producto
    _nameController.clear();
    _rucController.clear();
    _correoController.clear();
    _telefonoController.clear();
    _cityController.clear();
    _codePostalController.clear();
    _direccionController.clear();

    setState(() {
       _selectedCountryIndex = 0;
      _selectedGroupIndex = 0;
      _selectedTaxType = 0;
      _selectedTaxPayer = 0;
      _seletectedTypePerson = 0;
    });


    // Muestra un mensaje de éxito o realiza cualquier otra acción necesaria
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Cliente guardado correctamente'),
    ));
  }

  Future<void> saveClientToDatabase(Customer product) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      int result = await db.insert('clients', product.toMap());

      if (result != -1) {
        print(
            'El Cliente se ha guardado correctamente en la base de datos con el id: $result');
      } else {
        print('Error al guardar el Cliente en la base de datos');
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
