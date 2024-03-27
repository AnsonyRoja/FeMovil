import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/presentation/products/utils/switch_generated_names_select.dart';
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
  final TextEditingController _grupoController = TextEditingController();

//List
 List<Map<String, dynamic>> _countryList = [];
 List<Map<String, dynamic>> _groupList = [];
 List<Map<String, dynamic>> _taxTypeList = [];
 List<Map<String, dynamic>> _taxPayerList = [];

  // SELECTED
  int _selectedCountryIndex = 0;
  int _selectedGroupIndex = 0;
  int _selectedTaxType = 0;
  int _selectedTaxPayer = 0;


// Text

String _countryText = '';
String _groupText = '';
String _taxTypeText = '';
String _taxPayerText = '';

      loadList()async {

       List<Map<String, dynamic>> getCountryGroup = await  listarCountryGroup();
        List<Map<String, dynamic>> getGroupTercero = await listarGroupTercero();
        List<Map<String, dynamic>> getTaxType = await listarTaxType();
        List<Map<String, dynamic>> getTaxPayer = await listarTaxPayer();
          print('Esta es la respuesta $getCountryGroup' ) ;
          print('Esta es la respuesta de getGroupTercero $getGroupTercero');
          print('Esto es getTaxType $getTaxType');
          print('Estos son los taxPayers $getTaxPayer');
              _countryList.add({'c_country_id': 0, 'country': 'Selecciona un País'});
              _groupList.add ({'c_bp_group_id': 0, 'group_bp_name': 'Selecciona un Grupo'});
              _taxTypeList.add({'lco_tax_id_typeid': 0, 'tax_id_type_name' : 'Selecciona un tipo de impuesto'});
              _taxPayerList.add({'lco_tax_payer_typeid': 0, 'tax_payer_type_name' : 'Selecciona un tipo de contribuyente'});
        setState(() {
          _countryList.addAll(getCountryGroup);
          _groupList.addAll(getGroupTercero);
          _taxTypeList.addAll(getTaxType);
          _taxPayerList.addAll(getTaxPayer);
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
      appBar: AppBar(title: const Text("Agregar Cliente", style: TextStyle(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                const SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Nombre del Cliente', filled: true, fillColor: Colors.white),
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
                    decoration: const InputDecoration(labelText: 'Ruc/Dni', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un Ruc/Dni Valido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                     DropdownButtonFormField<int>(
                    value: _selectedCountryIndex,
                    items: _countryList.where((country) => country['c_country_id'] is int).map<DropdownMenuItem<int>>((country) {
                      print('tax $country');
                      return DropdownMenuItem<int>(
                        value: country['c_country_id'] as int,
                        child: Text(country['country'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      print('esto es el taxList $_countryList');
                    String nameCountry = invoke('obtenerNombreCountry', newValue, _countryList);
                    print("esto es el nombre de impuesto $nameCountry");
                      setState(() {
                        _countryText = nameCountry;
                        _selectedCountryIndex = newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un Pais';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                   DropdownButtonFormField<int>(
                    value: _selectedGroupIndex,
                    items: _groupList.where((groupList) => groupList['c_bp_group_id'] is int).map<DropdownMenuItem<int>>((group) {
                      print('tax $group');
                      return DropdownMenuItem<int>(
                        value: group['c_bp_group_id'] as int,
                        child: Text(group['group_bp_name'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      print('esto es el taxList $_groupList');
                    String nameGroup = invoke('obtenerNombreGroup', newValue, _groupList);
                    print("esto es el nombre de impuesto $nameGroup");
                      setState(() {
                        _groupText = nameGroup;
                        _selectedGroupIndex= newValue as int;
                      });
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
                  ),
                    const SizedBox(height: 10,),

                     DropdownButtonFormField<int>(
                    value: _selectedTaxType,
                    items: _taxTypeList.where((taxType) => taxType['lco_tax_id_typeid'] is int).map<DropdownMenuItem<int>>((taxType) {
                      print('tax $taxType');
                      return DropdownMenuItem<int>(
                        value: taxType['lco_tax_id_typeid'] as int,
                        child: SizedBox(
                          width: 200,
                          child: Text(taxType['tax_id_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      print('esto es el taxList $_taxTypeList');
                    String nameTax = invoke('obtenerNombreTax', newValue, _taxTypeList);
                    print("esto es el nombre del tipo de impuesto $nameTax");
                      setState(() {
                        _taxTypeText = nameTax;
                        _selectedTaxType= newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un tipo de impuesto';
                      }
                      return null;
                    },
                  ),
                    const SizedBox(height: 10,),

                     DropdownButtonFormField<int>(
                    value: _selectedTaxPayer,
                     items: _taxPayerList.where((taxPayer) => taxPayer['lco_tax_payer_typeid'] is int).map<DropdownMenuItem<int>>((taxPayer) {
                    
                      return DropdownMenuItem<int>(
                        value: taxPayer['lco_tax_payer_typeid'] ,
                        child: SizedBox(
                          width: 200,
                          child: Text(taxPayer['tax_payer_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      print('esto es el taxList $_taxPayerList');
                    String nameTaxPayer = invoke('obtenerNombreTaxPayer', newValue, _taxPayerList);
                    print("esto es el nombre del tipo de constribuyente $nameTaxPayer");
                      setState(() {
                        _taxPayerText = nameTaxPayer;
                        _selectedTaxPayer = newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un tipo de impuesto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(labelText: 'Correo', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
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
                        return 'Por favor ingresa el telefono del cliente';
                      }
                      return null;
                    },
                  ),
                   const SizedBox(height: 10,),
                
           
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
    String name = _nameController.text;
    String ruc = _rucController.text;
    String correo = _correoController.text;
    String telefono = _telefonoController.text;
    String grupo = _grupoController.text;

    // Crea una instancia del producto
    Customer client = Customer(
        bpName: name,
        ruc:ruc,
        address: "direccion",
        cBpGroupId: 1,
        cBparnetLocationId: 1,
        lcoTaxPayerTypeId: 24,
        lvePersonTypeId: 12,
        personTypeName: 'Qqew',
        taxPayerTypeName: 'qweqw',
        cCityId: '1',
        cCountryId: '1',
        cLocationId: 1,
        cRegionId: '1',
        cbPartnerId: 2,
        city: 'Araure',
        codClient: 1540,
        codePostal: '23546',
        country: 'Venezuela',
        isBillTo: 'Y',
        lcoTaxIdTypeId: 1,
        region: 'No aplica',
        taxIdTypeName: 'Cedula',
        email: correo,
        phone: telefono,
        cBpGroupName: grupo,
    );

    // Llama a un método para guardar el producto en Sqflite
    await saveClientToDatabase(client);

    // Limpia los controladores de texto después de guardar el producto
    _nameController.clear();
    _rucController.clear();
    _correoController .clear();
    _telefonoController.clear();
    _grupoController.clear();

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
        print('El Cliente se ha guardado correctamente en la base de datos con el id: $result');
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
    _grupoController.dispose();

    super.dispose();
  }
}









































