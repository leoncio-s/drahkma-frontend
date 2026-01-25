import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';

class TransferBankDTO extends TransferBank
{
  TransferBankDTO({super.bankAccount, super.description, super.id, super.type});

  Map<String, dynamic> toMap() {
    return {
        'id' : id,
        'type' : type!.name,
        'description' : description,
        'bank_account' : bankAccount!.id
      };
  }
}