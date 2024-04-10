





class OrderSales {
      final dynamic id;
      final dynamic cDoctypeTargetId;
      final dynamic adClientId;
      final dynamic adOrgId;
      final dynamic mWareHouseId;
      final dynamic documentNo; 
      final dynamic paymentRule;
      final dynamic dateOrdered; 
      final dynamic salesRedId;
      final dynamic cBpartnerId;
      final dynamic cBpartnertLocationId;
      final dynamic fecha;
      final dynamic descripcion; 
      final dynamic monto; 
      final dynamic saldoNeto;
      final dynamic usuarioId;
      final dynamic clientId;
      final dynamic statusSincronized; 
      final dynamic lines; 

      OrderSales({
       required this.id,
       required this.cDoctypeTargetId, 
       required this.adClientId, 
       required this.adOrgId, 
       required this.mWareHouseId,
       required this.documentNo,
       required this.paymentRule,
       required this.dateOrdered,
       required this.salesRedId,
       required this.cBpartnerId,
       required this.cBpartnertLocationId,
       required this.fecha,
       required this.descripcion, 
       required this.monto,
       required this.saldoNeto,
       required this.usuarioId,
       required this.clientId,
       required this.statusSincronized,
       required this.lines
       });

    Map<String, dynamic> toMap(){

      return {
          'id':id,
          'c_doctypetarget_id' : cDoctypeTargetId,
          'ad_client_id': adClientId, 
          'ad_org_id': adOrgId,
          'm_warehouse_id':mWareHouseId,
          'documentno': documentNo,
          'paymentrule': paymentRule,
          'date_ordered': dateOrdered,
          'salesrep_id': salesRedId,
          'c_bpartner_id': cBpartnerId,
          'c_bpartner_location_id': cBpartnertLocationId,
          'fecha': fecha,
          'descripcion': descripcion,
          'monto': monto,
          'saldo_neto' : saldoNeto,
          'usuario_id': usuarioId,
          'client_id': clientId, 
          'status_sincronized': statusSincronized,
          'lines': lines

      };


    }



}






