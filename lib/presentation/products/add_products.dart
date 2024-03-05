import 'package:femovil/database/create_database.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';





class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  _AddProductFormState createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtySoldController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minStockController = TextEditingController();
  final TextEditingController _maxStockController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();
  String imagePath = "";

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(labelText: 'Precio del producto', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el precio del producto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(labelText: 'Cantidad disponible', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la cantidad disponible del producto';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
          onPressed: () async {
            final imagePicker = ImagePicker();
            
            final XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);


            if (image != null) {
              // Aquí puedes guardar la ruta de la imagen en una variable o mostrarla en algún lugar de tu formulario
              setState(() {
                
                imagePath = image.path;

              });
            }
          },
          child: const Text('Seleccionar imagen'),
        ),

                   const SizedBox(height: 10,),
                  TextFormField(
                    controller: _minStockController,
                    decoration: const InputDecoration(labelText: 'Stock mínimo', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el stock minimo del producto';
                      }
                      return null;
                    },
                  ),
                   const SizedBox(height: 10,),
                  TextFormField(
                    controller: _maxStockController,
                    decoration: const InputDecoration(labelText: 'Stock máximo', filled: true, fillColor: Colors.white),
                    keyboardType: TextInputType.number,
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el stock maximo del producto';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10,),
                    TextFormField(
                    controller: _categoriaController,
                    decoration: const InputDecoration(labelText: 'Categoria', filled: true, fillColor: Colors.white),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa una categoria';
                      }
                      return null;
                    },
                  ),
                   TextFormField(
                    controller: _qtySoldController,
                    decoration: const InputDecoration(labelText: 'Vendido', filled: true, fillColor: Colors.white),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la cantidad de ventas del producto';
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
    String name = _nameController.text;
    double price = double.parse(_priceController.text);
    int quantity = int.parse(_quantityController.text);
    double minStock = double.parse(_minStockController.text);
    double maxStock = double.parse(_maxStockController.text);
    String categoria = _categoriaController.text;
    int qtySold = int.parse(_qtySoldController.text);

    // Crea una instancia del producto
    Product product = Product(
      name: name,
      price: price,
      quantity: quantity,
      imagePath: imagePath,
      minStock: minStock,
      maxStock: maxStock,
      categoria:categoria,
      qtySold: qtySold
      
    );

    // Llama a un método para guardar el producto en Sqflite
    await saveProductToDatabase(product);

    // Limpia los controladores de texto después de guardar el producto
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    _minStockController.clear();
    _maxStockController.clear();
    _categoriaController.clear();
    _qtySoldController.clear();

    // Muestra un mensaje de éxito o realiza cualquier otra acción necesaria
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Producto guardado correctamente'),
    ));



  }

  Future<void> saveProductToDatabase(Product product) async {
    final db = await DatabaseHelper.instance.database;
    if (db != null) {
      int result = await db.insert('products', product.toMap());

      if (result != -1) {
        print('El producto se ha guardado correctamente en la base de datos con el id: $result');
      } else {
        print('Error al guardar el producto en la base de datos');
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
    _priceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _qtySoldController.dispose();
    super.dispose();
  }


}
