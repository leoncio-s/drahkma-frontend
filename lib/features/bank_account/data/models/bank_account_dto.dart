import 'package:drahkma/core/mixins/dto_mixin.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';

class BankAccountDTO extends BankAccount with DTOMixin
{
    BankAccountDTO({super.id, super.accountNumber, super.agency, super.bankCode, super.bankName});
    
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