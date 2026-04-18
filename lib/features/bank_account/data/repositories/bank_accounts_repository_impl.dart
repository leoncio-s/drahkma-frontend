import 'package:drahkma/features/bank_account/data/sources/bank_account_remote_datasource.dart';
import 'package:drahkma/features/bank_account/data/sources/local/bank_account_local_datasource.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountRepositoryImpl implements BankAccountRepository
{
  final BankAccountRemoteDatasource _remoteDatasource;
  final BankAccountLocalDatasource _localDatasource;

  BankAccountRepositoryImpl(BankAccountRemoteDatasource remoteDatasource, BankAccountLocalDatasource localDatasource)
    : _remoteDatasource = remoteDatasource,
      _localDatasource = localDatasource;

  @override
  Future<void> delete(BankAccount dto) async {
    try {
      await _remoteDatasource.delete(dto);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<BankAccount>?> getAll() async {
    try {
      List<BankAccount>? accounts = await _remoteDatasource.getAll();
  
      if (accounts != null) {
        await _localDatasource.saveBankAccounts(accounts);
      }
      return accounts;
    } catch (e) {
      // Fallback to local datasource on network error
      return await _localDatasource.getBankAccounts();
    }
  }

  @override
  Future<BankAccount?> getBy({int? id}) async {
    throw UnimplementedError();
  }

  @override
  Future<BankAccount?> save(BankAccount dto) async {
    try {
      BankAccount? savedAccount = await _remoteDatasource.save(dto);
      if (savedAccount != null) {
        await _localDatasource.saveBankAccounts([savedAccount]);
      }
      return savedAccount;
    } catch (e) {
      // Fallback to local datasource on network error
      return await _localDatasource.getBankAccounts().then((accounts) => accounts?.isEmpty ?? true ? null : accounts?.first);
    }
  }

  @override
  Future<void> update(BankAccount dto) async {
    try {
      await _remoteDatasource.update(dto);
      await _localDatasource.saveBankAccounts([dto]);
    } catch (e) {
      // On network error, at least save to local
      await _localDatasource.saveBankAccounts([dto]);
      rethrow;
    }
  }

  @override
  Future<List<Bank>?> getBanks() async {
    List<Bank>? data;
    data = await _remoteDatasource.getBanks();
    return data;

  }
  
}