import 'package:drahkma/core/interfaces/use_cases.dart';
import 'package:drahkma/features/bank_account/domain/entities/bank_account.dart';
import 'package:drahkma/features/bank_account/domain/repositories/bank_account_repository.dart';

class BankAccountGetAll implements UseCases<List<BankAccount>?>
{
  final BankAccountRepository _accountsRepository;
  BankAccountGetAll(BankAccountRepository repository) : _accountsRepository = repository;
  
  @override
  Future<List<BankAccount>?> call() async {
    List<BankAccount>? data = await _accountsRepository.getAll();
    return data;
  }
}