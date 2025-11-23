import 'package:drahkma/features/bank_accounts/data/models/bank_accounts_model.dart';

class BankAccountsSort{
  static Comparator<BankAccountModel> asc = (BankAccountModel it1, BankAccountModel it2) =>  it1.bankName!.compareTo(it2.bankName.toString());

  static Comparator<BankAccountModel> desc = (BankAccountModel it1, BankAccountModel it2) => it2.bankName!.compareTo(it1.bankName.toString());
}