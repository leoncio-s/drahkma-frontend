
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts.dart';
import 'package:drahkma/features/items/domain/enums/transfer_bank_type_enum.dart';

class TransferBank{
    int? id;
    TransferBankTypeEnum? type;
    String? description;
    BankAccounts? bankAccount;

    TransferBank({this.bankAccount, this.description, this.id, this.type}){
      // type = type;
    }
    
      Map<String, dynamic> toMap() {
        return {
          'id' : id,
          'type' : type!.name,
          'description' : description,
          'bank_account' : bankAccount!.id
        };
      }
    
      @override
      factory TransferBank.toObject(Map<String, dynamic> data) {
        BankAccounts? bankAccountsDto = BankAccounts.toObject(data['bank_account']);
        TransferBankTypeEnum? type = TransferBankTypeEnum.values.firstWhere((val) => val.name.contains(data['type']));
        return TransferBank(id: data['id'], description: data['description'], type: type, bankAccount: bankAccountsDto);
      }
}