import 'package:drahkma/features/bank_account/domain/entities/bank.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';

abstract interface class BankAccountRemoteDatasource
{
  Future<BankAccount?> save(BankAccount dto);
  Future<void> update(BankAccount dto);
  Future<void> delete(BankAccount dto);
  Future<BankAccount?> get({dynamic id});
  Future<List<BankAccount>?> getAll();
  Future<List<Bank>?> getBanks();
}