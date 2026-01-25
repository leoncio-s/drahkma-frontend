import 'package:drahkma/features/bank_account/data/models/bank_account_model.dart';

class BankAccountSort{
  static Comparator<BankAccountModel> asc = (BankAccountModel it1, BankAccountModel it2) =>  it1.bankName!.compareTo(it2.bankName.toString());

  static Comparator<BankAccountModel> desc = (BankAccountModel it1, BankAccountModel it2) => it2.bankName!.compareTo(it1.bankName.toString());
}