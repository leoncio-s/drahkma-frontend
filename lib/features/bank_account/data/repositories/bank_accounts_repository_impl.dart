import 'package:drahkma/core/error/invalid_credentials_exception.dart';
import 'package:drahkma/features/bank_account/data/sources/remote/bank_account_remote_datasource.dart';
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
      await _localDatasource.clearBankAccounts();
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
    } on InvalidCredentialsException{
      rethrow;
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
    BankAccount? savedAccount = await _remoteDatasource.save(dto);
    return savedAccount;
  }

  @override
  Future<void> update(BankAccount dto) async {
    await _remoteDatasource.update(dto);
  }

  @override
  Future<List<Bank>?> getBanks() async {
    List<Bank>? data;
    data = await _remoteDatasource.getBanks();
    return data;

  }
  
}