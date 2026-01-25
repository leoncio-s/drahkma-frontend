
import 'package:drahkma/features/bank_accounts/data/models/bank_accounts_model.dart';
import 'package:drahkma/features/items/domain/entities/transfer_bank.dart';
import 'package:drahkma/features/items/domain/enums/transfer_bank_type_enum.dart';

class TransferBankModel extends TransferBank{

    TransferBankModel({super.bankAccount, super.description, super.id, super.type});
    
      Map<String, dynamic> toMap() {
        return {
          'id' : id,
          'type' : type!.name,
          'description' : description,
          'bank_account' : bankAccount!.id
        };
      }
    
      @override
      factory TransferBankModel.toObject(Map<String, dynamic> data) {
        BankAccountModel? bankAccountsDto = BankAccountModel.toObject(data['bank_account']);
        TransferBankTypeEnum? type = TransferBankTypeEnum.values.firstWhere((val) => val.name.contains(data['type']));
        return TransferBankModel(id: data['id'], description: data['description'], type: type, bankAccount: bankAccountsDto);
      }
}