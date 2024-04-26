import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/insert_database.dart';
import 'package:femovil/presentation/clients/select_customer.dart';
import 'package:femovil/presentation/cobranzas/idempiere/create_cobro.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';



  



class Cobro extends StatefulWidget {
  final int orderId;
  final double saldoTotal;
  final Function loadCobranzas;
  final dynamic cOrderId; 
  final dynamic documentNo;
  final dynamic idFactura;
  
  const Cobro({super.key, required this.orderId, required this.saldoTotal, required this.loadCobranzas, required this.cOrderId, required this.documentNo, required this.idFactura});

  @override
  State<Cobro> createState() => _CobroState();
}


class _CobroState extends State<Cobro> {
  late Future<Map<String, dynamic>> _ordenVenta;
  TextEditingController numRefController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  final TextEditingController _fechaIdempiereController = TextEditingController();
  String? paymentTypeValue = 'Efectivo';
  String? coinValue = "\$";
  String? typeDocumentValue = "Cobro";
  dynamic cBPartnerIds = 0;
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> bankAccountsList = [];
    List<Map<String, dynamic>> typeCoinsList = [];

  // Selecteds 

  int _selectsBankAccountId =  0; 
  String _selectTypePayment = "X";
  dynamic _selectTypeCoins = 0;
  //Texts

  String _bankAccountText = "";

List<Map<String, dynamic>> uniqueISOsAndCurrencyId = [];



void _loadCurrentDate() {
  final now = DateTime.now();
  final formattedDate = DateFormat('dd/MM/yyyy').format(now);

  dateController.text = formattedDate; // Asigna la fecha actual al controlador del campo de texto
}


void _getBankAcc() async {


    List<Map<String, dynamic>> bankAccounts = await getBankAccounts();

      bankAccountsList
        .add({'c_bank_id': 0, 'bank_name': 'Selecciona una Cuenta Bancaria'});


          for (var account in bankAccounts) {

          if (!uniqueISOsAndCurrencyId.any((element) => element['iso_code'] == account['iso_code'])) {
            setState(() {
              
            uniqueISOsAndCurrencyId.add({
              'iso_code': account['iso_code'],
              'c_currency_id': account['c_currency_id']
            });
            });
          }
          
        }



    setState(() {

      bankAccountsList.addAll(bankAccounts);

    });


    print("estos son las cuentas agregadas desde la base de datos $bankAccounts");

}

    initV() async {

        if (variablesG.isEmpty) {

          await getPosPropertiesInit();
          List<Map<String, dynamic>> response = await getPosPropertiesV();
          setState(() { 
            variablesG = response;
          });

        }
      }


@override
void initState() {

      initV();
    _ordenVenta =  _loadOrdenVentasForId();
    setState(() {
      
       montoController.text = "0";
       numRefController.text = "Sin registro";
    });
      _loadCurrentDate();
      _getBankAcc();

    _fechaIdempiereController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(selectedDate);

  super.initState();


}

 Future<Map<String, dynamic>> _loadOrdenVentasForId() async {
    return await getOrderWithProducts(widget.orderId);
    
  }


  @override
  Widget build(BuildContext context) {
           final screenMax = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
                  backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      
            appBar: AppBar(title: const Text("Cobro"),
                  backgroundColor: const Color.fromARGB(255, 236, 247, 255),
      
            ),
      
            body: FutureBuilder(
                    future: _ordenVenta,
                    builder: (context,  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
      
                          } else if (snapshot.hasError) {
                            
                            return Text('Error: ${snapshot.error}');
      
                          }else{
                              final clientData = snapshot.data!['client'][0];
                              final orderData = snapshot.data!['order'];
                              print("Esto es snapshot data ${snapshot.data}");

                               cBPartnerIds = orderData['c_bpartner_id']; 

                           return  Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Align(
                                alignment: Alignment.topCenter,
                               child: SingleChildScrollView(  
                                 child: Column(
                                    crossAxisAlignment:  CrossAxisAlignment.center,
                                  children: [
                                  Container(
                                      width: screenMax ,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                                      ),
                                      child: const Text('Datos De la Orden', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                    ),
                                  const SizedBox(height: 10,),
                                    Column(
                                      children: [
                                        Container(
                                          width: screenMax,
                                          decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          
                                          ),
                                          child:  Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                          child:  Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                               CustomTextInfo(
                                                 label: "N° Document",
                                                 value: orderData['documentno'].toString() != "" ? orderData['documentno'].toString() : "Sin registro",
                                               ),
                                               CustomTextInfo(
                                                 label: "Cliente",
                                                 value: clientData['bp_name'],
                                               ),
                                               CustomTextInfo(
                                                 label: "Ruc",
                                                 value: clientData['ruc'].toString(),
                                               ),
                                                CustomTextInfo(
                                                 label: "Saldo Total",
                                                 value: widget.saldoTotal.toString(),
                                               ),
                                               ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 10,),
                                       Container(
                                        width: screenMax ,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(8), // Establece el radio de los bordes
                                        ),
                                        child: const Text('Cobranza', style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                                       ),
                                      const SizedBox(height: 10,),
                                        Container(
                                          width: screenMax,
                                          decoration: BoxDecoration(
                                              color:  Colors.white,
                                              borderRadius:  BorderRadius.circular(8),
                                          ),
                                            child:  Column(
                                 
                                                children: [
                                                  TextFormField(  
                                                      readOnly: true,
                                                      controller: numRefController,
                                 
                                                      onChanged: (value) {
                                 
                                                        
                                 
                                                      },
                                                       decoration: const InputDecoration(
                                                      labelText: 'Número de Documento', // Etiqueta que se muestra sobre el campo
                                                      contentPadding: EdgeInsets.all(15)
                                                      ),
                                 
                                                  ), 

                                                   CustomDropdownButtonFormField(identifier: 'selectTypeAccountBank', selectedIndex: _selectsBankAccountId , dataList: bankAccountsList, text: _bankAccountText, onSelected: (newValue, bankAccText) {
                                                      setState(() {
                                                          _selectsBankAccountId = newValue ?? 0;
                                                          _bankAccountText = bankAccText;
                                                      });
                                                  },),

                                                  DropdownButtonFormField(
                                              items: uniqueISOsAndCurrencyId.map((Map<String, dynamic> item) {
                                                return DropdownMenuItem<String>(
                                                  value: item['c_currency_id'].toString(),
                                                  child: Text(item['iso_code']),
                                                );
                                              }).toList(),
                                              onChanged: (selectedValue) {


                                                  setState(() {
                                                    _selectTypeCoins = selectedValue ;
                                                  });

                                                print('Este es el valor seleccionado: $selectedValue y selecteTypeCoins $_selectTypeCoins');
                                                // Aquí puedes realizar acciones adicionales con el valor seleccionado
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Tipo de Moneda',
                                                labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5),
                                                contentPadding: EdgeInsets.all(15),
                                              ),
                                            ),

                                              DropdownButtonFormField<String>(
                                              value: paymentTypeValue,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  paymentTypeValue = newValue;


                                                });

                                                if(newValue == 'Depósito Directo'){

                                                    setState(() {
                                                      _selectTypePayment = 'A';
                                                    });

                                                }else if(newValue == 'Tarjeta de Crédito'){

                                                    setState(() {
                                                      _selectTypePayment = 'C';
                                                    });

                                                }else if(newValue == "Cheque"){

                                                    setState(() {
                                                      _selectTypePayment = 'K';
                                                    });

                                                }else if(newValue == "Cuenta"){

                                                    setState(() {
                                                      _selectTypePayment = 'T';
                                                    });

                                                }else if(newValue == 'Efectivo' ){

                                                    setState(() {
                                                      _selectTypePayment = 'X';
                                                    });

                                                }else if(newValue == 'Débito Directo'){

                                                    setState(() {
                                                      _selectTypePayment = 'D';
                                                    });

                                                }

                                                print('Este es el valor de paymentTypeValue $paymentTypeValue && este es el valor de $_selectTypePayment');
                                              },
                                             items: <String>['Depósito Directo', 'Tarjeta de Crédito', 'Cheque', 'Cuenta', 'Efectivo', 'Débito Directo' ].map((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                            decoration: const InputDecoration(
                                              labelText: 'Tipo de Pago',
                                              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 0.5),
                                              contentPadding: EdgeInsets.all(15),
                                            ),
                                          ),


                                              TextFormField(
                                                readOnly: true,
                                                controller: dateController,
                                                decoration: const InputDecoration(
                                                  labelText: "Fecha",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),

                                              

                                              TextFormField(
                                                controller: montoController,
                                                decoration: const InputDecoration(
                                                  labelText: "Monto",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),

                                           
                                                    TextFormField(
                                                controller: observacionController,
                                                decoration: const InputDecoration(
                                                  labelText: "Observacion",
                                                  contentPadding: EdgeInsets.all(15),
                                                ),
                                              ),

            
                                                ],
                                 
                                            ),
                                 
                                        ),  
                                          const SizedBox(height: 10,),
                                        // Aqui va el boton
                                           ElevatedButton(
                                                onPressed: orderData['status_sincronized'] == 'Enviado' ?  () async {
                                                  // Aquí puedes agregar la lógica para crear el cobro
                                                           await _createCobro(widget.loadCobranzas);
  
                                                } : null,
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.green, // Color de fondo verde
                                                  minimumSize: Size(screenMax, 50), // Ancho máximo y altura de 50
                                                ),
                                                child: const Text(
                                                  'Crear Cobro',
                                                  style: TextStyle(fontSize: 16), // Tamaño de fuente 16
                                                ),
                                              ),
                                              
                                                                              
                                      ],
                                    ),
                                                            
                                 ],                        
                                                             ),
                               ),
                             ),
                           );
                        }
                    }, 
      
            ),
      
      ),
    );
  }

 Future<void> _createCobro(loadCobranzas) async {
  final dynamic bankAccountId = _selectsBankAccountId;
  //Tipo del documento de cobro
  final dynamic cDocTypeId = variablesG[0]['c_doctypereceipt_id'];
  final dynamic dateTrx = _fechaIdempiereController.text;
  final dynamic description = observacionController.text;
  final dynamic cBPartnerId = cBPartnerIds;
  final dynamic payAmt = double.parse(montoController.text);

  final dynamic currencyId = _selectTypeCoins;
  final dynamic cOrderId = widget.cOrderId;
  final dynamic cInvoiceId = widget.idFactura;
  final dynamic tenderType = _selectTypePayment;

  print('Esto es numRef ${numRefController.text}  es currencyId $currencyId y este es el orderId $cOrderId y este es el id de la factura $cInvoiceId');

  final int documentNo = int.parse(numRefController.text == 'Sin registro'  ? numRefController.text = '0': numRefController.text);
  

  final String date = dateController.text;

  final int saleOrderId = widget.orderId;

  // Obtener el saldo total de la orden
  final double saldoTotal = widget.saldoTotal;

  print('esto es el saldototal $saldoTotal');

  if (payAmt > saldoTotal) {
    // Si el monto del cobro es mayor al saldo total, mostrar mensaje de diálogo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('El cobro no puede ser mayor al saldo total de la orden.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  } else {
    // Si el monto del cobro es menor o igual al saldo total, insertar el cobro en la base de datos


    Map<String, dynamic> cobro = {
      "c_bankaccount_id" : bankAccountId, 
      "c_doctype_id" : cDocTypeId, 
      "date_trx" : dateTrx, 
      "description" : description,
      "c_bpartner_id": cBPartnerId, 
      "pay_amt": payAmt, 
      "c_currency_id": currencyId,
      "c_order_id":  cOrderId, 
      "c_invoice_id": cInvoiceId,
      "tender_type": tenderType,      

    };

   dynamic response = await createCobroIdempiere(cobro);

    print("esto es el cobro $cobro y la respuesta $response" );

    await insertCobro(
      cBankAccountId: bankAccountId,
      cDocTypeId: cDocTypeId,
      dateTrx: dateTrx,
      date: date,
      description: description,
      cBPartnerId: cBPartnerId,
      payAmt: payAmt,
      cCurrencyId: currencyId,
      cOrderId: cOrderId,
      cInvoiceId: cInvoiceId,
      documentNo: documentNo,
      tenderType: tenderType ,
      saleOrderId: saleOrderId,
    );

    loadCobranzas();

    // Limpiar los campos de texto después de insertar el cobro
    numRefController.clear();
    montoController.clear();
    observacionController.clear();

    // Mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cobro creado con éxito')));
  }
}


}




class CustomTextInfo extends StatelessWidget {
  final String label;
  final String value;

  const CustomTextInfo({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 5,),
        Text(value),
        const Divider(),
      ],
    );
  }
}
