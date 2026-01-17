import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_accounts/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_accounts/domain/repositories/bank_accounts_repository.dart';

class BankAccountsGetAll implements UseCases<List<BankAccount>?>
{
  final BankAccountsRepository _accountsRepository;
  BankAccountsGetAll(BankAccountsRepository repository) : _accountsRepository = repository;
  
  @override
  Future<List<BankAccount>?> call() async {
    List<BankAccount>? data = await _accountsRepository.getAll();
    return data;
  }
}