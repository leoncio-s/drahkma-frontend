import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';

abstract interface class BankAccountLocalDatasource {

  Future<void> saveBankAccounts(List<BankAccount> accounts);
  Future<List<BankAccount>?> getBankAccounts();
  Future<void> clearBankAccounts();

}