import 'package:drahkma/features/bank_accounts/data/sources/bank_accounts_remote_datasource.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsRepositoryImpl implements BankAccountsRepository
{
  final BankAccountsRemoteDatasource _datasource;

  BankAccountsRepositoryImpl(BankAccountsRemoteDatasource datasource):_datasource=datasource;

  @override
  Future<void> delete(BankAccount dto) async {
      await _datasource.delete(dto);
  }

  @override
  Future<List<BankAccount>?> getAll() async{
    var data = await _datasource.getAll();
    return data;
  }

  @override
  Future<BankAccount?> getBy({int? id}) async{
    throw UnimplementedError();
  }

  @override
  Future<BankAccount?> save(BankAccount dto) async{
    var data = await _datasource.save(dto);
    return data;
  }

  @override
  Future<void> update(BankAccount dto) async{
    await _datasource.update(dto);
  }

  @override
  Future<List<Bank>?> getBanks() async {
    List<Bank>? data = await _datasource.getBanks();
    return data;
  }
  
}