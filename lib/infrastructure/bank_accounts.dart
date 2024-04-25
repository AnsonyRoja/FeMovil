






class BankAccounts {


  final dynamic bankId;
  final dynamic bankName;
  final dynamic routingNo;
  final dynamic cBankAccountId;
  final dynamic accountNo;
  final dynamic cCurrencyId;
  final dynamic isoCode;

  const BankAccounts({
    required this.bankId, 
    required this.bankName, 
    required this.routingNo, 
    required this.cBankAccountId,  
    required this.accountNo,
    required this.cCurrencyId,
    required this.isoCode,

    });



  Map<String, dynamic> toMap(){
      return { 
        "c_bank_id": bankId,
        "bank_name": bankName,
        "routing_no":routingNo,
        "c_bank_account_id": cBankAccountId,
        "account_no": accountNo,
        "c_currency_id": cCurrencyId,
        "iso_code": isoCode,
      };

  }



}

