
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/list_database.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:femovil/presentation/products/utils/switch_generated_names_select.dart';
import 'package:flutter/material.dart';






class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();

}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _prodCatText = '';
  String _taxText = '';
  String _umText = '';
  String _productTypeText = '';
  String _productGroupText = '';
  late BuildContext _context;


  final TextEditingController _nameController = TextEditingController();
   TextEditingController _quantityController = TextEditingController();
   TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtySoldController = TextEditingController();
 
 List<Map<String, dynamic>> _taxList = []; // Lista para almacenar los impuestos disponibles
 List<Map<String, dynamic>> _categoriesList = [];
 List<Map<String, dynamic>> _umList = [];
 List<Map<String, dynamic>> _productTpeList =[];
 List<Map<String, dynamic>> _productGroupList = [];
  int _selectedTaxIndex = 0; // Índice del impuesto seleccionado por defecto
  int _selectedCategoriesIndex = 0;
  int _selectedUmIndex = 0;
  int _seletedProductGroup = 0;
  String _selectedProductType = 'first';

     void _loadTaxs()async {

   
        final getTaxs = await listarImpuestos();
        final getCategories = await listarCategorias();
        final getUm = await  listarUnidadesDeMedida();
        final getProductType = await listarProductType();
        final getProductGroup = await listarProductGroup();

        print("Esto es getTaxs $getTaxs");
        print('Esto es getCategories $getCategories');
        print('Estas son las unidades de medidas $getUm');
        print('Esto es la lista de los tipos de productos $getProductType');
        print('Esto es la lista de product group $getProductGroup');


      print("esto es categoriesList con la nueva opcion 0 $_taxList");
      _taxList.add({'tax_cat_id': 0, 'tax_cat_name': 'Selecciona un impuesto'});
      _categoriesList.add({'pro_cat_id': 0, 'categoria': 'Selecciona una categoria'});
      _umList.add({'um_id': 0, 'um_name': 'Seleccione la unidad de medida'});
      _productTpeList.add({'product_type': 'first', 'product_type_name': 'Selecciona un tipo de producto'});
      _productGroupList.add({'product_group_id': 0, 'product_group_name': 'Selecciona un grupo de productos'});

        setState(() {
        _taxList.addAll(getTaxs);
        _categoriesList.addAll(getCategories);
        _umList.addAll(getUm);
        _productTpeList.addAll(getProductType);
        _productGroupList.addAll(getProductGroup);

        });

        print("esto es taxlist $_taxList");
      
      }


  @override
  void initState()  {
    _loadTaxs();
    setState(() {
      _priceController.text = '0';
      _quantityController.text = '0';

    });

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
        _context = context; 

    return Scaffold(

      backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      appBar: AppBar(title: const Text("Agregar Producto", style: TextStyle(
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
                    decoration: const InputDecoration(labelText: 'Nombre del producto', filled: true, fillColor: Colors.white),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre del producto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  // TextFormField(
                  //   readOnly: true,
                  //   controller: _quantityController,
                  //   decoration: const InputDecoration(labelText: 'Cantidad disponible', filled: true, fillColor: Colors.white),
                  //   keyboardType: TextInputType.number,
                  //    validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Por favor ingresa la cantidad disponible del producto';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 10,),
                  DropdownButtonFormField<int>(
                    value: _selectedTaxIndex,
                    items: _taxList.where((tax) => tax['tax_cat_id'] is int).map<DropdownMenuItem<int>>((tax) {
                      print('tax $tax');
                      return DropdownMenuItem<int>(
                        value: tax['tax_cat_id'] as int,
                        child: Text(tax['tax_cat_name'] as String),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      print('esto es el taxList $_taxList');
                    String nameTax = invoke('obtenerNombreImpuesto', newValue, _taxList);
                    print("esto es el nombre de impuesto $nameTax");
                      setState(() {
                        _taxText = nameTax;
                        _selectedTaxIndex = newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un impuesto';
                      }
                      return null;
                    },
                  ),
                    const SizedBox(height: 10,),
                    DropdownButtonFormField<String>(
                    value: _selectedProductType,
                    items: _productTpeList.where((prodType) => prodType['product_type'] != '{@nil=true}').map<DropdownMenuItem<String>>((productType) {
                      return DropdownMenuItem<String>(
                        value: productType['product_type'] as String,
                        child: Container(
                          width: 200,
                          child: Text(productType['product_type_name'] as String)),
                      );
                    }).toList(),
                    onChanged: (newValue) {


                String nameProductType = invoke('obtenerNombreProductType', newValue, _productTpeList);
                      setState(() {
                        _productTypeText = nameProductType;
                        _selectedProductType = newValue as String;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona un tipo de producto';
                      }
                      return null;
                    },
                  ),
                    const SizedBox(height:10,),
                   DropdownButtonFormField<int>(
                    value: _selectedCategoriesIndex,
                    items: _categoriesList.where((cat) => cat['pro_cat_id'] is int).map<DropdownMenuItem<int>>((categories) {
                      return DropdownMenuItem<int>(
                        value: categories['pro_cat_id'] as int,
                        child: SizedBox(
                            width: 200,
                          child: Text(categories['categoria'] as String, style: const TextStyle(overflow: TextOverflow.clip),)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                        String nombreCategoria = invoke('obtenerNombreCat', newValue, _categoriesList);
                      setState(() {
                        _prodCatText = nombreCategoria;
                        _selectedCategoriesIndex = newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor selecciona una categoria';
                      }
                      return null;
                    },
                  ),
                    const SizedBox(height: 10,),
                        DropdownButtonFormField<int>(
                    value: _seletedProductGroup,
                    items: _productGroupList.where((group) => group['product_group_id'] is int ).map<DropdownMenuItem<int>>((productGroup) {
                      return DropdownMenuItem<int>(
                        value: productGroup['product_group_id'] as int,
                        child: SizedBox(
                            width: 200,
                          child: Text(productGroup['product_group_name'] as String, style: const TextStyle(overflow: TextOverflow.clip),)),
                      );
                    }).toList(),
                    onChanged: (newValue) {
            

                    String nombreProductGroup = invoke('obtenerNombreProductGroup', newValue, _productGroupList);
                      
                      setState(() {
                        _productGroupText= nombreProductGroup;
                        _seletedProductGroup= newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null || value == 0) {
                        return 'Por favor seleccionar el grupo del producto';
                      }
                      return null;
                    },
                  ),
                    const SizedBox(height: 10,),
                   DropdownButtonFormField<int>(
                    value: _selectedUmIndex,
                    items: _umList.where((um) => um['um_id'] is int).map<DropdownMenuItem<int>>((um) {
                      print('Um $um');
                      return DropdownMenuItem<int>(
                        value: um['um_id'] as int,
                        child: SizedBox(
                            width: 200,
                          child: Text(um['um_name'] as String, style: const TextStyle(overflow: TextOverflow.clip),)),
                      );
                    }).toList(),
                    onChanged: (newValue) {

                      String umName = invoke('obtenerNombreUm', newValue, _umList);

                      setState(() {
                        _umText = umName;
                        _selectedUmIndex = newValue as int;
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Por favor selecciona un impuesto';
                      }
                      return null;
                    },
                  ),
     
                  const SizedBox(height: 10,),
                  // TextFormField(
                  //   readOnly: true,
                  //   controller: _priceController,
                  //   decoration: const InputDecoration(labelText: 'Precio del producto', filled: true, fillColor: Colors.white),
                  //   keyboardType: TextInputType.number,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Por favor ingresa el precio del producto';
                  //     }
                  //     return null;
                  //   },
                  // ),
  
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

  void _saveProduct()  {
    // Obtén los valores del formulario
    String name = _nameController.text;
    double price = double.parse(_priceController.text);
    int quantity = int.parse(_quantityController.text);
    int selectTax = _selectedTaxIndex;
    int prodCatId = _selectedCategoriesIndex;
    int umId = _selectedUmIndex;
    String productTypeId = _selectedProductType;
    int prodructGroupId = _seletedProductGroup;
    int codProd = 0;

    int qtySold = 0;

    String categoria = _prodCatText;
    String taxName = _taxText;
    String productGroupName = _productGroupText;
    String uM= _umText;
    String ptype = _productTypeText;


      // Crea una instancia del producto
      Product product = Product(
        mProductId: 0,
        productType: productTypeId,
        productTypeName: ptype ,
        codProd: codProd,
        prodCatId: prodCatId,
        taxName: taxName ,
        umId: umId,
        name: name,
        price: price,
        quantity: quantity,
        categoria:categoria,
        qtySold: qtySold,
        taxId: selectTax,
        umName: uM,
        productGroupId: prodructGroupId,
        produtGroupName: productGroupName,
        priceListSales: 0
      );

    // Llama a un método para guardar el producto en Sqflite
    final id =  saveProductToDatabase(product);
    print('Esto es el id $id');
  //  dynamic result = await createProductIdempiere(product.toMap());
  //  print('este es el $result');
  //  if(!result != ''){
  //   final mProductId = result['StandardResponse']['outputFields']['outputField'][0]['@value'];
  //   final codProdc = result['StandardResponse']['outputFields']['outputField'][1]['@value'];
  //   print('Este es el mp product id $mProductId && el codprop $codProdc');
  //   // Limpia los controladores de texto después de guardar el producto

  //   await DatabaseHelper.instance.updateProductMProductIdAndCodProd(id, mProductId, codProdc);
  // }
  //   _nameController.clear();
  //   _priceController.clear();
  //   _quantityController.clear();
    
  //     setState(() {
  //       _selectedTaxIndex = 0;
  //       _selectedCategoriesIndex = 0;
  //       _selectedUmIndex = 0;
  //  });
    // _formKey.currentContext!.reset();
    // setState(() {
    // _imageFile = null;
    // });


    final scaffoldMessenger = ScaffoldMessenger.of(_context);
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Producto guardado correctamente'),
      ),
    );


    setState(() {

        _nameController.clear();
        _selectedTaxIndex = 0;
        _selectedCategoriesIndex = 0;
        _selectedUmIndex = 0;
        _selectedProductType = 'first';
        _seletedProductGroup = 0;

    });



    // Muestra un mensaje de éxito o realiza cualquier otra acción necesaria



  }
Future<int> saveProductToDatabase(Product product) async {
  final db = await DatabaseHelper.instance.database;
  if (db != null) {
    int result = await db.insert('products', product.toMap());
    if (result != -1) {
      print('El producto se ha guardado correctamente en la base de datos con el id: $result');
      return result; // Devolver el ID del producto registrado
    } else {
      print('Error al guardar el producto en la base de datos');
      return -1; // Opcional: devolver un valor de error
    }
  } else {
    // Manejar el caso en el que db sea null, por ejemplo, lanzar una excepción o mostrar un mensaje de error
    print('Error: db is null');
    return -1; // Opcional: devolver un valor de error
  }
}


  @override
  void dispose() {
    // Limpia los controladores de texto cuando el widget se elimina del árbol
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _qtySoldController.dispose();
    super.dispose();
  }


}
