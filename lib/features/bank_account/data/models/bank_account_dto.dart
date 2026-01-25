import 'package:drahkma/core/mixins/dto.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';

class BankAccountDTO extends BankAccount with DTO
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