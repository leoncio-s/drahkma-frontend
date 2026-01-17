import 'package:drahkma/features/bank_accounts/domain/entities/bank.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';

abstract class BankAccountsRepository
{
  Future<BankAccount?> save(BankAccount dto);
  Future<void>  update(BankAccount dto);
  Future<void>  delete(BankAccount dto);
  Future<BankAccount?> getBy({int? id});
  Future<List<BankAccount>?> getAll();
  Future<List<Bank>?> getBanks();
}