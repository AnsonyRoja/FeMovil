import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/products.dart';
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

  void _loadTaxs()async {

       
        final getTaxs = await listarImpuestos();
        final getCategories = await listarCategorias();
        final getUm = await  listarUnidadesDeMedida();
        print("Esto es getTaxs $getTaxs");
        print('Esto es getCategories $getCategories');
        print('Estas son las unidades de medidas $getUm');


      print("esto es categoriesList con la nueva opcion 0 $_taxList");
      _taxList.add({'tax_cat_id': 0, 'tax_cat_name': 'Selecciona un impuesto'});
      _categoriesList.add({'pro_cat_id': 0, 'categoria': 'Selecciona una categoria'});
      _umList.add({'um_id': 0, 'um_name': 'Unidad de medida'});
      



        setState(() {
        _taxList.addAll(getTaxs);
        _categoriesList.addAll(getCategories);
        _umList.addAll(getUm);

        });
        print("esto es taxlist $_taxList");
      }



 List<Map<String, dynamic>> _taxList = []; // Lista para almacenar los impuestos disponibles
 List<Map<String, dynamic>> _categoriesList = [];
 List<Map<String, dynamic>> _umList = [];
  int _selectedTaxIndex = 0; // Índice del impuesto seleccionado por defecto
  int _selectedCategoriesIndex = 0;
  int _selectedUmIndex = 0;
  String _prodCatText = '';
  String _taxText = '';
  String _umText = '';


String obtenerNombreImpuesto(int? id) {
  // Buscar la categoría en _categoriesList que coincide con el ID dado
  Map<String, dynamic>? impuesto = _taxList.firstWhere(
    (taxlist) => taxlist['tax_cat_id'] == id,
  );

  // Si se encuentra la categoría, devolver su nombre, de lo contrario devolver una cadena vacía
  return impuesto != null ? impuesto['tax_cat_name'] : '';
}

String obtenerNombreCategoria(int? id) {
  // Buscar la categoría en _categoriesList que coincide con el ID dado
  Map<String, dynamic>? categoria = _categoriesList.firstWhere(
    (categoria) => categoria['pro_cat_id'] == id,
  );

  // Si se encuentra la categoría, devolver su nombre, de lo contrario devolver una cadena vacía
  return categoria != null ? categoria['categoria'] : '';
}

String obtenerNombreUm(int? id) {
  // Buscar la categoría en _categoriesList que coincide con el ID dado
  Map<String, dynamic>? um = _umList.firstWhere(
    (umList) => umList['um_id'] == id,
  );

print("Esto es el nombre umlist $um");

  return um != null ? um['um_name'] : '';
}


  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing product details
    _nameController.text = widget.product['name'].toString();
    _categoryController.text = widget.product['categoria'].toString();
    _priceController.text = widget.product['price'] is double ?  widget.product['price'].toString(): 0.toString();
    _quantityController.text = widget.product['quantity'].toString();
    _minStockController.text = widget.product['min_stock'].toString();
    _maxStockController.text = widget.product['max_stock'].toString();
    _selectedTaxIndex = widget.product['tax_cat_id'];
    _selectedCategoriesIndex = widget.product['pro_cat_id'];
    _selectedUmIndex = widget.product['um_id'];
    _taxText = widget.product['tax_cat_name'];
    _prodCatText = widget.product['categoria'];
    _umText = widget.product['um_name'];
     _loadTaxs();
     print('Estos son los productos ${widget.product}');


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
            "Editar Producto",
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
                  _buildTextFormField('Precio', _priceController),
                     Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0), // Ajusta el radio del borde según sea necesario
                      border: Border.all(color: Colors.grey), // Color del borde
                      color: const Color.fromARGB(255, 236, 247, 255), // Color de fondo
                    ),
                    child: DropdownButtonFormField<int>(
                      value: _selectedTaxIndex,
                      items: _taxList.map<DropdownMenuItem<int>>((tax) {
                        return DropdownMenuItem<int>(
                          value: tax['tax_cat_id'] as int,
                          child: Text(tax['tax_cat_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        String nameTax = obtenerNombreImpuesto(newValue);
                        setState(() {
                          _taxText = nameTax;
                          _selectedTaxIndex = newValue as int;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Impuesto',
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
                    child: DropdownButtonFormField<int>(
                      value: _selectedCategoriesIndex,
                      items: _categoriesList.map<DropdownMenuItem<int>>((categories) {
                        return DropdownMenuItem<int>(
                          value: categories['pro_cat_id'] as int,
                          child: Text(categories['categoria'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        String nameCat = obtenerNombreCategoria(newValue);
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
                    child: DropdownButtonFormField<int>(
                      value: _selectedUmIndex,
                      items: _umList.map<DropdownMenuItem<int>>((um) {
                        return DropdownMenuItem<int>(
                          value: um['um_id'] as int,
                          child: Text(um['um_name'] as String),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        String nameUm = obtenerNombreUm(newValue);
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


                  _buildTextFormField('Cantidad Disponible', _quantityController),
               
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
            await DatabaseHelper.instance.updateProduct(updatedProduct);

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
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }
}
