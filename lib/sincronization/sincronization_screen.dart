import 'package:femovil/config/app_bar_femovil.dart';
import 'package:femovil/config/getPosProperties.dart';
import 'package:femovil/database/create_database.dart';
import 'package:femovil/presentation/retenciones/idempiere/payment_terms_sincronization.dart';
import 'package:femovil/presentation/screen/home/home_screen.dart';
import 'package:femovil/sincronization/design_charger/striped_design.dart';
import 'package:femovil/sincronization/https/bank_account.dart';
import 'package:femovil/sincronization/https/ciuu_activities.dart';
import 'package:femovil/sincronization/https/impuesto_http.dart';
import 'package:femovil/sincronization/https/search_id_invoice.dart';
import 'package:femovil/sincronization/sincronizar_create.dart';
import 'package:flutter/material.dart';

double syncPercentage = 0.0; // Estado para mantener el porcentaje sincronizado
double syncPercentageClient = 0.0;
double syncPercentageProviders = 0.0;
double syncPercentageSelling = 0.0;
double syncPercentageImpuestos = 0.0;
double syncPercentageBankAccount = 0.0;
bool setearValoresEnCero = true;

class SynchronizationScreen extends StatefulWidget {
  const SynchronizationScreen({super.key});

  @override
  _SynchronizationScreenState createState() => _SynchronizationScreenState();
}

Future<void> _deleteBaseDatos() async {
  await DatabaseHelper.instance.deleteDatabases();
}

class _SynchronizationScreenState extends State<SynchronizationScreen> {
  GlobalKey<_SynchronizationScreenState> synchronizationScreenKey =
      GlobalKey<_SynchronizationScreenState>();
      bool _enableButtons = true;

  @override
  void initState() {
    //  _deleteBaseDatos();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: synchronizationScreenKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(170),
        child: AppBars(labelText: 'Sincronización')),
      body: Column(
        children: [
          
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                 width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                       Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Container(
                              margin: const EdgeInsets.only(top: 6),
                            width: 150,
                          child: Text('Productos', style: TextStyle(fontFamily: 'Poppins SemiBold'),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo inicial
                            border: Border.all(color: const Color(0XFFA5F52B)), // Borde verde
                            borderRadius:
                                BorderRadius.circular(5.0), // Bordes redondeados
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentage),
                              Center(
                                child: Text(
                                  '${syncPercentage.toStringAsFixed(1)} %', // Porcentaje visible
                                  style:  TextStyle(
                                    color: syncPercentage == 100 ?  Colors.white: Colors.black, // Color del texto
                                    fontFamily: 'Poppins SemiBold'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                ),
                Container(
                    width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                            width: 150,
                          child: Text('Clientes', style: TextStyle(fontFamily: 'Poppins SemiBold'),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo inicial
                            border: Border.all(color: const Color(0XFFA5F52B)), // Borde verde
                            borderRadius:
                                BorderRadius.circular(5.0), // Bordes redondeados
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentageClient),
                              Center(
                                child: Text(
                                  '${syncPercentageClient.toStringAsFixed(1)} %',
                                  style:  TextStyle(
                                    color: syncPercentageClient == 100 ? Colors.white : Colors.black,
                                    fontFamily: 'Poppins SemiBold'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [


                Container(
                   width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                       Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),

                        child: Container(
                           margin: const EdgeInsets.only(top: 6),
                            width: 150,
                          child: Text('Proveedores', style: TextStyle(fontFamily: 'Poppins SemiBold'),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo inicial
                            border: Border.all(color: const Color(0XFFA5F52B)), // Borde verde
                            borderRadius:
                                BorderRadius.circular(5.0), // Bordes redondeados
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentageProviders),
                              Center(
                                child: Text(
                                  '${syncPercentageProviders.toStringAsFixed(1)} %', 
                                  style:  TextStyle(
                                    color: syncPercentageProviders == 100  ? Colors.white : Colors.black, 
                                    fontFamily: 'Poppins SemiBold' 
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  ),
                ),
                Container(
                  width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                       Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                            width: 155,
                          child: Text('Ventas', style: TextStyle(fontFamily: 'Poppins SemiBold'),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo inicial
                            border: Border.all(color: const Color(0XFFA5F52B)), // Borde verde
                            borderRadius:
                                BorderRadius.circular(5.0), // Bordes redondeados
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentageSelling),
                              Center(
                                child: Text(
                                  '${syncPercentageSelling.toStringAsFixed(1)} %', // Porcentaje visible
                                  style:  TextStyle(
                                    color: syncPercentageSelling == 100 ? Colors.white : Colors.black, // Color del texto
                                    fontFamily: 'Poppins SemiBold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                   
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Container(
                   width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                       Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                            width: 155,
                          child: Text('Impuestos', style: TextStyle(fontFamily: 'Poppins SemiBold'),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, // Altura del contenedor
                          decoration: BoxDecoration(
                            color: Colors.white, // Color de fondo inicial
                            border: Border.all(color: const Color(0XFFA5F52B)), // Borde verde
                            borderRadius:
                                BorderRadius.circular(5.0), // Bordes redondeados
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentageImpuestos)
                              ,
                              Center(
                                child: Text(
                                  '${syncPercentageImpuestos.toStringAsFixed(1)} %', 
                                  style:  TextStyle(
                                    color: syncPercentageImpuestos == 100 ? Colors.white : Colors.black, 
                                    fontFamily: 'Poppins SemiBold',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  
                    ],
                  ),
                ),
                Container(
                  width: 155,
                  decoration: BoxDecoration(
                   color: const Color(0xFFF0EBFC),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 7,
                        spreadRadius: 2
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                        child: Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 155,
                          child: const Text('Cuentas Bancarias', style: TextStyle(color: Colors.black,fontFamily: 'Poppins SemiBold',),textAlign: TextAlign.center,)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        child: Container(
                          width: 150,
                          height: 20, 
                          decoration: BoxDecoration(
                            color: Colors.white, 
                            border: Border.all(color: const Color(0XFFA5F52B)), 
                            borderRadius:
                                BorderRadius.circular(5.0), 
                          ),
                          child: Stack(
                            children: [
                              StripedContainer(syncPercentages: syncPercentageBankAccount),
                              Center(
                                child: Text(
                                  '${syncPercentageBankAccount.toStringAsFixed(1)} %',
                                  style:  TextStyle(
                                    shadows: const [
                                       Shadow(
                                        blurRadius: 15,
                                        color: Colors.grey
                                      )
                                    ],
                                    color: syncPercentageBankAccount == 100 ? Colors.white : Colors.black, 
                                    fontFamily: 'Poppins SemiBold'
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),


                     
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 25,),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              decoration: BoxDecoration(
                boxShadow: [

                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 7,
                    spreadRadius: 1,
                  )
                ]
                
              ),
              child: ElevatedButton(

                style: ButtonStyle(
                  elevation:  WidgetStateProperty.all<double>(0),
                  foregroundColor: WidgetStatePropertyAll(Colors.black),
                  shape: WidgetStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(8),
                     side: BorderSide.none
                  )),
                ),
                
                onPressed: _enableButtons ? () async {
                  // Llamada a la función de sincronización
                      setState(() {

                      _enableButtons = false;
                      
                      });
                      
                  if (setearValoresEnCero == false) {
        
                    setState(() {

                      syncPercentage = 0;
                      syncPercentageClient = 0;
                      syncPercentageImpuestos = 0;
                      syncPercentageProviders = 0;
                      syncPercentageSelling = 0;
                      syncPercentageBankAccount = 0;
                      setearValoresEnCero = true;
                   
                    });
        
                  }
              
                  await getPosPropertiesInit();
              
                  if (variablesG.isEmpty) {
                    List<Map<String, dynamic>> response =
                        await getPosPropertiesV();
              
                    setState(() {
                      variablesG = response;
                    });
                    
                  }
              
                  sincronizationSearchIdInvoice(setState);  
                  sincronizationCiuActivities(setState);
                  sincronizationBankAccount(setState);
                  sincronizationPaymentTerms();
                  sincronizationImpuestos(setState);
                  await synchronizeCustomersWithIdempiere(setState);
                  await synchronizeProductsWithIdempiere(setState);
                  await synchronizeOrderSalesWithIdempiere(setState);
              
                  // sincronizationCustomers(setState);
                   
                  setState(() {
                    _enableButtons = true;
                    setearValoresEnCero = false;
                  });
                }: null,
                child:  Text('Sincronizar', style: TextStyle(fontFamily: 'Poppins Bold', fontSize: 17, color: _enableButtons ? Color(0XFF7531FF): Color.fromARGB(255, 82, 78, 78)),),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
