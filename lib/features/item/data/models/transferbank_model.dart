
import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';
import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';
import 'package:drahkma/features/item/domain/enums/transfer_bank_type_enum.dart';

class TransferBankModel extends TransferBank{

    TransferBankModel({super.bankAccount, super.description, super.id, super.type});
    
      @override
      factory TransferBankModel.fromJson(Map<String, dynamic> data) {
        BankAccountModel? bankAccountsDto = BankAccountModel.fromJson(data['bank_account']);
        TransferBankTypeEnum? type = TransferBankTypeEnum.values.firstWhere((val) => val.name.contains(data['type']));
        return TransferBankModel(id: data['id'], description: data['description'], type: type, bankAccount: bankAccountsDto);
      }
}