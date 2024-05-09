import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/config/app_bar_sampler.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/presentation/clients/helpers/save_client_to_database.dart';
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
    final mediaScreen = MediaQuery.of(context).size.width * 0.8;
    final colorTheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(50),
          child:  AppBarSample(label: 'Agregar Cliente')),
        body: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: mediaScreen,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
                    SizedBox(
                      width: mediaScreen,
                      
                      child: const Text(
                        "Datos Personales",
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black, fontFamily: 'Poppins Bold', fontSize:  18),
                        
                      ),
                    ),
                    const SizedBox(height: 15),
                                      Container(
                            height: mediaScreen * 0.20,
                            width: mediaScreen * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Nombre Completo',
                                labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:  const BorderSide(color:Colors.white, width: 25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:  const BorderSide(color:Colors.white, width: 25),
                                ),
                                errorBorder: OutlineInputBorder(

                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor ingresa el nombre del Cliente';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                            ),
                          ),

                    const SizedBox(height: 10),
                    Container(
                      height: mediaScreen * 0.20,
                      width: mediaScreen * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            spreadRadius: 2
                          )
                        ]
                      ),
                      child: TextFormField(
                        controller: _rucController,
                        decoration:  InputDecoration(
                          errorStyle: const TextStyle(fontFamily: 'Poppins Regular'),
                            labelText: 'RUC/DNI',
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                             border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:  const BorderSide(color:Colors.white, width: 25),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide:  const BorderSide(color:Colors.white, width: 25),
                                ),
                                errorBorder: OutlineInputBorder(

                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(color: Colors.red, width: 1),
                                ),
                            ),
                        keyboardType: TextInputType.number,
                        
                        validator: (value) {
                          
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa un RUC/DNI Valido';
                          }
                          return null;
                        },
                      ),
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
                    // const SizedBox(height: 10,),
                    // CustomDropdownButtonFormField(identifier: 'typePerson', selectedIndex: _seletectedTypePerson, dataList: _typePersonList, text: _typePersonText, onSelected: (newValue, tyPersonText) {
                    //     setState(() {
                    //       _seletectedTypePerson = newValue ?? 0;
                    //       _typePersonText = tyPersonText;

                    //     });

                    // },),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: mediaScreen * 0.20,
                      width: mediaScreen * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15) ,
                        boxShadow:  [
                           BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            spreadRadius: 2
                          )
                        ]
                      ),
                      child: TextFormField(
                      
                        controller: _correoController,
                        decoration:  InputDecoration(
                          errorStyle: const TextStyle(fontFamily: 'Poppins Regular') ,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              width: 1, color: Colors.red
                            )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10) ,
                              borderSide: const BorderSide(
                                color: Colors.red ,
                                width: 1,
                              ) 
                          ) ,
                            contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none ,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 25 ,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 25 ,),
                              
                            ) ,
                            labelText: 'Correo',
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular',color: Colors.black) ,
                            filled: true,
                            fillColor: Colors.white),
                        keyboardType: TextInputType.text,
                        validator: (value) {


                          if (value!.isEmpty ) {
                            return 'Por favor ingresa un correo';
                          }else if(!value.contains('@')){
                            return 'Por favor ingresa un correo electronico valido';

                            }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: mediaScreen * 0.20,
                      width: mediaScreen * 0.95,
                      decoration: BoxDecoration(
                        color: Colors.white,
                         borderRadius: BorderRadius.circular(15),
                         boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 7,
                            spreadRadius: 2
                          )
                         ]
                      ) ,

                      child: TextFormField(
                        controller: _telefonoController,
                        decoration:  InputDecoration(
                          errorStyle: const TextStyle(fontFamily: 'Poppins Regular'),
                           errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              width: 1, color: Colors.red
                            )
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10) ,
                              borderSide: const BorderSide(
                                color: Colors.red ,
                                width: 1,
                              ) 
                          ) ,
                              border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none ,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 25 ,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),

                              borderSide: const BorderSide(
                                color: Colors.white,
                                width: 25 ,),),

                            contentPadding:  const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            labelText: 'Telefono',
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
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
                    ),
                    
                    const SizedBox(
                      height: 10,
                    ),
                      SizedBox(
                      width: mediaScreen, 
                      child: const Text(
                        "Dirección Fiscal",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontFamily: 'Poppins Bold',color: Colors.black, fontSize: 18),
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
                     Container(
                        height: mediaScreen * 0.20,
                        width: mediaScreen * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 7,
                              spreadRadius: 2,
                              color: Colors.grey.withOpacity(0.5)
                              
                            )
                          ]
                        ),
                        child: TextFormField(
                        controller: _cityController,
                        decoration:  InputDecoration(
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red, width: 1.0)
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            )
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(width: 25, color:Colors.white)
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none
                          ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(width: 25, color: Colors.white),
                            ),
                            labelText: 'Ciudad',
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black) ,
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la Ciudad';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                       
                                           ),
                     ),

                     const SizedBox(
                      height: 10,
                    ),
                     Container(
                        height: mediaScreen * 0.30,
                        width: mediaScreen * 0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                           borderRadius: BorderRadius.circular(15),
                           boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7, 
                              spreadRadius: 2,
                            )
                           ]
                        ) ,
                       child: TextFormField(
                        controller: _direccionController,
                        decoration:  InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(width: 25, color: Colors.white)
                          ),
                          border: OutlineInputBorder(
                            borderRadius:  BorderRadius.circular(15) ,
                            borderSide: BorderSide.none
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 25,
                             )
                          ) ,
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red, width: 1.0)
                          ) ,
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), 
                              borderSide: const BorderSide(width: 1.0, color: Colors.red )
                          ) ,
                            labelText: 'Direccion',
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black , ),
                            filled: true,
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa la direccion del cliente';
                          }
                          return null;
                        },
                        maxLines: 2,
                                           keyboardType: TextInputType.text,
                       
                                           ),
                     ),
                   
                    const SizedBox(height: 10,),
                          Container(
                            height: mediaScreen * 0.20,
                            width: mediaScreen * 0.95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 7,
                                  spreadRadius: 2
                                )
                              ]
                            ),
                            child: TextFormField(
                            controller: _codePostalController,
                            decoration:  InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15), 
                              borderSide: const BorderSide(
                                width: 25, 
                                color: Colors.white
                              )
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                width: 25, 
                                color: Colors.white
                              )
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.red, width: 1)
                            ) ,
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1
                              )
                            ),
                            labelText: 'Codigo Postal',
                            errorStyle: const TextStyle(fontFamily: 'Poppins Regular',),
                            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', color: Colors.black),
                            filled: true,
                            fillColor: Colors.white),
                            validator: (value) {
                            if (value == null || value.isEmpty) {
                            return 'Por favor ingresa el codigo postal de su dirección';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
        
                                                ),
                          ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                        width: mediaScreen * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 7,
                              spreadRadius: 2
                            )
                          ]
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Guarda el producto en la base de datos Sqflite
                              _saveProduct();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorTheme.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text('Crear', style: TextStyle(fontFamily: 'Poppins SemiBold'),),
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
