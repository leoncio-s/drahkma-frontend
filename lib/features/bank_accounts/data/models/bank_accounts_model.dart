
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';

class BankAccountModel extends BankAccount {

  BankAccountModel(
      {super.id,
      super.bankCode,
      super.accountNumber,
      super.agency,
      super.bankName});

  @override
  factory BankAccountModel.toObject(Map<String, dynamic> data) {
    int? id = data['id'] ?? 0;
    String? bankCode = data['bankCode'] ?? "";
    String? bankName = data['bankName'] ?? "";
    String? agency = data['agency'] ?? "";
    String? accountNumber = data['accountNumber'] ?? "";

    return BankAccountModel(id: id, bankCode: bankCode, bankName: bankName, agency: agency, accountNumber: accountNumber);
  }
  
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