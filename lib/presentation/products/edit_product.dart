import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:femovil/presentation/clients/select_customer.dart';
import 'package:femovil/presentation/products/utils/switch_generated_names_select.dart';
import 'package:femovil/sincronization/sincronizar.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const EditProductScreen({super.key, required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  final _maxStockController = TextEditingController();

 final List<Map<String, dynamic>> _taxList = []; // Lista para almacenar los impuestos disponibles
 final List<Map<String, dynamic>> _categoriesList = [];
 final List<Map<String, dynamic>> _umList = [];
 final List<Map<String, dynamic>> _productTypeList = [];
 final List<Map<String, dynamic>> _productGroupList = [];

  int _selectedTaxIndex = 0; // Índice del impuesto seleccionado por defecto
  int _selectedCategoriesIndex = 0;
  int _selectedProductGroupIndex = 0;
  int _selectedUmIndex = 0;
  String _selectedProductType = 'first';
  
  
  String _prodTypeText = '';
  String _prodGroupText = '';
  String _prodCatText = '';
  String _taxText = '';
  String _umText = '';


  void _loadTaxs()async {

       
        final getTaxs = await listarImpuestos();
        final getCategories = await listarCategorias();
        final getUm = await  listarUnidadesDeMedida();
        final getProductGroup = await listarProductGroup();
        final getProductType = await listarProductType();

        // print('Esto es getProductGroup $getProductGroup');
        // print('Esto es getProductType $getProductType');
        // print("Esto es getTaxs $getTaxs");
        // print('Esto es getCategories $getCategories');
        // print('Estas son las unidades de medidas $getUm');



      _taxList.add({'tax_cat_id': 0, 'tax_cat_name': 'Selecciona un impuesto'});
      _categoriesList.add({'pro_cat_id': 0, 'categoria': 'Selecciona una categoria'});
      _umList.add({'um_id': 0, 'um_name': 'Unidad de medida'});
      _productTypeList.add({'product_type': 'first', 'product_type_name': 'Seleccione un tipo de producto'});
      _productGroupList.add({'product_group_id': 0, 'product_group_name': 'Seleccione un grupo de producto'});


        setState(() {
        _taxList.addAll(getTaxs);
        _categoriesList.addAll(getCategories);
        _umList.addAll(getUm);
        _productTypeList.addAll(getProductType);
        _productGroupList.addAll(getProductGroup);

        });
        print("esto es taxlist $_taxList");
      }






  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product details
    _nameController.text = widget.product['name'].toString();
    _selectedTaxIndex = widget.product['tax_cat_id'];
    _selectedCategoriesIndex = widget.product['pro_cat_id'];
    _selectedUmIndex = widget.product['um_id'];
    _selectedProductType = widget.product['product_type'] == '{@nil: true}' ? 0 : widget.product['product_type'];
    _selectedProductGroupIndex = widget.product['product_group_id'] == '{@nil: true}' ? 0 : widget.product['product_group_id']  ;
    _taxText = widget.product['tax_cat_name'];
    _prodGroupText = widget.product['product_group_name'];
    _prodCatText = widget.product['categoria'];
    _umText = widget.product['um_name'];
    _prodTypeText = widget.product['product_type_name'];
    _priceController.text = '0';
    _quantityController.text = '0';
    
     _loadTaxs();

     print('Estos son los productos ${widget.product}');


  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final double mediaScreen = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () {

       FocusScope.of(context).requestFocus(FocusNode());

      },
      child: Scaffold(
        appBar: const PreferredSize( 
          preferredSize: Size.fromHeight(170) ,
          child: AppBars(labelText: 'Editar Producto',) ,
          ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),
                  _buildTextFormField('Nombre', _nameController, mediaScreen),


                     Container(
                      width: mediaScreen,
                      height: mediaScreen * 0.15,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 7, 
                          spreadRadius: 2 
                          )
                      ]
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedTaxIndex,
                      items: _taxList.where((tax) => tax['tax_cat_id'] is int && tax['tax_cat_name'] != '').map<DropdownMenuItem<int>>((tax) {
                        return DropdownMenuItem<int>(
                          value: tax['tax_cat_id'] as int,
                          child: Text(tax['tax_cat_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        String nameTax = invoke('obtenerNombreImpuesto', newValue, _taxList);
                        setState(() {
                          _taxText = nameTax;
                          _selectedTaxIndex = newValue as int;
                        });
                      },
                      decoration:  InputDecoration(
                        labelText: 'Impuesto',
                        border: InputBorder.none, // No necesitas un borde adicional aquí ya que está definido en el Container
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                        enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white, width: 15),
                        ),
                         focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0), // Maintain border radius on focus
                          borderSide:  const BorderSide(color: Colors.white, width: 15.0), // Change border color and thickness on focus (optional)
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'Por favor selecciona un impuesto';
                        }
                        return null;
                      },
                    ),

                  ),

                  const SizedBox(height: 5,),
                    Container(
                      width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      border: Border.all(color: Colors.grey), // Color del borde
                      color: const Color.fromARGB(255, 236, 247, 255), // Color de fondo
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedCategoriesIndex,
                      items: _categoriesList.where((categories) => categories['pro_cat_id'] is int && categories['categoria'] != '' ).map<DropdownMenuItem<int>>((categories) {
                        return DropdownMenuItem<int>(
                          value: categories['pro_cat_id'] as int,
                          child: Text(categories['categoria'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {

                        String nameCat = invoke('obtenerNombreCat', newValue, _categoriesList);

                        setState(() {
                          _prodCatText = nameCat;
                          _selectedCategoriesIndex = newValue as int;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: InputBorder.none, // No necesitas un borde adicional aquí ya que está definido en el Container
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'Por favor selecciona un impuesto';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5,),
                    Container(
                      width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      border: Border.all(color: Colors.grey), // Color del borde
                      color: const Color.fromARGB(255, 236, 247, 255), // Color de fondo
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedProductType,
                      items: _productTypeList.where((productType) => productType['product_type'] is String && productType['product_type_name'] != "" ).map<DropdownMenuItem<String>>((productType) {
                        return DropdownMenuItem<String>(
                          value: productType['product_type'] as String,
                          child: Text(productType['product_type_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {

                        String nameProductType = invoke('obtenerNombreProductType', newValue, _productTypeList);
                       
                        setState(() {
                          _prodTypeText = nameProductType;
                          _selectedProductType = newValue as String;
                        });

                      },
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Producto',
                        border: InputBorder.none, // No necesitas un borde adicional aquí ya que está definido en el Container
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value == 'first') {
                          return 'Por favor selecciona un tipo de producto';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 5,),
                   Container(
                      width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      border: Border.all(color: Colors.grey), // Color del borde
                      color: const Color.fromARGB(255, 236, 247, 255), // Color de fondo
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedProductGroupIndex,
                      items: _productGroupList.where((productGroup) => productGroup['product_group_id'] is int && productGroup['product_group_name'] != '').map<DropdownMenuItem<int>>((productGroup) {
                        return DropdownMenuItem<int>(
                          value: productGroup['product_group_id'] as int,
                          child: Text(productGroup['product_group_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {

                        
                        String nameProductGroup = invoke('obtenerNombreProductGroup', newValue, _productGroupList);
                        setState(() {
                          _prodGroupText = nameProductGroup;
                          _selectedProductGroupIndex = newValue as int;
                        });

                      },
                      decoration: const InputDecoration(
                        labelText: 'Grupo del Producto',
                        border: InputBorder.none, // No necesitas un borde adicional aquí ya que está definido en el Container
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Por favor selecciona el grupo al que pertenece';
                        }
                        return null;
                      },
                    ),
                  ),

                    const SizedBox(height: 5,),
                    Container(
                      width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      border: Border.all(color: Colors.grey), // Color del borde
                      color: const Color.fromARGB(255, 236, 247, 255), // Color de fondo
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedUmIndex,
                      items: _umList.where((um) => um['um_id'] is int && um['um_name'] != "").map<DropdownMenuItem<int>>((um) {
                        return DropdownMenuItem<int>(
                          value: um['um_id'] as int,
                          child: Text(um['um_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                    
                        String nameUm = invoke('obtenerNombreUm', newValue, _umList);

                        setState(() {
                          _umText = nameUm;
                          _selectedUmIndex= newValue as int;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Unidad de Medida',
                        border: InputBorder.none, // No necesitas un borde adicional aquí ya que está definido en el Container
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      ),
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'Por favor selecciona un impuesto';
                        }
                        return null;
                      },
                    ),
                  ),


               
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            String newName = _nameController.text;
            double newPrice = double.parse(_priceController.text);
            int newQuantity = int.parse(_quantityController.text);
            int taxIndex = _selectedTaxIndex;
            String taxString = _taxText;
            int prodCat = _selectedCategoriesIndex;
            String catProd = _prodCatText;
            int umId = _selectedUmIndex;
            String umName = _umText;

            // Validar que se haya seleccionado un impuesto
            if (taxIndex == 0 || taxString.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor selecciona un impuesto'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
              return; // Salir de la función sin guardar si no se ha seleccionado un impuesto
            }

            // Validar que se haya seleccionado una categoría
            if (prodCat == 0 || catProd.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor selecciona una categoría'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
              return; // Salir de la función sin guardar si no se ha seleccionado una categoría
            }

            // Validar que se haya seleccionado una unidad de medida
            if (umId == 0 || umName.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor selecciona una unidad de medida'),
                  duration: Duration(seconds: 2),
                  backgroundColor: Colors.red,
                ),
              );
              return; // Salir de la función sin guardar si no se ha seleccionado una unidad de medida
            }

            // Crear un mapa con los datos actualizados del producto
            Map<String, dynamic> updatedProduct = {
              'id': widget.product['id'], // Asegúrate de incluir el ID del producto
              'name': newName,
              'categoria': catProd,
              'price': newPrice,
              'quantity': newQuantity,
              'tax_cat_id': taxIndex,
              'tax_cat_name': taxString,
              'pro_cat_id': prodCat,
              'um_id': umId,
              'um_name': umName,
            };

            // Actualizar el producto en la base de datos
            await updateProduct(updatedProduct);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Producto actualizado satisfactoriamente'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.green,
              ),
            );

            // Cerrar la pantalla de edición después de actualizar el producto
            Navigator.pop(context);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.save),
        ),

      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, double mediaScreen) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: mediaScreen,
        decoration: BoxDecoration(
          color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 7, spreadRadius: 2)
            ]

        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(fontFamily: 'Poppins Regular', ) ,
            border:  OutlineInputBorder( borderRadius: BorderRadius.circular(10) , borderSide: const BorderSide(width: 2) ),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white , width: 15 )),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(width: 15, color: Colors.white)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
           
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }
}
