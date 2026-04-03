import 'package:drahkma/core/mixins/dto_mixin.dart';

class BankAccountDTO with DTOMixin {
    final int? id;
    final String? accountNumber;
    final String? agency;
    final String? bankCode;
    final String? bankName;

    BankAccountDTO({
      this.id, 
      this.accountNumber, 
      this.agency, 
      this.bankCode, 
      this.bankName
    });
    
    @override
    Map<String, dynamic> toMap() {
      return {
              'id' : id,
              'bankCode' : bankCode,
              'bankName' : bankName,
              'agency' : agency,
              'accountNumber' : accountNumber
      };
  }
}