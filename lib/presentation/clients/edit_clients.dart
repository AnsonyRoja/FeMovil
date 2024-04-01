import 'package:femovil/database/create_database.dart';
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
  final  _direccionController = TextEditingController();
  final  _cityController = TextEditingController(); 
  final  _codePostalController = TextEditingController();
 
 //List
  List<Map<String, dynamic>> _countryList = [];
  List<Map<String, dynamic>> _groupList = [];
  List<Map<String, dynamic>> _taxTypeList = [];
  List<Map<String, dynamic>> _taxPayerList = [];
  List<Map<String, dynamic>> _typePersonList =[];

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
    loadList();
    _selectedGroupIndex = widget.client['c_bp_group_id'];
    _selectedTaxType = widget.client['lco_tax_id_typeid'];
    _nameController.text = widget.client['bp_name'].toString();
    _rucController.text = widget.client['ruc'].toString();
    _correoController.text = widget.client['email'].toString();
    _telefonoController.text = widget.client['phone'].toString();

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
          iconTheme: const IconThemeData(color: Color.fromARGB(255, 105, 102, 102)),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 247, 255),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  _buildTextFormField('Nombre', _nameController),
                  _buildTextFormField('Ruc', _rucController),
                  _buildTextFormField('Correo', _correoController),
                  _buildTextFormField('Telefono', _telefonoController),
                  CustomDropdownButtonFormField(identifier: 'groupBp', selectedIndex: _selectedGroupIndex, dataList: _groupList, text: _groupText, onSelected: (newValue, groupText) {
                      setState(() {
                        _selectedGroupIndex = newValue ?? 0;
                        _groupText = groupText;
                      });
                  },),
                  const SizedBox(height: 10,),
                  CustomDropdownButtonFormField(identifier: 'taxType', selectedIndex: _selectedTaxType, dataList: _taxTypeList, text: _taxTypeText, onSelected: (newValue, taxTypeText) {

                      setState(() {
                        _selectedTaxType = newValue ?? 0;
                        _taxTypeText = taxTypeText;
                      });

                  },)

              
                ],

              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async{
          String newName = _nameController.text;
          dynamic newRuc = _rucController.text;
          String newCorreo = _correoController.text;
          dynamic newTelefono = _telefonoController.text;
          String newGrupo = _groupText;
          String taxType = _taxTypeText;

          // selected 

          int selectedGroupId = _selectedGroupIndex;
          int selectedTaxId = _selectedTaxType;
    // Crear un mapa con los datos actualizados del producto
    Map<String, dynamic> updatedClient = {
      'id': widget.client['id'], // Asegúrate de incluir el ID del producto
      'bp_name': newName,
      'ruc': newRuc,
      'email': newCorreo,
      'phone': newTelefono,
      'c_bp_group_id': selectedGroupId,
      'group_bp_name': newGrupo,
      'lco_tax_id_typeid' : selectedTaxId,
      'tax_id_type_name': taxType,
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

  Widget _buildTextFormField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        ),
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
