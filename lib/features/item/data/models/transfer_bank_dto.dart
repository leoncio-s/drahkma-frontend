import 'package:drahkma/features/item/domain/entities/transfer_bank.dart';

class TransferBankDTO extends TransferBank
{
  TransferBankDTO({super.bankAccount, super.description, super.id, super.type});

  factory TransferBankDTO.fromModel(TransferBank transferBank)
  {
    return TransferBankDTO(
      bankAccount: transferBank.bankAccount,
      description: transferBank.description,
      id: transferBank.id,
      type: transferBank.type
    );
  }

  Map<String, dynamic> toMap() {
    return {
        'id' : id,
        'type' : type!.name,
        'description' : description,
        'bank_account' : bankAccount!.id
      };
  }
}