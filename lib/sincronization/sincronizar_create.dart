import 'package:femovil/database/gets_database.dart';
import 'package:femovil/database/update_database.dart';
import 'package:femovil/infrastructure/models/clients.dart';
import 'package:femovil/infrastructure/models/products.dart';
import 'package:femovil/presentation/clients/idempiere/create_customer.dart';
import 'package:femovil/presentation/products/idempiere/create_product.dart';
import 'package:femovil/presentation/products/products_http.dart';
import 'package:femovil/sincronization/https/customer_http.dart';

synchronizeProductsWithIdempiere(setState) async {
  List<Map<String, dynamic>> productsWithZeroValues =
      await getProductsWithZeroValues();

  await sincronizationProducts(setState);
  
  for (var productData in productsWithZeroValues) {
    Product product = Product(
      mProductId: productData['m_product_id'],
      productType: productData['product_type'],
      productTypeName: productData['product_type_name'],
      codProd: productData['cod_product'],
      prodCatId: productData['pro_cat_id'],
      taxName: productData['tax_cat_name'],
      productGroupId: productData['product_group_id'],
      produtGroupName: productData['product_group_name'],
      umId: productData['um_id'],
      umName: productData['um_name'],
      name: productData['name'],
      price: productData['price'],
      quantity: productData['quantity'],
      categoria: productData['categoria'],
      qtySold: productData['total_sold'],
      taxId: productData['tax_cat_id'],
      priceListSales: productData['pricelistsales'],
    );
    dynamic result = await createProductIdempiere(product.toMap());
    print('este es el $result');

    final mProductId =
        result['StandardResponse']['outputFields']['outputField'][0]['@value'];
    final codProdc =
        result['StandardResponse']['outputFields']['outputField'][1]['@value'];
    print('Este es el mp product id $mProductId && el codprop $codProdc');
    // Limpia los controladores de texto después de guardar el producto
    await updateProductMProductIdAndCodProd(
        productData['id'], mProductId, codProdc);
  }
}

synchronizeCustomersWithIdempiere(setState) async {
  List<Map<String, dynamic>> customersWithZeroValues =
      await getCustomersWithZeroValues();

  await sincronizationCustomers(setState);

  print('Esto es custommer en cero $customersWithZeroValues');
  
  for (var customersData in customersWithZeroValues) {
    Customer customer = Customer(
        cbPartnerId: customersData['c_bpartner_id'],
        codClient: customersData['cod_client'],
        isBillTo: 'Y',
        address: customersData['address'],
        bpName: customersData['bp_name'],
        cBpGroupId: customersData['c_bp_group_id'],
        cBpGroupName: customersData['group_bp_name'],
        cBparnetLocationId: 0,
        cCityId: customersData['c_city_id'],
        cCountryId: customersData['c_country_id'],
        cLocationId: 0, 
        cRegionId: 0,
        city: customersData['city'],
        codePostal: customersData['code_postal'],
        country: customersData['country'],
        email: customersData['email'],
        lcoTaxIdTypeId: customersData['lco_tax_id_typeid'],
        lcoTaxPayerTypeId: customersData['lco_tax_payer_typeid'],
        lvePersonTypeId: customersData['lve_person_type_id'],
        personTypeName: customersData['person_type_name'],
        phone: customersData['phone'],
        region: customersData['region'],
        ruc: customersData['ruc'],
        taxIdTypeName: customersData['tax_id_type_name'],
        taxPayerTypeName: customersData['tax_payer_type_name']

    );
    dynamic result = await createCustomerIdempiere(customer.toMap());
    print('este es el $result');

    final cBParnertId =
        result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']
        ['outputField'][0]['@value'];
    final newCodClient =
        result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][0]['outputFields']
        ['outputField'][1]['@value'];
    final cLocationId =  result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][1]['outputFields']
        ['outputField']['@value'];
    final cBPartnerLocationId = result['CompositeResponses']['CompositeResponse']
        ['StandardResponse'][2]['outputFields']
        ['outputField']['@value'];

    print('Esto es el codigo de partnert id  $cBParnertId, esto es el $newCodClient, esto es el $cLocationId y esto es el cbparnert location id $cBPartnerLocationId');


    await updateCustomerCBPartnerIdAndCodClient(
        customersData['id'], cBParnertId, newCodClient, cLocationId, cBPartnerLocationId );
  }
}