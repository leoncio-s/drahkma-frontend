import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';
import 'package:drahkma/features/items/domain/enums/transfer_bank_type_enum.dart';

class TransferBank{
    int? id;
    TransferBankTypeEnum? type;
    String? description;
    BankAccount? bankAccount;

    TransferBank({this.bankAccount, this.description, this.id, this.type});
}