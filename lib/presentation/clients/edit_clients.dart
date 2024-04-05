import 'package:femovil/database/list_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/presentation/clients/select_customer.dart';
import 'package:flutter/material.dart';

class EditClientScreen extends StatefulWidget {
  final Map<String, dynamic> client;

  const EditClientScreen({super.key, required this.client});

  @override
  _EditClientScreenState createState() => _EditClientScreenState();
}

class _EditClientScreenState extends State<EditClientScreen> {
  final _nameController = TextEditingController();
  final _rucController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _cityController = TextEditingController();
  final _codePostalController = TextEditingController();

  //List
  List<Map<String, dynamic>> _countryList = [];
  List<Map<String, dynamic>> _groupList = [];
  List<Map<String, dynamic>> _taxTypeList = [];
  List<Map<String, dynamic>> _taxPayerList = [];
  List<Map<String, dynamic>> _typePersonList = [];

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
    super.initState();
    // Initialize controllers with existing product details
    print("this client ${widget.client}");
    
    loadList();
    _selectedCountryIndex = widget.client['c_country_id'];
    _countryText = widget.client['country'];
    _seletectedTypePerson = widget.client['lve_person_type_id'];
    _typePersonText = widget.client['person_type_name'].toString();
    _selectedTaxPayer = widget.client['lco_tax_payer_typeid'];
    _taxPayerText = widget.client['tax_payer_type_name'].toString();
    _selectedGroupIndex = widget.client['c_bp_group_id'];
    _groupText = widget.client['group_bp_name'].toString();
    _selectedTaxType = widget.client['lco_tax_id_typeid'];
    _taxTypeText = widget.client['tax_id_type_name'].toString();
    _nameController.text = widget.client['bp_name'].toString();
    _rucController.text = widget.client['ruc'].toString();
    _correoController.text = widget.client['email'].toString() == '{@nil: true}' ? 'Sin registro' : widget.client['email'].toString();
    _telefonoController.text = widget.client['phone'].toString() == '{@nil: true}' ? 'Sin registro' : widget.client['phone'].toString();
    _direccionController.text = widget.client['address'].toString();
    _cityController.text = widget.client['city'].toString();
    _codePostalController.text = widget.client['code_postal'].toString();
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
            "Editar Cliente",
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
                  Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Datos Personales",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10,),
                  _buildTextFormField('Nombre', _nameController,1),
                  _buildTextFormField('Ruc', _rucController, 1),
                  _buildTextFormField('Correo', _correoController, 1),
                  _buildTextFormField('Telefono', _telefonoController, 1),
                  CustomDropdownButtonFormField(
                    identifier: 'groupBp',
                    selectedIndex: _selectedGroupIndex,
                    dataList: _groupList,
                    text: _groupText,
                    onSelected: (newValue, groupText) {
                      setState(() {
                        _selectedGroupIndex = newValue ?? 0;
                        _groupText = groupText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomDropdownButtonFormField(
                    identifier: 'taxType',
                    selectedIndex: _selectedTaxType,
                    dataList: _taxTypeList,
                    text: _taxTypeText,
                    onSelected: (newValue, taxTypeText) {
                      setState(() {
                        _selectedTaxType = newValue ?? 0;
                        _taxTypeText = taxTypeText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomDropdownButtonFormField(
                    identifier: 'taxPayer',
                    selectedIndex: _selectedTaxPayer,
                    dataList: _taxPayerList,
                    text: _taxPayerText,
                    onSelected: (newValue, taxPayerText) {
                      setState(() {
                        _selectedTaxPayer = newValue ?? 0;
                        _taxPayerText = taxPayerText;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomDropdownButtonFormField(
                    identifier: 'typePerson',
                    selectedIndex: _seletectedTypePerson,
                    dataList: _typePersonList,
                    text: _typePersonText,
                    onSelected: (newValue, tyPersonText) {
                      setState(() {
                        _seletectedTypePerson = newValue ?? 0;
                        _typePersonText = tyPersonText;
                      });
                    },
                  ),
                  const SizedBox(height: 10,),
                     Container(
                      width: 300,
                      color: Colors.blue,
                      child: const Text(
                        "Domicilio Fiscal",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CustomDropdownButtonFormField(identifier: 'selectCountry', selectedIndex: _selectedCountryIndex, dataList: _countryList, text: _countryText, onSelected: (newValue, countryTex) {
                        setState(() {
                          _selectedCountryIndex = newValue ?? 0;
                          _countryText = countryTex;
                        });
                    },),
                  const SizedBox(height: 10,),
                _buildTextFormField('Dirección', _direccionController, 2),
                _buildTextFormField('Ciudad', _cityController, 1),
                _buildTextFormField('Codigo Postal', _codePostalController, 1),


                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String newName = _nameController.text;
            dynamic newRuc = _rucController.text;
            String newCorreo = _correoController.text;
            dynamic newTelefono = _telefonoController.text;
            String newGrupo = _groupText;
            String taxType = _taxTypeText;
            String taxPayer = _taxPayerText;
            String personType = _typePersonText;
            String newDireccion = _direccionController.text;
            String newCity = _cityController.text;

            // selected

            int selectedGroupId = _selectedGroupIndex;
            int selectedTaxId = _selectedTaxType;
            int selectedTaxPayerId = _selectedTaxPayer;
            int selectedPersonType = _seletectedTypePerson;
            // Crear un mapa con los datos actualizados del producto
            Map<String, dynamic> updatedClient = {
              'id': widget
                  .client['id'], // Asegúrate de incluir el ID del producto
              'bp_name': newName,
              'ruc': newRuc,
              'email': newCorreo,
              'phone': newTelefono,
              'c_bp_group_id': selectedGroupId,
              'group_bp_name': newGrupo,
              'lco_tax_id_typeid': selectedTaxId,
              'tax_id_type_name': taxType,
              'lco_tax_payer_typeid': selectedTaxPayerId,
              'tax_payer_type_name': taxPayer,
              'lve_person_type_id': selectedPersonType,
              'person_type_name': personType,
              'address': newDireccion,
              'city':newCity,
            };

            // Actualizar el producto en la base de datos
            await updateClient(updatedClient);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cliente actualizado satisfactoriamente'),
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

  Widget _buildTextFormField(String label, TextEditingController controller, int maxLin) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
        maxLines: maxLin ,
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
